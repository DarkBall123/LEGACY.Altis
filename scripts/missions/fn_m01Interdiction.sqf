/*
 * scripts/missions/fn_m01Interdiction.sqf
 * Legacy interdiction mission prototype that spawns and tracks a convoy objective.
 */

if (!isServer) exitWith {};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         west];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];

if (count _cells == 0) exitWith {
    diag_log "[M01] DZ_cells not initialized yet. Aborting.";
    ["failure"] call DZ_fnc_missionEnd;
};


private _enemySectors = [];
{
    private _state    = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    private _counter  = _state param [7, false];
    if (!_captured && !_counter) then {
        _enemySectors pushBack _forEachIndex;
    };
} forEach _cells;

diag_log format ["[M01] Found %1 enemy-held sectors out of %2 total",
    count _enemySectors, count _cells];

if (count _enemySectors < 2) exitWith {
    diag_log "[M01] Not enough enemy sectors for convoy. Aborting.";
    ["failure"] call DZ_fnc_missionEnd;
};


private _startIdx = selectRandom _enemySectors;
private _startPos = _cells select _startIdx;
private _candidates = (_enemySectors - [_startIdx]) select {
    (_cells select _x) distance2D _startPos > 500
};
if (_candidates isEqualTo []) then { _candidates = _enemySectors - [_startIdx]; };

private _endIdx = selectRandom _candidates;
private _endPos = _cells select _endIdx;

diag_log format ["[M01] Convoy route: sector %1 -> sector %2 (%3m)",
    _startIdx, _endIdx, round (_startPos distance2D _endPos)];


private _roadObj  = [_startPos, 200] call BIS_fnc_nearestRoad;
private _spawnPos = if (!isNull _roadObj) then { getPosATL _roadObj } else { _startPos };
private _dir      = _spawnPos getDir _endPos;


private _spec = [
    ["b_afougf_kozak5_turret_armored_full_F",  0],
    ["b_afougf_kraz255b1_fuel", 15],
    ["b_afougf_kraz255b1_fuel", 30],
    ["b_afougf_Ural_Zu23", 45]
];

private _convoyGroup    = createGroup [_sideEnemy, true];
private _convoyVehicles = [];
private _missionUnits   = missionNamespace getVariable ["DZ_missionUnits",    []];
private _missionVehs    = missionNamespace getVariable ["DZ_missionVehicles", []];

{
    _x params ["_class", "_offset"];
    private _pos = _spawnPos getPos [_offset, _dir + 180];
    private _veh = createVehicle [_class, _pos, [], 0, "NONE"];
    _veh setDir _dir;
    _veh setFuel 1;

    createVehicleCrew _veh;
    private _crewArr = crew _veh;
    if (count _crewArr > 0) then {
        private _autoGroup = group (_crewArr # 0);
        _crewArr joinSilent _convoyGroup;
        _autoGroup deleteGroupWhenEmpty true;
    };

    {
        if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_x] call DZ_fnc_prepareSpawnedUnit; };
        _missionUnits pushBack _x;
    } forEach (crew _veh);

    _convoyVehicles pushBack _veh;
    _missionVehs    pushBack _veh;
} forEach _spec;


private _wp = _convoyGroup addWaypoint [_endPos, 30];
_wp setWaypointType        "MOVE";
_wp setWaypointSpeed       "LIMITED";
_wp setWaypointBehaviour   "SAFE";
_wp setWaypointCombatMode  "YELLOW";
_wp setWaypointFormation   "COLUMN";
_convoyGroup setCurrentWaypoint _wp;


private _escortAssets = [_spawnPos, 6] call DZ_fnc_spawnForZone;
private _escortGroups = _escortAssets param [0, []];
{
    private _ewp = _x addWaypoint [_endPos, 50];
    _ewp setWaypointType       "MOVE";
    _ewp setWaypointBehaviour  "AWARE";
    _ewp setWaypointCombatMode "YELLOW";
    {
        _missionUnits pushBack _x;
    } forEach (units _x);
} forEach _escortGroups;


["create", "m01_convoy", _spawnPos, "mil_destroy", "Convoy",      "ColorRed"]   call DZ_fnc_missionUI;
["create", "m01_dest",   _endPos,   "mil_flag",    "Destination", "ColorBlue"]  call DZ_fnc_missionUI;

private _markers = missionNamespace getVariable ["DZ_missionMarkers", []];
_markers append ["m01_convoy", "m01_dest"];


[
    "hint",
    "Миссия 01: Перехват поставок",
    "Замечен конвой снабжения противника.<br/>Уничтожьте все машины конвоя до того, как они достигнут точки назначения.<br/>Позиция конвоя отмечена на карте."
] call DZ_fnc_missionUI;


[_convoyVehicles, _endPos, _escortGroups] spawn {
    params ["_convoyVehicles", "_endPos", "_escortGroups"];

    while { missionNamespace getVariable ["DZ_missionActive", false] } do {

        private _aliveVehicles = _convoyVehicles select { alive _x };

        if (count _aliveVehicles > 0) then {
            "m01_convoy" setMarkerPos (getPos (_aliveVehicles # 0));
        };


        if (count _aliveVehicles == 0) exitWith {

            {
                { if (alive _x) then { deleteVehicle _x; }; } forEach (units _x);
                deleteGroup _x;
            } forEach _escortGroups;
            ["success"] call DZ_fnc_missionEnd;
        };


        private _arrived = _aliveVehicles select { (_x distance2D _endPos) < 80 };
        if (count _arrived > 0) exitWith {
            ["failure"] call DZ_fnc_missionEnd;
        };


        private _started = missionNamespace getVariable ["DZ_missionStart", time];
        if ((time - _started) > 2700) exitWith {
            ["failure"] call DZ_fnc_missionEnd;
        };

        sleep 8;
    };
};
