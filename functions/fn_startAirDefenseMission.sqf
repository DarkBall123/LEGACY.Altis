/*
 * DZ_fnc_startAirDefenseMission
 * SEAD mission: the Malden Expeditionary Force (MEF) has deployed a
 * radar station, an AAA gun and a SAM launcher near a named settlement.
 * Both player factions (APD, Free Altis) can receive this contract;
 * targets and garrison are MEF (east). Players get only the settlement
 * name and must recon the area, then destroy all three systems.
 *
 * No map markers are placed — the location name in the briefing is the
 * only guidance. 2-hour time limit, high cash reward.
 *
 * Faction note: the systems are east (OPFOR / MEF). Both player sides
 * (west and resistance) are hostile to east, so a live, crewed AAA
 * engages player aircraft regardless of which faction triggers it.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "air_defense" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["air_defense"] call DZ_fnc_getMissionDefinition;
    ["air_defense", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _radarClass = "UK3CB_LDF_I_T810_ZU23";
private _aaaClass   = "UK3CB_LDF_I_T810_ZU23";
private _samClass   = "UK3CB_LDF_I_Igla_AA_pod";

if (
    !isClass (configFile >> "CfgVehicles" >> _radarClass) ||
    { !isClass (configFile >> "CfgVehicles" >> _aaaClass) } ||
    { !isClass (configFile >> "CfgVehicles" >> _samClass) }
) exitWith
{
    diag_log format ["[AIR_DEFENSE] Required classes missing (radar=%1 aaa=%2 sam=%3). Aborting.",
        isClass (configFile >> "CfgVehicles" >> _radarClass),
        isClass (configFile >> "CfgVehicles" >> _aaaClass),
        isClass (configFile >> "CfgVehicles" >> _samClass)];
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[AIR_DEFENSE] DZ_cells not initialized. Aborting.";
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
    diag_log "[AIR_DEFENSE] No suitable sectors. Aborting.";
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

private _locPos = [];
private _locName = "";
{
    private _sectorPos = _x;
    private _locs = nearestLocations [_sectorPos, ["NameVillage", "NameCityCapital", "NameCity", "NameLocal"], 1200];
    if (_locs isNotEqualTo []) exitWith
    {
        private _loc = _locs # 0;
        _locPos = locationPosition _loc;
        _locName = text _loc;
    };
} forEach _shuffled;

if (_locPos isEqualTo []) exitWith
{
    diag_log "[AIR_DEFENSE] No named settlement near any candidate sector. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящего населённого пункта не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

if (_locName == "") then { _locName = "неизвестный район"; };

private _radarPos = [];
for "_i" from 0 to 12 do
{
    private _cand = _locPos getPos [150 + (random 250), random 360];
    if (!surfaceIsWater _cand) exitWith { _radarPos = _cand; };
};
if (_radarPos isEqualTo []) then { _radarPos = _locPos; };

private _aaaPos = _radarPos getPos [40 + (random 30), random 360];
private _samPos = _radarPos getPos [45 + (random 35), random 360];

diag_log format ["[AIR_DEFENSE] Site near '%1' at %2 (radar %3, aaa %4, sam %5)",
    _locName, _locPos, _radarPos, _aaaPos, _samPos];

private _radar = createVehicle [_radarClass, _radarPos, [], 0, "NONE"];
_radar setDir (random 360);
private _radarCrewGrp = createVehicleCrew _radar;

private _aaa = createVehicle [_aaaClass, _aaaPos, [], 0, "NONE"];
_aaa setDir (random 360);
private _aaaCrewGrp = createVehicleCrew _aaa;

private _sam = createVehicle [_samClass, _samPos, [], 0, "NONE"];
_sam setDir (random 360);
private _samCrewGrp = createVehicleCrew _sam;

{
    private _grp = _x;
    if (!isNull _grp) then
    {
        _grp setBehaviour "COMBAT";
        _grp setCombatMode "RED";
        {
            _x disableAI "PATH";
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_x] call DZ_fnc_prepareSpawnedUnit; };
        } forEach (units _grp);
    };
} forEach [_radarCrewGrp, _aaaCrewGrp, _samCrewGrp];

private _garrisonGroup = createGroup [_sideEnemy, true];
private _garrisonClasses = [
    "UK3CB_WEI_B_TL",
    "UK3CB_WEI_B_AR",
    "UK3CB_WEI_B_AR",
    "UK3CB_WEI_B_RIF_5",
    "UK3CB_WEI_B_RIF_5",
    "UK3CB_WEI_B_AT",
    "UK3CB_WEI_B_SNI",
    "UK3CB_WEI_B_TL",
    "UK3CB_WEI_B_RIF_5",
    "UK3CB_WEI_B_AR"
];

{
    private _gPos = _radarPos getPos [15 + (random 70), random 360];
    private _u = _garrisonGroup createUnit [_x, _gPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
    _u allowFleeing 0;
    _u setUnitPos "MIDDLE";
} forEach _garrisonClasses;

private _garrisonWp = _garrisonGroup addWaypoint [_radarPos, 60];
_garrisonWp setWaypointType        "GUARD";
_garrisonWp setWaypointBehaviour   "AWARE";
_garrisonWp setWaypointCombatMode  "RED";
_garrisonGroup setBehaviour "AWARE";
_garrisonGroup setCombatMode "RED";

private _vehicles = [];
private _technicalClass = selectRandom ["UK3CB_WEI_B_Hilux_DSHKM", "UK3CB_WEI_B_LR_Opentop_PKM"];
if (isClass (configFile >> "CfgVehicles" >> _technicalClass)) then
{
    private _vehPos = _radarPos getPos [90 + (random 40), random 360];
    private _veh = createVehicle [_technicalClass, _vehPos, [], 0, "NONE"];
    _veh setDir (random 360);

    private _driver = _garrisonGroup createUnit ["UK3CB_WEI_B_RIF_5", _vehPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_driver] call DZ_fnc_prepareSpawnedUnit; };
    _driver moveInDriver _veh;

    private _gunner = _garrisonGroup createUnit ["UK3CB_WEI_B_AR", _vehPos, [], 0, "NONE"];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_gunner] call DZ_fnc_prepareSpawnedUnit; };
    _gunner moveInGunner _veh;

    _vehicles pushBack _veh;
};

private _allUnits = (units _garrisonGroup);
{ _allUnits append (units _x); } forEach [_radarCrewGrp, _aaaCrewGrp, _samCrewGrp];

[
    _allUnits,
    [_radar, _aaa, _sam] + _vehicles,
    [],
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_airDefenseRadar", _radar];
missionNamespace setVariable ["DZ_airDefenseAAA",   _aaa];
missionNamespace setVariable ["DZ_airDefenseSAM",   _sam];

[
    "hint",
    "MISSION: ПОДАВЛЕНИЕ ПВО",
    format [
        "Мальденские оккупационные силы (MEF) развернули радиолокационную станцию (РЛС), зенитный комплекс (ЗАК) и зенитно-ракетный комплекс (ЗРК) в районе населённого пункта %1. Точные координаты неизвестны — проведите разведку и уничтожьте ВСЕ ТРИ объекта.\n\nОтметок на карте нет. Ориентируйтесь по названию населённого пункта.\n\nВНИМАНИЕ: ПВО активна. Применение авиации крайне опасно. Объект охраняется силами MEF.",
        _locName
    ]
] call DZ_fnc_missionUi;

[
    format ["Разведка докладывает о ПВО противника в районе %1. Найдите и уничтожьте РЛС, ЗАК и ЗРК.", _locName],
    _missionSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_missionSide", "_radar", "_aaa", "_sam", "_startTime", "_locName"];

        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if ((time - _startTime) > 7800) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Время на уничтожение ПВО истекло.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _radarDead = (isNull _radar) || { !alive _radar };
        private _aaaDead   = (isNull _aaa)   || { !alive _aaa };
        private _samDead   = (isNull _sam)   || { !alive _sam };

        if (_radarDead && { !(missionNamespace getVariable ["DZ_airDefenseRadarReported", false]) }) then
        {
            missionNamespace setVariable ["DZ_airDefenseRadarReported", true];
            ["РЛС противника уничтожена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
        if (_aaaDead && { !(missionNamespace getVariable ["DZ_airDefenseAAAReported", false]) }) then
        {
            missionNamespace setVariable ["DZ_airDefenseAAAReported", true];
            ["Зенитный комплекс (ЗАК) уничтожен.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
        if (_samDead && { !(missionNamespace getVariable ["DZ_airDefenseSAMReported", false]) }) then
        {
            missionNamespace setVariable ["DZ_airDefenseSAMReported", true];
            ["Зенитно-ракетный комплекс (ЗРК) уничтожен.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if (_radarDead && _aaaDead && _samDead) exitWith
        {
            diag_log "[AIR_DEFENSE] SUCCESS: all systems destroyed.";
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success", _missionSide] call DZ_fnc_endMission;
            ["ПВО противника полностью уничтожена. Воздушное пространство свободно.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    5,
    [_missionSide, _radar, _aaa, _sam, time, _locName]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle], _missionSide] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_airDefenseRadarReported", false];
missionNamespace setVariable ["DZ_airDefenseAAAReported", false];
missionNamespace setVariable ["DZ_airDefenseSAMReported", false];

true
