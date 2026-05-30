/*
 * Alfa/Civilians/Reputation/IedThreat.sqf
 * Adds a low-reputation roadside IED threat without mission markers.
 *
 * Per-side (Wave 3): each player faction's standing with the civilian
 * population is evaluated independently. Bombs are placed near players
 * whose own faction's reputation is below the threshold — APD doing
 * badly doesn't punish Free Altis and vice versa.
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["ALFA_repIedThreatInitialized", false]) exitWith {};
missionNamespace setVariable ["ALFA_repIedThreatInitialized", true];

private _defaults =
[
    ["ALFA_repIedThreshold",         30],
    ["ALFA_repIedInitialDelay",      30],
    ["ALFA_repIedCheckInterval",    180],
    ["ALFA_repIedMaxActive",          6],
    ["ALFA_repIedLifetime",        1800],
    ["ALFA_repIedMinPlayerDistance", 120],
    ["ALFA_repIedMaxPlayerDistance",1200],
    ["ALFA_repIedMinRoadDistance",  500],
    ["ALFA_repIedMaxRoadDistance",  900],
    ["ALFA_repIedMinIedDistance",   180],
    ["ALFA_repIedBaseDistance",     250],
    ["ALFA_repIedSpawnChanceMin",  0.20],
    ["ALFA_repIedSpawnChanceMax",  0.60]
];

{
    _x params ["_name", "_value"];
    missionNamespace setVariable [_name, missionNamespace getVariable [_name, _value]];
} forEach _defaults;

private _iedClasses =
[
    "IEDLandSmall_F",
    "IEDLandBig_F",
    "IEDUrbanSmall_F",
    "IEDUrbanBig_F"
];

missionNamespace setVariable
[
    "ALFA_repIedClasses",
    _iedClasses select { isClass (configFile >> "CfgVehicles" >> _x) }
];

// Per-side active-IED pools. Each side keeps its own list so cleanup
// limits and spawn counts don't trample each other.
ALFA_fnc_repIedActiveKeyForSide = {
    params ["_side"];
    format ["ALFA_repActiveIeds_%1", str _side]
};

// Initialize one pool per player side.
{
    private _key = [_x] call ALFA_fnc_repIedActiveKeyForSide;
    missionNamespace setVariable [_key, missionNamespace getVariable [_key, []]];
} forEach (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]);

// Live, non-AFK players for a given side.
ALFA_fnc_repIedPlayersForSide = {
    params ["_side"];
    allPlayers select { alive _x && { (side group _x) isEqualTo _side } }
};

ALFA_fnc_repIedInSafeZone =
{
    params [["_pos", [], [[]]]];

    if (_pos isEqualTo []) exitWith { true };

    private _buffer = missionNamespace getVariable ["ALFA_repIedBaseDistance", 250];
    private _inside = false;

    if ((markerType "base_safe_zone") != "") then
    {
        private _center = getMarkerPos "base_safe_zone";
        private _size = getMarkerSize "base_safe_zone";

        if ((markerShape "base_safe_zone") == "RECTANGLE") then
        {
            private _dir = markerDir "base_safe_zone";
            private _dx = (_pos # 0) - (_center # 0);
            private _dy = (_pos # 1) - (_center # 1);
            private _localX = (_dx * cos _dir) - (_dy * sin _dir);
            private _localY = (_dx * sin _dir) + (_dy * cos _dir);

            _inside = (abs _localX <= ((_size # 0) + _buffer)) &&
                { abs _localY <= ((_size # 1) + _buffer) };
        }
        else
        {
            _inside = (_pos distance2D _center) <= (((_size # 0) max (_size # 1)) + _buffer);
        };
    };

    if (_inside) exitWith { true };

    // Stay clear of every faction's respawn point.
    private _respawnMarkers = ["respawn_west", "respawn_east", "respawn_guerrila", "respawn_civilian"];
    private _resolved = missionNamespace getVariable ["DZ_respawnPointsResolved", []];
    {
        _x params [["_lbl", ""], ["_rpos", []], ["_rside", sideUnknown]];
        if (_rpos isEqualType [] && { count _rpos >= 2 } && { _pos distance2D _rpos < _buffer }) exitWith {
            _inside = true;
        };
    } forEach _resolved;

    if (_inside) exitWith { true };

    private _hit = _respawnMarkers findIf {
        (markerType _x) != "" && { _pos distance2D (getMarkerPos _x) < _buffer }
    };

    _hit >= 0
};

ALFA_fnc_repIedDeleteReason =
{
    params [
        ["_ied",     objNull, [objNull]],
        ["_players", [],      [[]]]
    ];

    if (isNull _ied) exitWith { "null" };
    if (!alive _ied || { !(mineActive _ied) }) exitWith { "inactive" };

    private _createdAt = _ied getVariable ["ALFA_repIedCreatedAt", time];
    private _lifetime  = missionNamespace getVariable ["ALFA_repIedLifetime", 1800];
    if (time - _createdAt > _lifetime) exitWith { "expired" };

    if (_players isEqualTo []) exitWith { "" };

    private _nearestPlayerDistance = 1e10;
    {
        _nearestPlayerDistance = _nearestPlayerDistance min ((vehicle _x) distance2D _ied);
    } forEach _players;

    private _maxPlayerDistance = missionNamespace getVariable ["ALFA_repIedMaxPlayerDistance", 1200];
    if (_nearestPlayerDistance <= _maxPlayerDistance) exitWith
    {
        _ied setVariable ["ALFA_repIedFarSince", -1];
        ""
    };

    private _farSince = _ied getVariable ["ALFA_repIedFarSince", -1];
    if (_farSince < 0) exitWith
    {
        _ied setVariable ["ALFA_repIedFarSince", time];
        ""
    };

    private _interval = missionNamespace getVariable ["ALFA_repIedCheckInterval", 180];
    if (time - _farSince >= _interval) exitWith { "distant" };

    ""
};

ALFA_fnc_repIedCleanupForSide =
{
    params [
        ["_side",    sideUnknown],
        ["_players", [], [[]]]
    ];

    private _key   = [_side] call ALFA_fnc_repIedActiveKeyForSide;
    private _pool  = missionNamespace getVariable [_key, []];
    private _kept  = [];

    {
        private _reason = [_x, _players] call ALFA_fnc_repIedDeleteReason;

        if (_reason isEqualTo "") then
        {
            _kept pushBack _x;
        }
        else
        {
            if (!isNull _x) then
            {
                diag_log format ["[ALFA_REP_IED:%1] Removing IED at %2 (%3)",
                    [_side] call ALFA_fnc_repSideLabel, getPosATL _x, _reason];
                deleteVehicle _x;
            };
        };
    } forEach _pool;

    missionNamespace setVariable [_key, _kept];
    _kept
};

ALFA_fnc_repIedPositionAllowed =
{
    params [
        ["_pos",        [], [[]]],
        ["_players",    [], [[]]],
        ["_activeIeds", [], [[]]]
    ];

    if (_pos isEqualTo []) exitWith { false };
    if (surfaceIsWater _pos) exitWith { false };
    if ([_pos] call ALFA_fnc_repIedInSafeZone) exitWith { false };

    private _minPlayerDistance = missionNamespace getVariable ["ALFA_repIedMinPlayerDistance", 120];
    private _tooCloseToPlayer  = _players findIf { (vehicle _x) distance2D _pos < _minPlayerDistance };
    if (_tooCloseToPlayer >= 0) exitWith { false };

    private _minIedDistance = missionNamespace getVariable ["ALFA_repIedMinIedDistance", 180];
    private _tooCloseToIed  = _activeIeds findIf { !isNull _x && { _x distance2D _pos < _minIedDistance } };

    _tooCloseToIed < 0
};

ALFA_fnc_repIedFindRoadPos =
{
    params [
        ["_players",    [], [[]]],
        ["_activeIeds", [], [[]]]
    ];

    if (_players isEqualTo []) exitWith { [] };

    private _minRoadDistance = missionNamespace getVariable ["ALFA_repIedMinRoadDistance", 500];
    private _maxRoadDistance = missionNamespace getVariable ["ALFA_repIedMaxRoadDistance", 900];
    private _pos     = [];
    private _attempt = 0;

    while { _attempt < 20 && { _pos isEqualTo [] } } do
    {
        private _playerPos = getPosATL (vehicle (selectRandom _players));
        private _roads     = (_playerPos nearRoads _maxRoadDistance) select
        {
            private _distance = _playerPos distance2D (getPosATL _x);
            _distance >= _minRoadDistance && { _distance <= _maxRoadDistance }
        };

        if (_roads isNotEqualTo []) then
        {
            private _roadPos   = getPosATL (selectRandom _roads);
            private _candidate = _roadPos getPos [random 5, random 360];
            _candidate set [2, 0];

            if ([_candidate, _players, _activeIeds] call ALFA_fnc_repIedPositionAllowed) then
            {
                _pos = _candidate;
            };
        };

        _attempt = _attempt + 1;
    };

    _pos
};

ALFA_fnc_repIedSpawn =
{
    params [
        ["_side",       sideUnknown],
        ["_players",    [], [[]]],
        ["_activeIeds", [], [[]]],
        ["_rep",        50, [0]]
    ];

    private _iedClasses = missionNamespace getVariable ["ALFA_repIedClasses", []];
    if (_iedClasses isEqualTo []) exitWith { objNull };

    private _pos = [_players, _activeIeds] call ALFA_fnc_repIedFindRoadPos;
    if (_pos isEqualTo []) exitWith { objNull };

    private _class = selectRandom _iedClasses;
    private _ied   = createMine [_class, _pos, [], 0];
    if (isNull _ied) exitWith { objNull };

    _ied setVariable ["ALFA_repIed",          true,  true];
    _ied setVariable ["ALFA_repIedCreatedAt", time,  true];
    _ied setVariable ["ALFA_repIedSource",    "civilian_reputation", true];
    _ied setVariable ["ALFA_repIedTargetSide", _side, true];
    _ied setVariable ["ALFA_repIedFarSince",  -1];

    diag_log format ["[ALFA_REP_IED:%1] Spawned %2 at %3 (rep=%4)",
        [_side] call ALFA_fnc_repSideLabel, _class, _pos, _rep];
    _ied
};

ALFA_fnc_repIedSpawnChance =
{
    params [["_rep", 50, [0]]];

    private _threshold = missionNamespace getVariable ["ALFA_repIedThreshold", 30];
    private _minChance = missionNamespace getVariable ["ALFA_repIedSpawnChanceMin", 0.20];
    private _maxChance = missionNamespace getVariable ["ALFA_repIedSpawnChanceMax", 0.60];
    private _threat    = (((_threshold - _rep) / _threshold) max 0) min 1;

    _minChance + ((_maxChance - _minChance) * _threat)
};

ALFA_fnc_repIedTick =
{
    private _interval    = missionNamespace getVariable ["ALFA_repIedCheckInterval", 180];
    [ALFA_fnc_repIedTick, [], _interval] call CBA_fnc_waitAndExecute;

    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _threshold   = missionNamespace getVariable ["ALFA_repIedThreshold", 30];
    private _maxActive   = missionNamespace getVariable ["ALFA_repIedMaxActive", 6];

    {
        private _side    = _x;
        private _players = [_side] call ALFA_fnc_repIedPlayersForSide;
        private _active  = [_side, _players] call ALFA_fnc_repIedCleanupForSide;

        if (_players isEqualTo []) then { continue };
        if (count _active >= _maxActive) then { continue };

        private _rep = [_side] call ALFA_fnc_repGet;
        if (_rep >= _threshold) then { continue };
        if ((random 1) >= ([_rep] call ALFA_fnc_repIedSpawnChance)) then { continue };

        private _ied = [_side, _players, _active, _rep] call ALFA_fnc_repIedSpawn;
        if (!isNull _ied) then
        {
            _active pushBack _ied;
            private _key = [_side] call ALFA_fnc_repIedActiveKeyForSide;
            missionNamespace setVariable [_key, _active];
        };
    } forEach _playerSides;
};

if ((missionNamespace getVariable ["ALFA_repIedClasses", []]) isEqualTo []) exitWith
{
    diag_log "[ALFA_REP_IED] No IED classes available. Civilian IED threat disabled.";
};

private _initialDelay = missionNamespace getVariable ["ALFA_repIedInitialDelay", 30];
[ALFA_fnc_repIedTick, [], _initialDelay] call CBA_fnc_waitAndExecute;

diag_log format
[
    "[ALFA_REP_IED] Per-side civilian IED threat initialized. First check in %1 seconds. Classes=%2 Sides=%3",
    _initialDelay,
    missionNamespace getVariable ["ALFA_repIedClasses", []],
    missionNamespace getVariable ["DZ_playerSides", [west, resistance]]
];
