/*
 * DZ_fnc_startIdapVehicleRepairMission
 * Starts the IDAP humanitarian vehicle refuel mission.
 * An IDAP van is stranded with an empty fuel tank in hostile
 * territory. Players must reach it, defend against an armoured
 * ambush and refill the tank (ACE jerrycan / fuel truck).
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "idap_repair" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["idap_repair"] call DZ_fnc_getMissionDefinition;
    ["idap_repair", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[IDAP_REPAIR] DZ_cells not initialized. Aborting.";
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

private _candidates = [];
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
            _candidates pushBack _sectorPos;
        };
    };
} forEach _cells;

if (_candidates isEqualTo []) exitWith
{
    diag_log "[IDAP_REPAIR] No suitable sectors. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящих зон не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _shuffled = +_candidates;
for "_i" from (count _shuffled - 1) to 1 step -1 do
{
    private _j = floor (random (_i + 1));
    private _tmp = _shuffled # _i;
    _shuffled set [_i, _shuffled # _j];
    _shuffled set [_j, _tmp];
};

private _breakdownPos = [];
{
    private _sectorPos = _x;
    private _nearRoads = _sectorPos nearRoads 250;
    if (count _nearRoads > 0) exitWith
    {
        private _road = selectRandom _nearRoads;
        _breakdownPos = getPosATL _road;
    };
} forEach _shuffled;

if (_breakdownPos isEqualTo []) exitWith
{
    diag_log "[IDAP_REPAIR] No road found near any candidate sector. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящего участка дороги не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

diag_log format ["[IDAP_REPAIR] Breakdown position: %1", _breakdownPos];

private _vehicleClass = "";
private _vehicleCandidates = [
    "C_IDAP_Van_02_F",
    "C_IDAP_Van_02_medevac_F",
    "C_IDAP_Offroad_01_F",
    "C_Van_02_transport_F",
    "C_Offroad_01_F"
];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _vehicleClass = _x; };
} forEach _vehicleCandidates;

if (_vehicleClass == "") exitWith
{
    diag_log "[IDAP_REPAIR] No IDAP/civilian vehicle class found in modset. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

diag_log format ["[IDAP_REPAIR] Using vehicle class: %1", _vehicleClass];

private _vehicle = createVehicle [_vehicleClass, _breakdownPos, [], 0, "NONE"];
_vehicle setPosATL _breakdownPos;
_vehicle setDir (random 360);
_vehicle setFuel 0;

_vehicle lock 0;
_vehicle setVariable ["DZ_idapRepairVehicle", true, true];

private _driverGroup = createGroup [civilian, true];
private _driverClass = "";
private _driverCandidates = [
    "C_IDAP_Man_AidWorker_01_F",
    "C_IDAP_Man_AidWorker_02_F",
    "C_IDAP_Man_AidWorker_03_F",
    "C_Driver_1_F",
    "C_man_1"
];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _driverClass = _x; };
} forEach _driverCandidates;

if (_driverClass == "") then { _driverClass = "C_man_1"; };

private _driver = _driverGroup createUnit [_driverClass, _breakdownPos, [], 0, "NONE"];
_driver setName "Водитель IDAP";
_driver setCaptive true;
_driver disableAI "MOVE";
_driver disableAI "AUTOTARGET";
_driver disableAI "TARGET";
_driver disableAI "FSM";
_driver setBehaviour "CARELESS";
removeAllWeapons _driver;
_driver moveInDriver _vehicle;
if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_driver] call DZ_fnc_prepareSpawnedUnit; };

diag_log format ["[IDAP_REPAIR] Driver spawned: %1 in vehicle %2", _driver, _vehicle];

["create", "marker_idap_repair", _breakdownPos, "loc_Transmitter", "Транспорт IDAP без топлива"] call DZ_fnc_missionUi;

[
    [_driver],
    [_vehicle],
    ["marker_idap_repair"],
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_idapRepairVehicle",         _vehicle];
missionNamespace setVariable ["DZ_idapRepairDriver",          _driver];
missionNamespace setVariable ["DZ_idapRepairAmbushTriggered", false];

[
    "hint",
    "MISSION: ДОЗАПРАВКА ТРАНСПОРТА IDAP",
    "У гуманитарного автомобиля IDAP закончилось топливо во вражеской территории. Водитель внутри, перепуган и не вооружён.\n\nВаши задачи:\n1) Достичь автомобиля.\n2) Заправить пустой бак (ACE: канистра или топливозаправщик).\n\nВНИМАНИЕ: при приближении к автомобилю захватчики могут устроить засаду с применением бронетехники. Будьте готовы к бою."
] call DZ_fnc_missionUi;

["Гуманитарный конвой IDAP запрашивает топливо. Достигните автомобиля и заправьте бак.", _missionSide]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

private _spawnAmbush = {
    params ["_anchorPos", "_approachDir", "_enemySide", "_missionSide"];

    private _ambushGroup = createGroup [_enemySide, true];

    private _armourClass = "";
    private _armourCandidates = [
        "RHS_BTR60_MSV",
        "RHS_BTR70_MSV",
        "LIB_T34_85",
        "gm_ge_army_t34_85",
        "RHS_BTR80_MSV",
        "RHS_BMP1_MSV"
    ];
    {
        if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _armourClass = _x; };
    } forEach _armourCandidates;

    private _spawnedAssets = [];

    if (_armourClass != "") then
    {
        private _vehPos = _anchorPos getPos [250, _approachDir];
        private _armour = createVehicle [_armourClass, _vehPos, [], 0, "NONE"];
        _armour setDir (_anchorPos getDir _vehPos + 180);

        private _crewClasses = [
            "UK3CB_WEI_B_RIF_5",
            "UK3CB_WEI_B_AR",
            "UK3CB_WEI_B_TL"
        ];
        private _crewSlots = ["Driver", "Gunner", "Commander"];

        {
            private _slot = _x;
            private _crewClass = _crewClasses param [_forEachIndex, "UK3CB_WEI_B_RIF_5"];
            private _u = _ambushGroup createUnit [_crewClass, _vehPos, [], 0, "NONE"];
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
            _u allowFleeing 0;
            switch (_slot) do {
                case "Driver":    { _u moveInDriver    _armour };
                case "Gunner":    { _u moveInGunner    _armour };
                case "Commander": { _u moveInCommander _armour };
            };
        } forEach _crewSlots;

        _spawnedAssets pushBack _armour;
        diag_log format ["[IDAP_REPAIR] Ambush armour spawned: %1 at %2 (%3m from target)",
            _armourClass, _vehPos, round (_vehPos distance2D _anchorPos)];
    }
    else
    {
        diag_log "[IDAP_REPAIR] No armour class available — falling back to infantry-only ambush.";
    };

    private _infantryClasses = [
        "UK3CB_WEI_B_TL",
        "UK3CB_WEI_B_AR",
        "UK3CB_WEI_B_RIF_5",
        "UK3CB_WEI_B_AT"
    ];

    {
        private _spawnAngle = _approachDir + (random 60) - 30;
        private _spawnDist  = 230 + (random 40);
        private _spawnPos   = _anchorPos getPos [_spawnDist, _spawnAngle];

        private _u = _ambushGroup createUnit [_x, _spawnPos, [], 0, "NONE"];
        if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
        _u allowFleeing 0;
    } forEach _infantryClasses;

    _ambushGroup setBehaviour "AWARE";
    _ambushGroup setCombatMode "RED";
    _ambushGroup setSpeedMode "FULL";

    private _wp = _ambushGroup addWaypoint [_anchorPos, 30];
    _wp setWaypointType "SAD";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";

    [units _ambushGroup, _spawnedAssets, [], [], _missionSide] call DZ_fnc_addMissionAssets;

    diag_log format ["[IDAP_REPAIR] Ambush deployed at %1 with %2 infantry + %3 armour vehicle(s)",
        _anchorPos, count _infantryClasses, count _spawnedAssets];

    _ambushGroup
};

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_missionSide", "_vehicle", "_driver", "_breakdownPos", "_startTime", "_spawnAmbushFn", "_enemySide"];

        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (isNull _vehicle || { !alive _vehicle }) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Автомобиль уничтожен. Миссия провалена.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if (isNull _driver || { !alive _driver }) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Водитель погиб. Миссия провалена.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if ((time - _startTime) > 4200) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Время на дозаправку истекло.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        "marker_idap_repair" setMarkerPos (getPosATL _vehicle);

        private _ambushTriggered = missionNamespace getVariable ["DZ_idapRepairAmbushTriggered", false];

        if (!_ambushTriggered) then
        {

            private _nearestPlayer = objNull;
            private _minDist = 99999;
            {
                if (alive _x &&
                    { (side group _x) isEqualTo _missionSide } &&
                    { _x distance2D _vehicle < _minDist }) then
                {
                    _minDist = _x distance2D _vehicle;
                    _nearestPlayer = _x;
                };
            } forEach allPlayers;

            if (!isNull _nearestPlayer && { _minDist < 600 }) then
            {
                missionNamespace setVariable ["DZ_idapRepairAmbushTriggered", true];

                private _approachDir = (getPosATL _vehicle) getDir (getPosATL _nearestPlayer);
                [getPosATL _vehicle, _approachDir, _enemySide, _missionSide] call _spawnAmbushFn;

                ["Засада! Боевики атакуют гуманитарный конвой!", _missionSide]
                    remoteExecCall ["DZ_fnc_sideMessage", 0];
            };
        };

        private _fuelLvl = fuel _vehicle;
        private _fuelOk  = (_fuelLvl > 0.3);

        private _lastLog = missionNamespace getVariable ["DZ_idapRepairLastStateLog", 0];
        if ((time - _lastLog) > 15) then
        {
            missionNamespace setVariable ["DZ_idapRepairLastStateLog", time];
            diag_log format ["[IDAP_REPAIR] State: fuel=%1 ok=%2 vehDmg=%3",
                _fuelLvl, _fuelOk, damage _vehicle];
        };

        if (_fuelOk) exitWith
        {
            diag_log format ["[IDAP_REPAIR] SUCCESS triggered. Final fuel: %1", _fuelLvl];
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success", _missionSide] call DZ_fnc_endMission;
            ["Автомобиль IDAP заправлен. Гуманитарный конвой может продолжить путь.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    3,
    [_missionSide, _vehicle, _driver, _breakdownPos, time, _spawnAmbush, _sideEnemy]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle], _missionSide] call DZ_fnc_addMissionAssets;

true
