/*
 * DZ_fnc_startDestroyCacheMission
 *
 * Mission: locate and destroy 3-5 weapon caches scattered across an
 * enemy-held sector.
 *
 * Bug fixes from previous version (caches reporting destroyed
 * immediately at mission start):
 *
 *   1. BASELINE DAMAGE TRACKING — record each crate's damage value
 *      at spawn time. Destruction = (current damage) - (baseline) >= 0.5.
 *      This handles crates that spawn already at e.g. 0.4 damage from
 *      terrain clipping.
 *
 *   2. GRACE PERIOD — first 15 seconds after spawn, ignore damage
 *      events entirely. Lets the engine settle any collision damage
 *      from initial spawn placement.
 *
 *   3. SUSPICIOUS-KILL LOGGING — if a "kill" happens within 30s of
 *      mission start, log a warning. Real player kills require travel
 *      time to the sector, so early kills indicate environmental
 *      damage we missed.
 *
 *   4. EXPLICIT DAMAGE RESET — setDamage 0 right after spawn to clear
 *      any spawn-time damage before the handler attaches.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "destroy_cache" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["destroy_cache"] call DZ_fnc_getMissionDefinition;
    ["destroy_cache", "manual", _definition] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[DESTROY_CACHE] DZ_cells not initialized. Aborting.";
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
    diag_log "[DESTROY_CACHE] No sectors in 1500-2500m band, falling back";
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
    diag_log "[DESTROY_CACHE] No enemy sectors available. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих целей не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _selected = selectRandom _candidates;
private _sectorIdx    = _selected # 0;
private _sectorCenter = _cells select _sectorIdx;
private _searchRadius = 200;

diag_log format ["[DESTROY_CACHE] Target sector: %1 at %2 (%3m from player territory)",
    _sectorIdx, _sectorCenter, round (_selected # 1)];

private _spawnResult = [_sectorCenter, 8] call DZ_fnc_spawnForZone;
_spawnResult params [["_defenderGroups", []], ["_defenderVehicles", []], ["_defenderUnitCount", 0]];

private _defenderUnits = [];
{
    _defenderUnits append (units _x);
} forEach _defenderGroups;

// ── Pick cache positions in OPEN GROUND ──────────────────
private _cacheCount = floor (3 + (random 3));

private _cachePositions = [];
private _attempts = 0;
private _maxAttempts = 60;

while { (count _cachePositions) < _cacheCount && _attempts < _maxAttempts } do
{
    _attempts = _attempts + 1;

    private _angle = random 360;
    private _dist  = 30 + (random (_searchRadius - 30));
    private _candidatePos = _sectorCenter getPos [_dist, _angle];

    private _tooClose = false;
    {
        if (_candidatePos distance2D _x < 50) exitWith { _tooClose = true; };
    } forEach _cachePositions;

    if (_tooClose) then { continue };

    // Stricter flatness check — wider clear area, gentler slope tolerance
    private _flatCheck = _candidatePos isFlatEmpty [
        5,        // min flat distance (m) — wider clear area
        -1,       // max gradient (-1 = ignore)
        0.15,     // max gradient on flat area — stricter than before
        4,        // distance for object check
        0,        // 0 = ignore water
        false,    // not shoreline
        objNull
    ];

    if (_flatCheck isEqualTo []) then { continue };

    _candidatePos = _flatCheck;
    _cachePositions pushBack _candidatePos;
};

if ((count _cachePositions) < 2) exitWith
{
    diag_log format ["[DESTROY_CACHE] Could only place %1 cache positions, aborting.", count _cachePositions];
    ["failure"] call DZ_fnc_endMission;
    ["Не удалось разместить тайники в открытой местности.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

diag_log format ["[DESTROY_CACHE] Validated %1 open-ground positions in %2m radius",
    count _cachePositions, _searchRadius];

private _crateCandidates = [
    "Box_East_Wps_F",
    "Box_East_AmmoOrd_F",
    "Box_East_Support_F",
    "Land_PaperBox_open_full_F"
];

private _crateClass = "";
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _crateClass = _x; };
} forEach _crateCandidates;

if (_crateClass == "") exitWith
{
    diag_log "[DESTROY_CACHE] No valid crate class found. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

diag_log format ["[DESTROY_CACHE] Using crate class: %1", _crateClass];

private _propClasses = [
    "Land_Sack_F",
    "Land_BarrelEmpty_F",
    "Land_CratesWooden_F",
    "Land_CanisterFuel_F",
    "Land_Sleeping_bag_F"
];

// ── Spawn caches with baseline damage tracking ───────────
//
// Critical sequence:
//   1. createVehicle
//   2. setPosATL
//   3. setDamage 0  (clear any spawn-time terrain damage)
//   4. record baseline = damage _crate (should be 0)
//   5. attach HandleDamage handler with grace-period check
//
// The mission start time is also recorded; the handler ignores all
// damage events for the first 15 seconds.

private _missionStartTime = time;
missionNamespace setVariable ["DZ_destroyCacheStartTime", _missionStartTime, true];

private _caches = [];
private _propsToTrack = [];

{
    private _pos = _x;
    private _idx = _forEachIndex;

    private _crate = createVehicle [_crateClass, _pos, [], 0, "NONE"];
    _crate setPosATL _pos;
    _crate setDir (random 360);

    if (isNull _crate || { !alive _crate }) then
    {
        diag_log format ["[DESTROY_CACHE] Crate creation failed at %1, skipping", _pos];
    } else
    {
        // CRITICAL: clear any spawn-time damage. setDamage 0 resets the
        // crate to full health regardless of what the engine assigned.
        _crate setDamage 0;

        private _baselineDamage = damage _crate;

        _crate setVariable ["DZ_isCacheTarget", true, true];
        _crate setVariable ["DZ_cacheIndex", _idx, true];
        _crate setVariable ["DZ_cacheBaseline", _baselineDamage, true];
        _crate setVariable ["DZ_cacheSpawnTime", time, true];

        _crate addEventHandler ["HandleDamage", {
            params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

            // Grace period: ignore all damage in first 15 seconds.
            // Engine collision settling happens in this window.
            private _spawnTime = _unit getVariable ["DZ_cacheSpawnTime", 0];
            if (time - _spawnTime < 15) exitWith
            {
                damage _unit
            };

            // Phantom damage filter: no source = ignore
            private _hasRealSource =
                !isNull _source ||
                { _projectile isNotEqualTo "" && { _projectile isNotEqualTo objNull } } ||
                { !isNull _instigator };

            if (!_hasRealSource) exitWith { damage _unit };

            // Real combat damage: multiply by 5 for fragility
            private _scaled = _damage * 5;
            if (_scaled > 1) then { _scaled = 1; };

            if (_damage > 0.05 && { !(_unit getVariable ["DZ_cacheLogged", false]) }) then
            {
                _unit setVariable ["DZ_cacheLogged", true];
                diag_log format ["[DESTROY_CACHE] First real hit on cache %1: source=%2, proj=%3, raw=%4, scaled=%5, t=%6s",
                    _unit getVariable ["DZ_cacheIndex", -1],
                    _source,
                    _projectile,
                    _damage,
                    _scaled,
                    time - _spawnTime
                ];
            };

            _scaled
        }];

        _caches pushBack _crate;
    };

    private _propCount = floor (2 + (random 2));
    for "_p" from 1 to _propCount do
    {
        private _propClass = selectRandom _propClasses;
        private _propPos = _pos getPos [1.5 + (random 1.5), random 360];
        private _prop = createVehicle [_propClass, _propPos, [], 0, "CAN_COLLIDE"];
        _propsToTrack pushBack _prop;
    };
} forEach _cachePositions;

if (_caches isEqualTo []) exitWith
{
    diag_log "[DESTROY_CACHE] All crate spawns failed validation. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

diag_log format ["[DESTROY_CACHE] Validated %1 caches alive after creation, baseline damage check pending", count _caches];

["create", "marker_cache_area", _sectorCenter, "loc_Bunker", "Тайники"] call DZ_fnc_missionUi;

private _circleMarker = createMarker ["marker_cache_circle", _sectorCenter];
_circleMarker setMarkerShape "ELLIPSE";
_circleMarker setMarkerSize [_searchRadius, _searchRadius];
_circleMarker setMarkerBrush "Border";
_circleMarker setMarkerColor "ColorRed";
_circleMarker setMarkerAlpha 0.6;

[
    _defenderUnits,
    _defenderVehicles + _caches + _propsToTrack,
    ["marker_cache_area", "marker_cache_circle"],
    []
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_destroyCacheTargets",     _caches];
missionNamespace setVariable ["DZ_destroyCacheTotalCount",  count _caches];
missionNamespace setVariable ["DZ_destroyCacheKilledCount", 0];

[
    "hint",
    "MISSION: УНИЧТОЖИТЬ ТАЙНИКИ",
    format [
        "В районе обнаружены тайники с оружием боевиков (около %1 шт). Прибудьте в обозначенный район и найдите тайники. Уничтожьте каждый из них любыми средствами. Радиус поиска: ~%2 м",
        count _caches,
        _searchRadius
    ]
] call DZ_fnc_missionUi;

// ── State tracker ───────────────────────────────────────
//
// Three changes:
//   - Compares damage against per-crate baseline (handles spawn drift)
//   - 30s suspicious-kill window: kills before then are logged but not
//     counted (real player travel time prevents legitimate early kills)
//   - 15s startup grace: PFH skips checks entirely for first 15 seconds

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_caches", "_startTime"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        // Skip checks during 15s startup grace
        if (time - _startTime < 15) exitWith {};

        if ((time - _startTime) > 4000) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            ["Время на уничтожение тайников истекло.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _killedCount = missionNamespace getVariable ["DZ_destroyCacheKilledCount", 0];

        {
            private _crate = _x;
            private _idx = _forEachIndex;

            if (isNull _crate) then
            {
                // Engine lost reference. Don't count as kill.
            } else
            {
                private _alreadyKilled = _crate getVariable ["DZ_cacheKilled", false];
                if (!_alreadyKilled) then
                {
                    private _baseline = _crate getVariable ["DZ_cacheBaseline", 0];
                    private _current  = damage _crate;
                    private _delta    = _current - _baseline;

                    if (_delta >= 0.5) then
                    {
                        // Suspicious-kill detection: real player travel
                        // takes at least 30s minimum. Anything before that
                        // is environmental damage we missed.
                        private _missionTime = time - _startTime;
                        private _suspicious = _missionTime < 30;

                        if (_suspicious) then
                        {
                            diag_log format ["[DESTROY_CACHE] SUSPICIOUS KILL on cache %1 at t=%2s (delta=%3, baseline=%4, current=%5). NOT counting. Resetting damage.",
                                _idx + 1, _missionTime, _delta, _baseline, _current];

                            // Reset the crate's damage to baseline so it
                            // doesn't keep triggering. Don't count as kill.
                            _crate setDamage _baseline;
                        }
                        else
                        {
                            _crate setVariable ["DZ_cacheKilled", true, true];
                            _killedCount = _killedCount + 1;
                            missionNamespace setVariable ["DZ_destroyCacheKilledCount", _killedCount];

                            diag_log format ["[DESTROY_CACHE] Cache %1 destroyed (delta=%2, baseline=%3, current=%4, t=%5s)",
                                _idx + 1, _delta, _baseline, _current, _missionTime];

                            [
                                format ["Тайник уничтожен (%1 / %2).", _killedCount, count _caches],
                                east
                            ] remoteExecCall ["DZ_fnc_sideMessage", 0];
                        };
                    };
                };
            };
        } forEach _caches;

        // Win condition: all live caches killed AND at least 1 was killed
        private _stillAlive = ({
            !isNull _x && { !(_x getVariable ["DZ_cacheKilled", false]) }
        } count _caches);

        if (_stillAlive == 0 && _killedCount > 0) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success"] call DZ_fnc_endMission;
            ["Все тайники уничтожены. Отличная работа.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        if (_killedCount == 0 && _stillAlive == 0) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            diag_log "[DESTROY_CACHE] All caches lost without being killed. Mission failed.";
            ["Все тайники потеряны. Миссия отменена.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    2,
    [_caches, time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle]] call DZ_fnc_addMissionAssets;

true
