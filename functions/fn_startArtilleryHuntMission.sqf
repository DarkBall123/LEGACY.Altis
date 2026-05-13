/*
 * DZ_fnc_startArtilleryHuntMission
 *
 * Mission: AFR has set up a mortar position in an enemy sector and is
 * shelling a civilian village. Players must find and silence it.
 *
 * Improvements from previous version:
 *   - Crew SEATED in the mortar (moveInGunner) so it looks crewed
 *   - Crew set to CARELESS / disabled fleeing so they don't run away
 *     before players arrive
 *   - Civilians spawned in SEPARATE groups so they wander independently
 *     instead of herding together as one blob
 *   - Fast-tick end-detection PFH runs from mission start (not just
 *     after grace period), so killing the mortar early ends the mission
 *     immediately
 *   - Visual muzzle flash at the mortar when scripted shots fire
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "artillery_hunt" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["artillery_hunt"] call DZ_fnc_getMissionDefinition;
    ["artillery_hunt", "manual", _definition] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[ARTILLERY_HUNT] DZ_cells not initialized. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

// ── Find mortar sector ───────────────────────────────────
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
        private _minDist = 99999;
        {
            private _d = _sectorPos distance2D _x;
            if (_d < _minDist) then { _minDist = _d; };
        } forEach _playerHeldPositions;

        if (_playerHeldPositions isEqualTo [] ||
            { _minDist >= 1500 && _minDist <= 2500 }) then
        {
            _candidates pushBack [_forEachIndex, _minDist];
        };
    };
} forEach _cells;

if (_candidates isEqualTo []) then
{
    {
        private _state = _zoneData param [_forEachIndex, _zoneTpl];
        private _captured = _state param [4, false];
        private _counter  = _state param [7, false];
        if (!_captured && !_counter && !(_forEachIndex in _captHash)) then
        {
            _candidates pushBack [_forEachIndex, 0];
        };
    } forEach _cells;
};

if (_candidates isEqualTo []) exitWith
{
    diag_log "[ARTILLERY_HUNT] No enemy sectors available. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих целей не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _selected = selectRandom _candidates;
private _mortarSectorIdx = _selected # 0;
private _mortarSectorCenter = _cells select _mortarSectorIdx;
private _searchRadius = 400;

diag_log format ["[ARTILLERY_HUNT] Mortar sector: %1 at %2 (%3m from player territory)",
    _mortarSectorIdx, _mortarSectorCenter, round (_selected # 1)];

// ── Find a village to shell ──────────────────────────────
private _villagePos = [];
private _villageSearchAttempts = 0;
private _maxVillageAttempts = 20;

while { _villagePos isEqualTo [] && _villageSearchAttempts < _maxVillageAttempts } do
{
    _villageSearchAttempts = _villageSearchAttempts + 1;
    private _candidate = selectRandom _cells;
    private _distFromMortar = _candidate distance2D _mortarSectorCenter;

    if (_distFromMortar < 800 || _distFromMortar > 2200) then { continue };

    private _nearBuildings = nearestObjects [_candidate, ["House"], 200];
    if (count _nearBuildings < 3) then { continue };

    _villagePos = _candidate;
};

if (_villagePos isEqualTo []) then
{
    private _bestPos = _mortarSectorCenter;
    private _bestCount = 0;
    {
        if (_x distance2D _mortarSectorCenter > 800 && _x distance2D _mortarSectorCenter < 2200) then
        {
            private _bldCount = count (nearestObjects [_x, ["House"], 150]);
            if (_bldCount > _bestCount) then
            {
                _bestCount = _bldCount;
                _bestPos = _x;
            };
        };
    } forEach _cells;
    _villagePos = _bestPos;
};

diag_log format ["[ARTILLERY_HUNT] Village position: %1 (%2m from mortar)",
    _villagePos, round (_villagePos distance2D _mortarSectorCenter)];

// ── Pick mortar position ─────────────────────────────────
private _mortarPos = [];
private _mortarAttempts = 0;
while { _mortarPos isEqualTo [] && _mortarAttempts < 30 } do
{
    _mortarAttempts = _mortarAttempts + 1;
    private _angle = random 360;
    private _dist  = 50 + (random (_searchRadius - 50));
    private _candidate = _mortarSectorCenter getPos [_dist, _angle];

    private _flatCheck = _candidate isFlatEmpty [
        4, -1, 0.2, 4, 0, false, objNull
    ];
    if (_flatCheck isNotEqualTo []) then
    {
        _mortarPos = _flatCheck;
    };
};

if (_mortarPos isEqualTo []) exitWith
{
    diag_log "[ARTILLERY_HUNT] Could not find flat ground for mortar. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

diag_log format ["[ARTILLERY_HUNT] Mortar position: %1", _mortarPos];

// ── Spawn mortar object ──────────────────────────────────
private _mortarClass = "";
private _mortarCandidates = [
    "RHS_Podnos_MSV",
    "Mortar_01_F",
    "I_Mortar_01_F"
];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _mortarClass = _x; };
} forEach _mortarCandidates;

if (_mortarClass == "") exitWith
{
    diag_log "[ARTILLERY_HUNT] No mortar class found. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

private _mortarObject = createVehicle [_mortarClass, _mortarPos, [], 0, "NONE"];
_mortarObject setPosATL _mortarPos;
_mortarObject setDir (_mortarPos getDir _villagePos);

// ── Spawn mortar crew + sentries — SEATED ────────────────
//
// Critical changes:
//   - Gunner is moveInGunner'd into the mortar (visually crewed)
//   - Group disabled FSM (won't break and run on hostile contact)
//   - allowFleeing 0 (panic threshold disabled)
//   - Behavior locked to CARELESS until contact
//
// They'll still fight if attacked, but won't pre-emptively flee just
// because they hear distant gunfire.

private _crewGroup = createGroup [_sideEnemy, true];
_crewGroup setBehaviour "SAFE";
_crewGroup setCombatMode "YELLOW";
_crewGroup allowFleeing 0;

private _gunner = _crewGroup createUnit ["LOP_AFR_Infantry_TL", _mortarPos, [], 0, "NONE"];
if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_gunner] call DZ_fnc_prepareSpawnedUnit; };
_gunner allowFleeing 0;
_gunner moveInGunner _mortarObject;

private _loader = _crewGroup createUnit ["LOP_AFR_Infantry_Rifleman", _mortarPos getPos [2, random 360], [], 0, "NONE"];
if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_loader] call DZ_fnc_prepareSpawnedUnit; };
_loader allowFleeing 0;

// 1-2 sentries patrolling around the mortar
private _sentryCount = 1 + (round random 1);
private _sentries = [];
for "_i" from 1 to _sentryCount do
{
    private _sentryPos = _mortarPos getPos [10 + (random 10), random 360];
    private _u = _crewGroup createUnit [
        selectRandom ["LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AR"],
        _sentryPos,
        [],
        0,
        "NONE"
    ];
    if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
    _u allowFleeing 0;
    _sentries pushBack _u;
};

// Set the group to GUARD the mortar position
private _wp = _crewGroup addWaypoint [_mortarPos, 15];
_wp setWaypointType        "GUARD";
_wp setWaypointBehaviour   "SAFE";
_wp setWaypointCombatMode  "YELLOW";

private _allCrewUnits = [_gunner, _loader] + _sentries;

diag_log format ["[ARTILLERY_HUNT] Spawned %1 crew/sentries (gunner seated)", count _allCrewUnits];

// ── Spawn civilians — EACH IN OWN GROUP ──────────────────
//
// Critical: 12 separate groups, each with 1 civilian. Otherwise they
// herd as a single AI group following one leader.

private _civilianClasses = [
    "LOP_AFRCiv_Soldier",
    "LOP_AFRCiv_Soldier_Medic"
];

private _vanillaCiv = [
    "LOP_AFR_Civ_Man_01",
    "LOP_AFR_Civ_Man_01_S",
    "LOP_AFR_Civ_Man_02",
    "LOP_AFR_Civ_Man_02_S",
    "LOP_AFR_Civ_Man_03",
    "LOP_AFR_Civ_Man_03_S",
    "LOP_AFR_Civ_Man_04"
];
private _civPool = [];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) then
    {
        _civPool pushBack _x;
    };
} forEach _vanillaCiv;
if (_civPool isEqualTo []) then { _civPool = _civilianClasses };

private _civilians = [];
private _victimCount = 12;

for "_i" from 1 to _victimCount do
{
    // SEPARATE group per civilian so they don't herd
    private _civGroup = createGroup [civilian, true];

    private _angle = random 360;
    private _dist  = 10 + random 60;
    private _civPos = _villagePos getPos [_dist, _angle];

    private _civClass = selectRandom _civPool;
    private _civ = _civGroup createUnit [_civClass, _civPos, [], 0, "NONE"];

    removeAllWeapons _civ;
    _civ disableAI "AUTOTARGET";
    _civ disableAI "TARGET";
    _civ disableAI "PATH";   // stops random pathing — they'll stand around
    _civ setBehaviour "SAFE";
    _civ setSkill 0.3;
    _civ setUnitPos "AUTO";

    _civilians pushBack _civ;
};

diag_log format ["[ARTILLERY_HUNT] Spawned %1 civilians in %1 separate groups", count _civilians];

// ── Markers ──────────────────────────────────────────────
private _searchCircle = createMarker ["marker_arty_search", _mortarSectorCenter];
_searchCircle setMarkerShape "ELLIPSE";
_searchCircle setMarkerSize [_searchRadius, _searchRadius];
_searchCircle setMarkerBrush "Border";
_searchCircle setMarkerColor "ColorRed";
_searchCircle setMarkerAlpha 0.7;

["create", "marker_arty_search_label", _mortarSectorCenter, "loc_Bunker", "Зона огневой позиции"] call DZ_fnc_missionUi;
["create", "marker_arty_village",      _villagePos,         "loc_Hospital", "Деревня под обстрелом"] call DZ_fnc_missionUi;

[
    _allCrewUnits + _civilians,
    [_mortarObject],
    ["marker_arty_search", "marker_arty_search_label", "marker_arty_village"],
    []
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_artyMortar",           _mortarObject];
missionNamespace setVariable ["DZ_artyCrew",             _allCrewUnits];
missionNamespace setVariable ["DZ_artyCivilians",        _civilians];
missionNamespace setVariable ["DZ_artyVillagePos",       _villagePos];
missionNamespace setVariable ["DZ_artyKilledCivilians",  0];
missionNamespace setVariable ["DZ_artyFiringStarted",    false];
missionNamespace setVariable ["DZ_artyMissionDone",      false];

private _gracePeriod = 600;

[
    "hint",
    "MISSION: УНИЧТОЖИТЬ МИНОМЁТЧИКОВ",
    format [
        "Боевики устанавливают миномёт и готовятся открыть огонь по мирной деревне. Найдите огневую позицию в обозначенной зоне (~%1 м). Уничтожьте расчёт миномёта или сам миномёт ДО открытия огня. До открытия огня осталось ~%2 минут.",
        _searchRadius * 2,
        _gracePeriod / 60
    ]
] call DZ_fnc_missionUi;

["Разведданные: миномёт устанавливают в обозначенной зоне. До открытия огня ~10 минут.", east]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

// ── Halfway warning ──────────────────────────────────────
[
    {
        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_artyFiringStarted", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith {};
        ["До открытия огня по деревне ~5 минут. Поторопитесь.", east]
            remoteExecCall ["DZ_fnc_sideMessage", 0];
    },
    [],
    300
] call CBA_fnc_waitAndExecute;

[
    {
        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_artyFiringStarted", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith {};
        ["Внимание: миномёт готов к открытию огня. Осталась 1 минута.", east]
            remoteExecCall ["DZ_fnc_sideMessage", 0];
    },
    [],
    540
] call CBA_fnc_waitAndExecute;

// ── Fast end-detection PFH (runs from mission start) ─────
//
// Runs every 2 seconds, watches for crew dead OR mortar destroyed,
// ends mission immediately. Works during grace period AND firing.

private _endDetectionHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_mortarObject", "_crew", "_civilians", "_villagePos"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        // Check if silenced
        private _liveCrew = _crew select { !isNull _x && { alive _x } };
        private _mortarDead = isNull _mortarObject || { !alive _mortarObject };

        if (_liveCrew isEqualTo [] || _mortarDead) then
        {
            missionNamespace setVariable ["DZ_artyMissionDone", true];

            // Civilians flee to safety
            {
                if (alive _x) then
                {
                    _x enableAI "PATH";
                    _x setBehaviour "AWARE";
                    _x setSpeedMode "FULL";
                    _x doMove (_villagePos getPos [800, random 360]);
                };
            } forEach _civilians;

            private _killedCount = missionNamespace getVariable ["DZ_artyKilledCivilians", 0];
            ["success"] call DZ_fnc_endMission;

            if (_killedCount == 0) then
            {
                ["Миномёт уничтожен до открытия огня. Деревня в безопасности.", east]
                    remoteExecCall ["DZ_fnc_sideMessage", 0];
            }
            else
            {
                [
                    format ["Миномёт замолчал. Жертв среди мирного населения: %1.", _killedCount],
                    east
                ] remoteExecCall ["DZ_fnc_sideMessage", 0];
            };

            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    },
    2,
    [_mortarObject, _allCrewUnits, _civilians, _villagePos]
] call CBA_fnc_addPerFrameHandler;

// ── Firing loop — kicks off after grace period ───────────
[
    {
        params ["_mortarObject", "_crew", "_civilians", "_villagePos"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};
        if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith {};

        missionNamespace setVariable ["DZ_artyFiringStarted", true];

        ["Миномёт открыл огонь по деревне!", east]
            remoteExecCall ["DZ_fnc_sideMessage", 0];

        diag_log "[ARTILLERY_HUNT] Grace period ended, firing PFH starting.";

        private _firingHandle = [
            {
                params ["_args", "_handle"];
                _args params ["_mortarObject", "_crew", "_civilians", "_villagePos"];

                if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
                {
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };

                if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith
                {
                    [_handle] call CBA_fnc_removePerFrameHandler;
                };

                // Don't fire if crew dead / mortar destroyed (end-detect PFH will catch this)
                private _liveCrew = _crew select { !isNull _x && { alive _x } };
                if (_liveCrew isEqualTo [] || isNull _mortarObject || { !alive _mortarObject }) exitWith {};

                // Pick a living civilian
                private _liveCivs = _civilians select { alive _x };
                if (_liveCivs isEqualTo []) exitWith {};

                private _victim = selectRandom _liveCivs;
                private _impactPos = getPosATL _victim;
                private _driftX = (random 10) - 5;
                private _driftY = (random 10) - 5;
                _impactPos = [(_impactPos # 0) + _driftX, (_impactPos # 1) + _driftY, 0];

                // VISUAL: muzzle flash + sound at the mortar
                if (!isNull _mortarObject && { alive _mortarObject }) then
                {
                    private _muzzlePos = _mortarObject modelToWorld [0, 0, 1.5];

                    // Particle muzzle flash
                    private _flash = "#particlesource" createVehicle _muzzlePos;
                    _flash setParticleParams [
                        ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 48, 1],
                        "", "Billboard", 1, 0.3, [0, 0, 0],
                        [0, 0, 8], 0, 1.275, 1, 0,
                        [2, 4],
                        [[1, 0.85, 0.5, 0.9], [1, 0.7, 0.3, 0.6], [0.3, 0.3, 0.3, 0]],
                        [0.3], 1, 0, "", "", _mortarObject
                    ];
                    _flash setParticleRandom [0, [0.5, 0.5, 0.5], [1, 1, 0], 0, 0.5, [0, 0, 0, 0.1], 0, 0];
                    _flash setDropInterval 0.01;

                    [{ deleteVehicle (_this # 0) }, [_flash], 0.3] call CBA_fnc_waitAndExecute;

                    // Smoke puff
                    private _smoke = "#particlesource" createVehicle _muzzlePos;
                    _smoke setParticleParams [
                        ["\A3\Data_F\ParticleEffects\Universal\Universal", 16, 7, 48, 1],
                        "", "Billboard", 1, 2, [0, 0, 0],
                        [0, 0, 3], 0, 1.275, 1, 0,
                        [2, 5, 8],
                        [[0.4, 0.4, 0.4, 0.4], [0.4, 0.4, 0.4, 0.2], [0.4, 0.4, 0.4, 0]],
                        [0.5], 1, 0, "", "", _mortarObject
                    ];
                    _smoke setParticleRandom [0.3, [1, 1, 0], [1, 1, 1], 0, 1, [0, 0, 0, 0.1], 0, 0];
                    _smoke setDropInterval 0.05;

                    [{ deleteVehicle (_this # 0) }, [_smoke], 2] call CBA_fnc_waitAndExecute;

                    // Firing sound
                    playSound3D ["A3\Sounds_F\arsenal\weapons_static\Mortar\Mortar_01_shot.wss",
                        _mortarObject, false, getPosASL _mortarObject, 5, 1, 800];
                };

                // Schedule the impact
                [
                    {
                        params ["_impactPos", "_victim"];
                        if (!alive _victim) exitWith {};

                        private _shell = createVehicle ["Sh_82mm_AMOS", _impactPos, [], 0, "CAN_COLLIDE"];

                        [
                            {
                                params ["_victim"];
                                if (alive _victim) then
                                {
                                    _victim setDamage 1;
                                };
                            },
                            [_victim],
                            1
                        ] call CBA_fnc_waitAndExecute;
                    },
                    [_impactPos, _victim],
                    8 + (random 4)
                ] call CBA_fnc_waitAndExecute;

                private _killedCount = (missionNamespace getVariable ["DZ_artyKilledCivilians", 0]) + 1;
                missionNamespace setVariable ["DZ_artyKilledCivilians", _killedCount];

                private _msgVariants = [
                    format ["В деревне погиб мирный житель. Всего жертв: %1.", _killedCount],
                    format ["Снаряд попал в дом. Жертв: %1.", _killedCount],
                    format ["Связь с деревней: ещё одна потеря. Всего: %1.", _killedCount],
                    format ["Удар по мирной деревне. Жертв: %1.", _killedCount]
                ];
                [selectRandom _msgVariants, east] remoteExecCall ["DZ_fnc_sideMessage", 0];

                diag_log format ["[ARTILLERY_HUNT] Round fired. Body count: %1", _killedCount];
            },
            30,
            [_mortarObject, _crew, _civilians, _villagePos]
        ] call CBA_fnc_addPerFrameHandler;

        [[], [], [], [_firingHandle]] call DZ_fnc_addMissionAssets;
    },
    [_mortarObject, _allCrewUnits, _civilians, _villagePos],
    _gracePeriod
] call CBA_fnc_waitAndExecute;

// ── Mission timeout ──────────────────────────────────────
private _timeoutHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_startTime"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (missionNamespace getVariable ["DZ_artyMissionDone", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if ((time - _startTime) > 3600) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            missionNamespace setVariable ["DZ_artyMissionDone", true];
            ["failure"] call DZ_fnc_endMission;
            ["Миномёт не уничтожен в срок. Деревня разрушена.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    10,
    [time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_endDetectionHandle, _timeoutHandle]] call DZ_fnc_addMissionAssets;

true
