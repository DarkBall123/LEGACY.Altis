/*
 * DZ_fnc_startDownedPilotMission
 * Starts the downed pilot rescue mission and tracks pilot extraction.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "downed_pilot" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["downed_pilot"] call DZ_fnc_getMissionDefinition;
    ["downed_pilot", "manual", _definition] call DZ_fnc_prepareMissionState;
};


private _extractMarker = missionNamespace getVariable ["DZ_pilotExtractionMarker", ""];
private _extractPos   = missionNamespace getVariable ["DZ_pilotExtractionPos",    []];

if (_extractMarker != "" && { getMarkerType _extractMarker != "" }) then
{
    _extractPos = getMarkerPos _extractMarker;
};

if (_extractPos isEqualTo []) then
{
    {
        if (getMarkerType _x != "") exitWith { _extractPos = getMarkerPos _x; };
    } forEach ["respawn_east", "respawn_west", "respawn_guerrila"];
};

if (_extractPos isEqualTo [] || { _extractPos isEqualTo [0,0,0] }) exitWith
{
    diag_log "[DOWNED_PILOT] No extraction point configured. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};


private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[DOWNED_PILOT] DZ_cells not initialized. Aborting.";
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


private _candidates = [];
{
    private _state = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    private _counter  = _state param [7, false];
    if (!_captured && !_counter && !(_forEachIndex in _captHash)) then
    {
        private _sectorPos = _x;
        private _distFromExtract = _sectorPos distance2D _extractPos;
        private _minDistFromPlayers = 99999;
        {
            private _d = _sectorPos distance2D _x;
            if (_d < _minDistFromPlayers) then { _minDistFromPlayers = _d; };
        } forEach _playerHeldPositions;

        if (_distFromExtract > 800 &&
            (_playerHeldPositions isEqualTo [] ||
             { _minDistFromPlayers >= 1500 && _minDistFromPlayers <= 2500 })) then
        {
            _candidates pushBack [_forEachIndex, _minDistFromPlayers];
        };
    };
} forEach _cells;


if (_candidates isEqualTo []) then
{
    diag_log "[DOWNED_PILOT] No sectors in 1500-2500m band, falling back";
    {
        private _state = _zoneData param [_forEachIndex, _zoneTpl];
        private _captured = _state param [4, false];
        private _counter  = _state param [7, false];
        if (!_captured && !_counter && !(_forEachIndex in _captHash) &&
            { _x distance2D _extractPos > 800 }) then
        {
            _candidates pushBack [_forEachIndex, 0];
        };
    } forEach _cells;
};

if (_candidates isEqualTo []) exitWith
{
    diag_log "[DOWNED_PILOT] No suitable sectors. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих зон не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _selected = selectRandom _candidates;
private _sectorIdx    = _selected # 0;
private _sectorCenter = _cells select _sectorIdx;

diag_log format ["[DOWNED_PILOT] Crash sector: %1 at %2 (%3m from player territory, %4m from extract)",
    _sectorIdx, _sectorCenter, round (_selected # 1), round (_sectorCenter distance2D _extractPos)];


private _crashPos = _sectorCenter;
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
        _crashPos = selectRandom _positions;
    };
};


private _spawnResult = [_sectorCenter, 6] call DZ_fnc_spawnForZone;
_spawnResult params [["_defenderGroups", []], ["_defenderVehicles", []], ["_defenderUnitCount", 0]];

private _defenderUnits = [];
{
    _defenderUnits append (units _x);
} forEach _defenderGroups;


private _guardGroup = createGroup [_sideEnemy, true];
private _guardClasses = [
    "LOP_AFR_Infantry_TL",
    "LOP_AFR_Infantry_Rifleman",
    "LOP_AFR_Infantry_AR",
    "LOP_AFR_Infantry_AT"
];
private _guards = [];
{
    private _gPos = _crashPos getPos [3 + (_forEachIndex * 1.5), 90 * _forEachIndex];
    private _g = _guardGroup createUnit [_x, _gPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_g] call DZ_fnc_prepareSpawnedUnit; };
    _guards pushBack _g;
} forEach _guardClasses;

private _guardWp = _guardGroup addWaypoint [_crashPos, 25];
_guardWp setWaypointType        "GUARD";
_guardWp setWaypointBehaviour   "AWARE";
_guardWp setWaypointCombatMode  "YELLOW";
_guardGroup setBehaviour "AWARE";

diag_log format ["[DOWNED_PILOT] Spawned %1 guards at crash site %2", count _guards, _crashPos];


private _pilotGroup = createGroup [civilian, true];
private _pilot = _pilotGroup createUnit ["rhs_pilot_tan", _crashPos, [], 0, "NONE"];
_pilot setName "Капитан Орлов";
_pilot setCaptive true;
_pilot disableAI "MOVE";
_pilot disableAI "AUTOTARGET";
_pilot disableAI "TARGET";
removeAllWeapons _pilot;
_pilot setUnitPos "MIDDLE";

if (!isNil "DZ_fnc_prepareSpawnedUnit") then
{
    [_pilot] call DZ_fnc_prepareSpawnedUnit;
};

diag_log format ["[DOWNED_PILOT] Pilot spawned: %1 at %2", _pilot, getPosATL _pilot];


["create", "marker_pilot",   _sectorCenter, "mil_pickup", "Сбитый пилот"] call DZ_fnc_missionUi;
["create", "marker_extract", _extractPos,   "mil_end",    "Эвакуация"]    call DZ_fnc_missionUi;

[
    [_pilot] + _guards + _defenderUnits,
    _defenderVehicles,
    ["marker_pilot", "marker_extract"],
    []
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_pilotMissionTarget",  _pilot];
missionNamespace setVariable ["DZ_pilotMissionRescued", false];
missionNamespace setVariable ["DZ_pilotMissionGuards",  _guards];

[
    "hint",
    "MISSION: ПОИСК И СПАСЕНИЕ",
    format [
        "Капитан Орлов сбит и удерживается боевиками. Уничтожьте охрану крушения. Любой боец нашей стороны должен подойти к пилоту (50м). Эвакуируйте пилота в безопасную зону. Дистанция до точки эвакуации: ~%1м",
        round (_sectorCenter distance2D _extractPos)
    ]
] call DZ_fnc_missionUi;


private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_pilot", "_guards", "_extractPos", "_startTime"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (isNull _pilot || { !alive _pilot }) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            ["Пилот погиб. Миссия провалена.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if ((time - _startTime) > 6000) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            ["Время на спасение истекло.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _rescued = missionNamespace getVariable ["DZ_pilotMissionRescued", false];

        if (!_rescued) then
        {

            private _activeGuards = _guards select {
                !isNull _x &&
                { alive _x } &&
                { !(_x getVariable ["ACE_isUnconscious", false]) }
            };

            if (_activeGuards isEqualTo []) then
            {

                private _sidePlayers = missionNamespace getVariable ["CH_sidePlayers", east];
                private _rescuer = objNull;
                {
                    if (alive _x &&
                        { (side group _x) isEqualTo _sidePlayers } &&
                        { _x distance _pilot < 50 }) exitWith
                    {
                        _rescuer = _x;
                    };
                } forEach allPlayers;

                if (!isNull _rescuer) then
                {
                    diag_log format ["[DOWNED_PILOT] RESCUE TRIGGERED: rescuer=%1, distance=%2m, guards remaining=0",
                        name _rescuer, round (_rescuer distance _pilot)];

                    missionNamespace setVariable ["DZ_pilotMissionRescued", true];


                    _pilot enableAI "MOVE";
                    _pilot enableAI "AUTOTARGET";
                    _pilot enableAI "TARGET";
                    _pilot setCaptive false;
                    _pilot setUnitPos "AUTO";


                    private _rescuerGroup = group _rescuer;
                    [_pilot] joinSilent _rescuerGroup;


                    diag_log format ["[DOWNED_PILOT] Pilot joined group %1 (side: %2)",
                        _rescuerGroup, side _rescuerGroup];

                    _pilot doFollow leader _rescuerGroup;

                    "marker_pilot" setMarkerType "mil_join";
                    "marker_pilot" setMarkerText "Пилот спасён";

                    [
                        "Штаб",
                        format ["%1 нашёл пилота. Эвакуируйте его в безопасную зону.", name _rescuer]
                    ] remoteExecCall ["DZ_fnc_showHint", 0];

                    ["Пилот освобождён. Эвакуируйте его в безопасную зону.", east]
                        remoteExecCall ["DZ_fnc_sideMessage", 0];
                }
                else
                {


                    private _lastLog = missionNamespace getVariable ["DZ_pilotProxLogTime", 0];
                    if (time - _lastLog > 10) then
                    {
                        missionNamespace setVariable ["DZ_pilotProxLogTime", time];
                        private _closest = 99999;
                        {
                            if (alive _x &&
                                { (side group _x) isEqualTo _sidePlayers } &&
                                { _x distance _pilot < _closest }) then
                            {
                                _closest = _x distance _pilot;
                            };
                        } forEach allPlayers;
                        diag_log format ["[DOWNED_PILOT] Guards eliminated, awaiting player. Closest OPFOR player: %1m from pilot",
                            round _closest];
                    };
                };
            };
        };

        if (_rescued) then
        {
            "marker_pilot" setMarkerPos (getPosATL _pilot);


            private _atExtract = false;
            if (_pilot distance2D _extractPos < 50) then { _atExtract = true; };
            if (!_atExtract) then
            {
                {
                    if (alive _x && { _x distance2D _extractPos < 50 }) exitWith
                    {
                        _atExtract = true;
                    };
                } forEach (units group _pilot);
            };

            if (_atExtract && { alive _pilot } && { _pilot distance2D _extractPos < 200 }) exitWith
            {
                [_handle] call CBA_fnc_removePerFrameHandler;
                ["success"] call DZ_fnc_endMission;
                ["Пилот доставлен в безопасную зону. Отличная работа!", east]
                    remoteExecCall ["DZ_fnc_sideMessage", 0];
            };
        };
    },
    1,
    [_pilot, _guards, _extractPos, time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle]] call DZ_fnc_addMissionAssets;

true
