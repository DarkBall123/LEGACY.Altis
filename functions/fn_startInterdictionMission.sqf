/*
 * DZ_fnc_startInterdictionMission
 *
 * Mission 01 — Convoy Interdiction (SERVER ONLY).
 *
 * Picks two random enemy-held sectors (start far apart from each other),
 * snaps both to nearest road, spawns a 3-vehicle convoy (M113 escort +
 * 2 supply trucks), attaches optional escort infantry, tracks win/lose
 * conditions in a CBA per-frame handler.
 *
 * Lifecycle: prepareMissionState -> spawn -> CBA per-frame handlers ->
 * endMission.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "interdiction" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["interdiction"] call DZ_fnc_getMissionDefinition;
    ["interdiction", "manual", _definition] call DZ_fnc_prepareMissionState;
};

// ── Find enemy-held sectors ──────────────────────────────
private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];

if (_cells isEqualTo []) exitWith
{
    diag_log "[INTERDICTION] DZ_cells not initialized. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

private _enemySectors = [];
{
    private _state    = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    private _counter  = _state param [7, false];
    if (!_captured && !_counter) then
    {
        _enemySectors pushBack _forEachIndex;
    };
} forEach _cells;

if (count _enemySectors < 2) exitWith
{
    diag_log "[INTERDICTION] Not enough enemy sectors for convoy. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

// ── Pick start/end with road-snap and minimum distance ───
// Try up to 5 random pairs to find one where both endpoints have a road
// nearby and the route is at least 1km long.
private _startPos = [];
private _endPos = [];
private _spawnPos = [];

for "_attempt" from 1 to 5 do
{
    private _startIdx = selectRandom _enemySectors;
    private _candidates = (_enemySectors - [_startIdx]) select {
        (_cells select _x) distance2D (_cells select _startIdx) > 1000
    };
    if (_candidates isEqualTo []) then { _candidates = _enemySectors - [_startIdx]; };
    if (_candidates isEqualTo []) then { continue };

    private _endIdx = selectRandom _candidates;
    private _candStart = _cells select _startIdx;
    private _candEnd   = _cells select _endIdx;

    // Snap to roads
    private _startRoad = [_candStart, 250] call BIS_fnc_nearestRoad;
    private _endRoad   = [_candEnd,   250] call BIS_fnc_nearestRoad;

    if (!isNull _startRoad && { !isNull _endRoad }) exitWith
    {
        _startPos = _candStart;
        _endPos   = getPosATL _endRoad;
        _spawnPos = getPosATL _startRoad;
    };

    // Last attempt — fall back to using sector centers even without road snap
    if (_attempt == 5) then
    {
        _startPos = _candStart;
        _endPos   = _candEnd;
        _spawnPos = if (!isNull _startRoad) then { getPosATL _startRoad } else { _candStart };
    };
};

if (_spawnPos isEqualTo []) exitWith
{
    diag_log "[INTERDICTION] Could not find suitable convoy route. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

private _convoyDir = _spawnPos getDir _endPos;

diag_log format ["[INTERDICTION] Convoy route: %1m, spawn at %2 -> dest at %3",
    round (_spawnPos distance2D _endPos), _spawnPos, _endPos];

// ── Convoy composition ───────────────────────────────────
// Position 1 (lead/escort): M113 — provides AT threat
// Position 2-3 (cargo):     supply trucks
private _vehicleDefs =
[
    ["LOP_AFR_M113_W",  0],
    ["LOP_AFR_Landrover",  18],
    ["LOP_AFR_T34",  36]
];

// Single shared group for column movement
private _convoyGroup    = createGroup [_sideEnemy, true];
private _convoyVehicles = [];
private _missionUnits   = [];

{
    _x params ["_className", "_offset"];

    private _pos     = _spawnPos getPos [_offset, _convoyDir + 180];
    private _vehicle = createVehicle [_className, _pos, [], 0, "NONE"];
    _vehicle setDir _convoyDir;
    _vehicle setFuel 1;

    createVehicleCrew _vehicle;

    private _crewArr = crew _vehicle;
    if (count _crewArr > 0) then
    {
        private _autoGroup = group (_crewArr # 0);
        _crewArr joinSilent _convoyGroup;
        _autoGroup deleteGroupWhenEmpty true;
    };

    {
        _x setSkill 0.5;
        _missionUnits pushBack _x;
    } forEach (crew _vehicle);

    _convoyVehicles pushBack _vehicle;
} forEach _vehicleDefs;

private _waypoint = _convoyGroup addWaypoint [_endPos, 30];
_waypoint setWaypointType        "MOVE";
_waypoint setWaypointSpeed       "LIMITED";
_waypoint setWaypointBehaviour   "SAFE";
_waypoint setWaypointCombatMode  "YELLOW";
_waypoint setWaypointFormation   "COLUMN";
_convoyGroup setCurrentWaypoint _waypoint;

["create", "marker_convoy",      _spawnPos, "mil_destroy", "Convoy"]      call DZ_fnc_missionUi;
["create", "marker_convoy_dest", _endPos,   "mil_flag",    "Destination"] call DZ_fnc_missionUi;

[
    _missionUnits,
    _convoyVehicles,
    ["marker_convoy", "marker_convoy_dest"],
    []
] call DZ_fnc_addMissionAssets;

[
    "hint",
    "MISSION: SUPPLY INTERDICTION",
    "Замечен конвой снабжения боевиков. Уничтожьте все машины конвоя до прибытия в пункт назначения. Позиция конвоя отмечена на карте."
] call DZ_fnc_missionUi;

private _markerHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_convoyVehicles"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        private _aliveVehicles = _convoyVehicles select { alive _x };
        if (_aliveVehicles isNotEqualTo []) then
        {
            "marker_convoy" setMarkerPos (getPos (_aliveVehicles # 0));
        };
    },
    10,
    [_convoyVehicles]
] call CBA_fnc_addPerFrameHandler;

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_convoyVehicles", "_endPos"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        private _aliveVehicles = _convoyVehicles select { alive _x };

        if (_aliveVehicles isEqualTo []) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success"] call DZ_fnc_endMission;
            ["Конвой уничтожен. Миссия завершена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _arrived = _aliveVehicles select { (_x distance2D _endPos) < 80 };
        if (_arrived isNotEqualTo []) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
        };
    },
    5,
    [_convoyVehicles, _endPos]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_markerHandle, _stateHandle]] call DZ_fnc_addMissionAssets;

true
