/*
 * DZ_fnc_startEodMission
 * Starts the EOD road-clearing mission with IEDs, watchers, ambush, and completion checks.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "eod" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["eod"] call DZ_fnc_getMissionDefinition;
    ["eod", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[EOD] DZ_cells not initialized. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
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
    private _sectorPos = _x;
    private _state = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    private _counter  = _state param [7, false];
    if (!_captured && !_counter && !(_forEachIndex in _captHash)) then
    {
        private _minDist = 99999;
        {
            private _d = _sectorPos distance2D _x;
            if (_d < _minDist) then { _minDist = _d; };
        } forEach _playerHeldPositions;

        if (_playerHeldPositions isEqualTo [] ||
            { _minDist >= 1500 && _minDist <= 2500 }) then
        {
            _enemyCandidates pushBack _sectorPos;
        };
    };
} forEach _cells;

if ((count _enemyCandidates) < 2) exitWith
{
    diag_log format ["[EOD] Need 2 enemy sectors in proximity band, only found %1.",
        count _enemyCandidates];
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящих участков не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _routeStart = [0, 0, 0];
private _routeEnd = [0, 0, 0];
private _routePoints = [];
private _foundPair = false;

private _shuffled = +_enemyCandidates;
for "_i" from (count _shuffled - 1) to 1 step -1 do
{
    private _j = floor (random (_i + 1));
    private _tmp = _shuffled # _i;
    _shuffled set [_i, _shuffled # _j];
    _shuffled set [_j, _tmp];
};

private _pairAttempts = 0;
private _maxPairAttempts = 15;

{
    if (_foundPair) exitWith {};
    if (_pairAttempts >= _maxPairAttempts) exitWith {};
    private _a = _x;
    {
        if (_foundPair) exitWith {};
        _pairAttempts = _pairAttempts + 1;
        if (_pairAttempts >= _maxPairAttempts) exitWith {};

        private _b = _x;
        if (_a isNotEqualTo _b) then
        {
            private _d = _a distance2D _b;
            if (_d >= 1500 && _d <= 3000) then
            {
                private _testCount = 12;
                private _snapped = [];

                for "_k" from 0 to (_testCount - 1) do
                {
                    private _t = (_k + 1) / (_testCount + 1);
                    private _samplePos = [
                        ((_a # 0) * (1 - _t)) + ((_b # 0) * _t),
                        ((_a # 1) * (1 - _t)) + ((_b # 1) * _t),
                        0
                    ];

                    private _nearRoads = _samplePos nearRoads 80;
                    if (count _nearRoads > 0) then
                    {
                        private _road = _nearRoads # 0;
                        private _roadPos = getPosATL _road;
                        private _tooClose = false;
                        {
                            if (_x distance2D _roadPos < 100) exitWith { _tooClose = true; };
                        } forEach _snapped;

                        if (!_tooClose) then
                        {
                            _snapped pushBack _roadPos;
                        };
                    };
                };

                if ((count _snapped) >= 3) then
                {
                    _routeStart = _a;
                    _routeEnd = _b;
                    _routePoints = _snapped;
                    _foundPair = true;
                    diag_log format ["[EOD] Pair found after %1 attempts: %2 -> %3 (%4m), %5 road points",
                        _pairAttempts, _a, _b, round _d, count _snapped];
                };
            };
        };
    } forEach _shuffled;
} forEach _shuffled;

if (!_foundPair) exitWith
{
    diag_log format ["[EOD] No road-rich sector pair found after %1 attempts. Aborting.", _pairAttempts];
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящего маршрута не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _routeMidpoint = [
    ((_routeStart # 0) + (_routeEnd # 0)) / 2,
    ((_routeStart # 1) + (_routeEnd # 1)) / 2,
    0
];

private _routeLength = _routeStart distance2D _routeEnd;

private _iedClasses = [
    "IEDLandSmall_F",
    "IEDLandBig_F",
    "IEDUrbanSmall_F",
    "IEDUrbanBig_F"
];
private _availableIeds = _iedClasses select { isClass (configFile >> "CfgVehicles" >> _x) };

if (_availableIeds isEqualTo []) exitWith
{
    diag_log "[EOD] No IED classes found in modset. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

private _validRoutePoints = _routePoints select { _x distance2D _routeMidpoint > 200 };

if ((count _validRoutePoints) < 3) exitWith
{
    diag_log format ["[EOD] Only %1 valid route points after midpoint filter. Aborting.",
        count _validRoutePoints];
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Маршрут слишком короткий. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _iedCount = ((count _validRoutePoints) min 7) max 3;

private _shuffledRoutePoints = +_validRoutePoints;
for "_i" from (count _shuffledRoutePoints - 1) to 1 step -1 do
{
    private _j = floor (random (_i + 1));
    private _tmp = _shuffledRoutePoints # _i;
    _shuffledRoutePoints set [_i, _shuffledRoutePoints # _j];
    _shuffledRoutePoints set [_j, _tmp];
};

private _ieds = [];
private _iedPositions = [];

diag_log format ["[EOD] Placing %1 IEDs at road-snapped points.", _iedCount];

for "_i" from 0 to (_iedCount - 1) do
{
    private _placePos = _shuffledRoutePoints # _i;

    private _jitterX = (random 4) - 2;
    private _jitterY = (random 4) - 2;
    _placePos = [(_placePos # 0) + _jitterX, (_placePos # 1) + _jitterY, _placePos # 2];

    private _iedClass = selectRandom _availableIeds;
    private _ied = createMine [_iedClass, _placePos, [], 0];

    private _hidden = (random 1) < 0.5;
    if (_hidden) then
    {
        private _nearObjects = _placePos nearObjects ["Thing", 6] +
                               _placePos nearObjects ["Bush", 6];

        if (count _nearObjects > 0) then
        {
            private _hideUnder = selectRandom _nearObjects;
            private _newPos = (getPosATL _hideUnder) vectorAdd [(random 1.5) - 0.75, (random 1.5) - 0.75, 0];
            _ied setPosATL _newPos;
            _placePos = _newPos;
        };

        _placePos set [2, ((_placePos # 2) - 0.05 - (random 0.1))];
        _ied setPosATL _placePos;
    };

    _ied setVariable ["DZ_isEodIED", true, true];
    _ied setVariable ["DZ_eodIedIndex", _i, true];
    _ied setVariable ["DZ_eodIedHidden", _hidden, true];

    _ieds pushBack _ied;
    _iedPositions pushBack _placePos;

    diag_log format ["[EOD] IED %1 placed at %2 (hidden=%3, class=%4)",
        _i + 1, _placePos, _hidden, _iedClass];
};

private _watchers = [];
private _watcherGroup = createGroup [_sideEnemy, true];
_watcherGroup setBehaviour "SAFE";
_watcherGroup setCombatMode "YELLOW";

{
    private _ied = _x;
    private _iedPos = getPosATL _ied;

    if ((random 1) < 0.5) then
    {
        private _watcherDist = 200 + (random 200);
        private _watcherAngle = random 360;
        private _watcherPos = _iedPos getPos [_watcherDist, _watcherAngle];

        private _coverObjects = _watcherPos nearObjects ["Tree", 30] +
                                _watcherPos nearObjects ["Building", 50];
        if (count _coverObjects > 0) then
        {
            _watcherPos = (getPosATL (selectRandom _coverObjects)) getPos [3 + (random 5), random 360];
        };

        private _u = _watcherGroup createUnit [
            selectRandom ["UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_SNI"],
            _watcherPos,
            [],
            0,
            "NONE"
        ];
        if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };

        _u allowFleeing 0;
        _u setUnitPos "MIDDLE";
        _u setVariable ["DZ_eodWatcherFor", _ied, true];

        _watchers pushBack _u;
    };
} forEach _ieds;

diag_log format ["[EOD] Spawned %1 watchers", count _watchers];

private _ambushGroup = createGroup [_sideEnemy, true];
_ambushGroup setBehaviour "AWARE";
_ambushGroup setCombatMode "RED";

private _ambushClasses = [
    "UK3CB_WEI_B_TL",
    "UK3CB_WEI_B_AR",
    "UK3CB_WEI_B_AR",
    "UK3CB_WEI_B_RIF_5",
    "UK3CB_WEI_B_RIF_5",
    "UK3CB_WEI_B_AT",
    "UK3CB_WEI_B_SNI"
];

{
    private _angle = random 360;
    private _dist = 50 + (random 50);
    private _spawnPos = _routeMidpoint getPos [_dist, _angle];

    private _u = _ambushGroup createUnit [_x, _spawnPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
    _u allowFleeing 0;
    _u setUnitPos "MIDDLE";
} forEach _ambushClasses;

private _technicalClass = selectRandom ["UK3CB_WEI_B_Hilux_DSHKM", "UK3CB_WEI_B_LR_Opentop_PKM"];
if (isClass (configFile >> "CfgVehicles" >> _technicalClass)) then
{
    private _vehPos = _routeMidpoint getPos [80, random 360];
    private _veh = createVehicle [_technicalClass, _vehPos, [], 0, "NONE"];
    _veh setDir (random 360);

    private _driver = _ambushGroup createUnit ["UK3CB_WEI_B_RIF_5", _vehPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_driver] call DZ_fnc_prepareSpawnedUnit; };
    _driver moveInDriver _veh;

    private _gunner = _ambushGroup createUnit ["UK3CB_WEI_B_AR", _vehPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_gunner] call DZ_fnc_prepareSpawnedUnit; };
    _gunner moveInGunner _veh;

    [[], [_veh], [], [], _missionSide] call DZ_fnc_addMissionAssets;
};

private _wp = _ambushGroup addWaypoint [_routeMidpoint, 30];
_wp setWaypointType "GUARD";
_wp setWaypointBehaviour "AWARE";
_wp setWaypointCombatMode "RED";

diag_log format ["[EOD] Ambush spawned at midpoint %1 (%2 units)",
    _routeMidpoint, count (units _ambushGroup)];

private _allUnits = (units _watcherGroup) + (units _ambushGroup);

["create", "marker_eod_start", _routeStart, "loc_Bunker", "Маршрут: начало"] call DZ_fnc_missionUi;
["create", "marker_eod_end",   _routeEnd,   "loc_Bunker", "Маршрут: конец"] call DZ_fnc_missionUi;

[
    _allUnits,
    _ieds,
    ["marker_eod_start", "marker_eod_end"],
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_eodIeds",          _ieds];
missionNamespace setVariable ["DZ_eodWatchers",      _watchers];
missionNamespace setVariable ["DZ_eodIedMarkersRevealed", []];

[
    "hint",
    "MISSION: РАЗМИНИРОВАНИЕ",
    format [
        "Боевики заминировали участок дороги. На маршруте установлено %1 СВУ. Двигайтесь по маршруту от начала до конца. Найдите и обезвредьте все СВУ (нужен набор сапёра ACE). Будьте осторожны: часть СВУ замаскирована, и захватчики могут наблюдать за дорогой. ВНИМАНИЕ: разведка сообщает о крупной засаде в середине маршрута. Будьте готовы к бою.",
        _iedCount
    ]
] call DZ_fnc_missionUi;

["Разминирование маршрута. Двигайтесь медленно. Подозрительные предметы - возможные СВУ.", _missionSide]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_missionSide", "_ieds", "_watchers"];

        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        private _revealed = missionNamespace getVariable ["DZ_eodIedMarkersRevealed", []];

        {
            private _ied = _x;
            private _iedIdx = _ied getVariable ["DZ_eodIedIndex", -1];

            if (_iedIdx >= 0 && { !isNull _ied } && { alive _ied } && { !(_iedIdx in _revealed) }) then
            {
                private _iedPos = getPosATL _ied;
                private _playerNear = false;
                {
                    if (alive _x &&
                        { (side group _x) in (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]) } &&
                        { _x distance _ied < 50 }) exitWith
                    {
                        _playerNear = true;
                    };
                } forEach allPlayers;

                if (_playerNear) then
                {
                    private _markerName = format ["marker_eod_ied_%1", _iedIdx];
                    [
                        "create",
                        _markerName,
                        _iedPos,
                        "mil_warning",
                        format ["СВУ #%1", _iedIdx + 1]
                    ] call DZ_fnc_missionUi;

                    _revealed pushBack _iedIdx;
                    missionNamespace setVariable ["DZ_eodIedMarkersRevealed", _revealed];

                    [[], [], [_markerName], [], _missionSide] call DZ_fnc_addMissionAssets;

                    [
                        format ["Обнаружено СВУ. Осторожно!"],
                        _missionSide
                    ] remoteExecCall ["DZ_fnc_sideMessage", 0];

                    diag_log format ["[EOD] IED %1 revealed at %2", _iedIdx + 1, _iedPos];
                };
            };
        } forEach _ieds;

        {
            private _watcher = _x;
            if (!alive _watcher) then { continue };

            private _watchedIed = _watcher getVariable ["DZ_eodWatcherFor", objNull];
            if (isNull _watchedIed || { !alive _watchedIed }) then { continue };

            private _targetPlayer = objNull;
            {
                if (alive _x &&
                    { (side group _x) in (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]) } &&
                    { _x distance _watchedIed < 50 }) exitWith
                {
                    _targetPlayer = _x;
                };
            } forEach allPlayers;

            if (isNull _targetPlayer) then { continue };

            private _watcherEye = eyePos _watcher;
            private _playerEye = eyePos _targetPlayer;
            private _intersect = lineIntersectsSurfaces [_watcherEye, _playerEye, _watcher, _targetPlayer];

            if (_intersect isEqualTo []) then
            {
                diag_log format ["[EOD] Watcher %1 detonated IED at %2 (player %3 nearby with LOS)",
                    _watcher, getPosATL _watchedIed, _targetPlayer];

                private _detonatePos = getPosATL _watchedIed;
                private _shell = createVehicle ["Bo_GBU12_LGB", _detonatePos, [], 0, "CAN_COLLIDE"];
                deleteVehicle _watchedIed;

                _watcher setBehaviour "COMBAT";
                _watcher setCombatMode "RED";
                _watcher setVariable ["DZ_eodWatcherFor", objNull, true];

                ["Дистанционная детонация! Боевики наблюдают за дорогой!", _missionSide]
                    remoteExecCall ["DZ_fnc_sideMessage", 0];
            };
        } forEach _watchers;

        private _liveIeds = _ieds select { !isNull _x && { alive _x } };
        if (_liveIeds isEqualTo []) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success", _missionSide] call DZ_fnc_endMission;
            ["Все СВУ обезврежены. Маршрут безопасен.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    2,
    [_missionSide, _ieds, _watchers]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle], _missionSide] call DZ_fnc_addMissionAssets;

true
