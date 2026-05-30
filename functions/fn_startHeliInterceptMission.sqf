/*
 * DZ_fnc_startHeliInterceptMission
 * Intercept a roaming enemy helicopter that patrols and searches the
 * area of operations. Players must find and destroy it.
 *
 * The helicopter flies a cyclic patrol of random points across the map
 * and engages players it detects. A live map marker tracks its current
 * position so it can actually be intercepted.
 *
 * Success: helicopter destroyed. Fail: time limit reached.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

// Wave 4: resolve the side this mission belongs to.
private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "heli_intercept" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["heli_intercept"] call DZ_fnc_getMissionDefinition;
    ["heli_intercept", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _heliClass = "Orkun_MTF_LittleBird_Armed";

if (!isClass (configFile >> "CfgVehicles" >> _heliClass)) exitWith
{
    diag_log format ["[HELI_INTERCEPT] Class %1 missing. Aborting.", _heliClass];
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

private _ws = worldSize;

// Patrol bias point: map centre, used so the heli roams the playable
// area rather than the extreme corners.
private _center = [_ws * 0.5, _ws * 0.5, 0];

// Spawn well away from base, airborne.
private _spawnPos = [];
for "_i" from 0 to 12 do
{
    private _cand = [
        (_ws * 0.15) + (random (_ws * 0.7)),
        (_ws * 0.15) + (random (_ws * 0.7)),
        0
    ];
    if (!surfaceIsWater _cand) exitWith { _spawnPos = _cand; };
};
if (_spawnPos isEqualTo []) then { _spawnPos = _center; };

private _heli = createVehicle [_heliClass, _spawnPos, [], 0, "FLY"];
_heli setDir (random 360);
_heli flyInHeight 130;

private _crewGrp = createVehicleCrew _heli;
_crewGrp setBehaviour "AWARE";
_crewGrp setCombatMode "RED";
_crewGrp setSpeedMode "NORMAL";
{
    _x allowFleeing 0;
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_x] call DZ_fnc_prepareSpawnedUnit; };
} forEach (units _crewGrp);

// Cyclic patrol of random points across the AO.
private _wpCount = 7;
for "_i" from 1 to _wpCount do
{
    private _p = [];
    for "_a" from 0 to 8 do
    {
        private _cand = [
            (_ws * 0.12) + (random (_ws * 0.76)),
            (_ws * 0.12) + (random (_ws * 0.76)),
            0
        ];
        if (!surfaceIsWater _cand) exitWith { _p = _cand; };
    };
    if (_p isEqualTo []) then { _p = _center; };

    private _wp = _crewGrp addWaypoint [_p, 0];
    _wp setWaypointType        "MOVE";
    _wp setWaypointBehaviour    "AWARE";
    _wp setWaypointCombatMode   "RED";
    _wp setWaypointSpeed        "NORMAL";
    _wp setWaypointStatements   ["true", ""];
};

private _cycleWp = _crewGrp addWaypoint [_spawnPos, 0];
_cycleWp setWaypointType "CYCLE";

diag_log format ["[HELI_INTERCEPT] Heli %1 spawned at %2 with %3 patrol waypoints",
    _heliClass, _spawnPos, _wpCount];

["create", "marker_heli", _spawnPos, "o_air", "Вертолёт противника"] call DZ_fnc_missionUi;

[
    units _crewGrp,
    [_heli],
    ["marker_heli"],
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_heliInterceptTarget", _heli];

[
    "hint",
    "MISSION: ПЕРЕХВАТ ВЕРТОЛЁТА",
    "Вражеский вертолёт патрулирует район и ведёт разведку. Перехватите и уничтожьте его.\n\nТекущее положение вертолёта отмечено на карте. Используйте средства ПВО, авиацию или огонь с земли.\n\nОСТОРОЖНО: вертолёт вооружён и атакует обнаруженные цели."
] call DZ_fnc_missionUi;

["Замечен вражеский вертолёт. Перехватите и уничтожьте его — позиция на карте.", _missionSide]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_missionSide", "_heli", "_startTime"];

        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (isNull _heli || { !alive _heli }) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            diag_log "[HELI_INTERCEPT] SUCCESS: helicopter destroyed.";
            ["success", _missionSide] call DZ_fnc_endMission;
            ["Вражеский вертолёт уничтожен. Отличная работа!", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if ((time - _startTime) > 3600) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Вертолёт ушёл из зоны. Перехват не удался.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        "marker_heli" setMarkerPos (getPosATL _heli);
    },
    2,
    [_missionSide, _heli, time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle], _missionSide] call DZ_fnc_addMissionAssets;

true
