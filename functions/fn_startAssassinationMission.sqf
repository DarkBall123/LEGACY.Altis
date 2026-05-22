/*
 * DZ_fnc_startAssassinationMission
 * Starts the assassination mission and tracks target discovery and completion.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "assassination" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["assassination"] call DZ_fnc_getMissionDefinition;
    ["assassination", "manual", _definition] call DZ_fnc_prepareMissionState;
};


private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[ASSASSINATION] DZ_cells not initialized. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};


private _playerHeldPositions = [];
{
    private _state = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    if (_captured || { _forEachIndex in _captHash }) then
    {
        _playerHeldPositions pushBack _x;
    };
} forEach _cells;


private _enemyCandidates = [];
{
    private _state = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    private _counter  = _state param [7, false];
    if (!_captured && !_counter && !(_forEachIndex in _captHash)) then
    {
        private _sectorPos = _x;
        private _minDist = 99999;
        {
            private _d = _sectorPos distance2D _x;
            if (_d < _minDist) then { _minDist = _d; };
        } forEach _playerHeldPositions;


        if (_playerHeldPositions isEqualTo [] ||
            { _minDist >= 1500 && _minDist <= 2500 }) then
        {
            _enemyCandidates pushBack [_forEachIndex, _minDist];
        };
    };
} forEach _cells;


if (_enemyCandidates isEqualTo []) then
{
    diag_log "[ASSASSINATION] No sectors in 1500-2500m band, falling back to any enemy sector";
    {
        private _state = _zoneData param [_forEachIndex, _zoneTpl];
        private _captured = _state param [4, false];
        private _counter  = _state param [7, false];
        if (!_captured && !_counter && !(_forEachIndex in _captHash)) then
        {
            _enemyCandidates pushBack [_forEachIndex, 0];
        };
    } forEach _cells;
};

if (_enemyCandidates isEqualTo []) exitWith
{
    diag_log "[ASSASSINATION] No enemy sectors available. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих целей не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _selected = selectRandom _enemyCandidates;
private _sectorIdx    = _selected # 0;
private _sectorCenter = _cells select _sectorIdx;

diag_log format ["[ASSASSINATION] Target sector: %1 at %2 (%3m from nearest player territory)",
    _sectorIdx, _sectorCenter, round (_selected # 1)];


private _spawnResult = [_sectorCenter, 8] call DZ_fnc_spawnForZone;
_spawnResult params [["_defenderGroups", []], ["_defenderVehicles", []], ["_defenderUnitCount", 0]];

private _defenderUnits = [];
{
    _defenderUnits append (units _x);
} forEach _defenderGroups;


private _targetPos = _sectorCenter;
private _nearbyBuildings = nearestObjects [_sectorCenter, ["House"], 80] select
{
    (_x buildingPos -1) isNotEqualTo []
};

if (_nearbyBuildings isNotEqualTo []) then
{
    private _building = selectRandom _nearbyBuildings;
    private _positions = _building buildingPos -1;
    if (_positions isNotEqualTo []) then
    {
        _targetPos = selectRandom _positions;
    };
};

private _targetGroup = createGroup [_sideEnemy, true];
private _target = _targetGroup createUnit ["LOP_AFR_Infantry_SL", _targetPos, [], 0, "NONE"];
_target setName "Командир Сулейман";
_target setSkill 0.7;
_target setUnitPos "UP";

if (!isNil "DZ_fnc_prepareSpawnedUnit") then
{
    [_target] call DZ_fnc_prepareSpawnedUnit;
};

["create", "marker_assassination", _sectorCenter, "mil_objective", "HVT"] call DZ_fnc_missionUi;

[
    [_target] + _defenderUnits,
    _defenderVehicles,
    ["marker_assassination"],
    []
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_assassinationTarget",     _target];
missionNamespace setVariable ["DZ_assassinationIntelTaken", false];
missionNamespace setVariable ["DZ_assassinationKilled",     false];

[
    "hint",
    "MISSION: ELIMINATE TARGET",
    "Командир местной ячейки боевиков замечен в районе. Ликвидируйте полевого командира. Любой боец нашей стороны может забрать документы с тела (подойдите вплотную). Местоположение отмечено на карте."
] call DZ_fnc_missionUi;


_target addEventHandler [
    "Killed",
    {
        params ["_unit"];
        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_assassinationKilled", false]) exitWith {};

        missionNamespace setVariable ["DZ_assassinationKilled", true];

        ["Командир ликвидирован. Любой боец может забрать документы с тела.", east]
            remoteExecCall ["DZ_fnc_sideMessage", 0];

        "marker_assassination" setMarkerType "mil_pickup";
        "marker_assassination" setMarkerText "Документы";
    }
];


private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_target", "_startTime"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };


        if (missionNamespace getVariable ["DZ_assassinationIntelTaken", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success"] call DZ_fnc_endMission;
        };


        if (isNull _target) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
        };


        if ((time - _startTime) > 4200) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            ["Командир скрылся. Время истекло.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };


        if (alive _target) exitWith {};


        "marker_assassination" setMarkerPos (getPosATL _target);


        private _sidePlayers = missionNamespace getVariable ["CH_sidePlayers", east];
        private _picker = objNull;
        {
            if (alive _x &&
                { (side group _x) isEqualTo _sidePlayers } &&
                { _x distance _target < 3 }) exitWith
            {
                _picker = _x;
            };
        } forEach allPlayers;

        if (!isNull _picker) then
        {
            missionNamespace setVariable ["DZ_assassinationIntelTaken", true];
            diag_log format ["[ASSASSINATION] Intel collected by %1", name _picker];

            [
                "Штаб",
                format ["%1 забрал документы. Миссия завершена.", name _picker]
            ] remoteExecCall ["DZ_fnc_showHint", 0];

            ["Документы получены. Миссия выполнена.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    1,
    [_target, time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle]] call DZ_fnc_addMissionAssets;

true
