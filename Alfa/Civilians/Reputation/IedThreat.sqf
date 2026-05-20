/*
 * Alfa/Civilians/Reputation/IedThreat.sqf
 * Spawns and cleans up roadside IEDs when civilian reputation is poor.
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["ALFA_repIedThreatInitialized", false]) exitWith {};
missionNamespace setVariable ["ALFA_repIedThreatInitialized", true];

private _iedClasses =
[
    "IEDLandSmall_F",
    "IEDLandBig_F",
    "IEDUrbanSmall_F",
    "IEDUrbanBig_F"
];

private _availableIeds = _iedClasses select { isClass (configFile >> "CfgVehicles" >> _x) };
missionNamespace setVariable ["ALFA_repIedClasses", _availableIeds];
missionNamespace setVariable ["ALFA_repActiveIeds", missionNamespace getVariable ["ALFA_repActiveIeds", []]];

missionNamespace setVariable ["ALFA_repIedThreshold", missionNamespace getVariable ["ALFA_repIedThreshold", 30]];
missionNamespace setVariable ["ALFA_repIedCheckInterval", missionNamespace getVariable ["ALFA_repIedCheckInterval", 180]];
missionNamespace setVariable ["ALFA_repIedMaxActive", missionNamespace getVariable ["ALFA_repIedMaxActive", 6]];
missionNamespace setVariable ["ALFA_repIedLifetime", missionNamespace getVariable ["ALFA_repIedLifetime", 1800]];
missionNamespace setVariable ["ALFA_repIedMinPlayerDistance", missionNamespace getVariable ["ALFA_repIedMinPlayerDistance", 120]];
missionNamespace setVariable ["ALFA_repIedMaxPlayerDistance", missionNamespace getVariable ["ALFA_repIedMaxPlayerDistance", 1200]];
missionNamespace setVariable ["ALFA_repIedMinRoadDistance", missionNamespace getVariable ["ALFA_repIedMinRoadDistance", 500]];
missionNamespace setVariable ["ALFA_repIedMaxRoadDistance", missionNamespace getVariable ["ALFA_repIedMaxRoadDistance", 900]];
missionNamespace setVariable ["ALFA_repIedMinIedDistance", missionNamespace getVariable ["ALFA_repIedMinIedDistance", 180]];
missionNamespace setVariable ["ALFA_repIedBaseDistance", missionNamespace getVariable ["ALFA_repIedBaseDistance", 250]];

ALFA_fnc_repIedPlayers =
{
    private _playerSide = missionNamespace getVariable ["CH_sidePlayers", east];

    allPlayers select
    {
        alive _x && { (side group _x) isEqualTo _playerSide }
    }
};

ALFA_fnc_repIedNearBase =
{
    params [["_pos", [], [[]]]];

    if (_pos isEqualTo []) exitWith { true };

    private _baseDistance = missionNamespace getVariable ["ALFA_repIedBaseDistance", 250];
    private _nearBase = false;

    if ((markerType "base_safe_zone") != "") then
    {
        private _safeCenter = getMarkerPos "base_safe_zone";
        private _safeSize = getMarkerSize "base_safe_zone";
        private _safeShape = markerShape "base_safe_zone";
        private _safeDir = markerDir "base_safe_zone";
        private _sizeA = (_safeSize # 0) + _baseDistance;
        private _sizeB = (_safeSize # 1) + _baseDistance;

        if (_safeShape == "RECTANGLE") then
        {
            private _dx = (_pos # 0) - (_safeCenter # 0);
            private _dy = (_pos # 1) - (_safeCenter # 1);
            private _localX = (_dx * cos _safeDir) - (_dy * sin _safeDir);
            private _localY = (_dx * sin _safeDir) + (_dy * cos _safeDir);

            _nearBase = (abs _localX <= _sizeA) && { abs _localY <= _sizeB };
        }
        else
        {
            _nearBase = (_pos distance2D _safeCenter) <= (_sizeA max _sizeB);
        };
    };

    if (_nearBase) exitWith { true };

    if ((markerType "respawn_east") != "") exitWith
    {
        _pos distance2D (getMarkerPos "respawn_east") < _baseDistance
    };

    false
};

ALFA_fnc_repIedCleanup =
{
    params [["_players", [], [[]]]];

    private _now = time;
    private _interval = missionNamespace getVariable ["ALFA_repIedCheckInterval", 180];
    private _lifetime = missionNamespace getVariable ["ALFA_repIedLifetime", 1800];
    private _maxPlayerDistance = missionNamespace getVariable ["ALFA_repIedMaxPlayerDistance", 1200];
    private _activeIeds = missionNamespace getVariable ["ALFA_repActiveIeds", []];
    private _keptIeds = [];

    {
        private _ied = _x;
        private _deleteReason = "";

        if (isNull _ied) then
        {
            _deleteReason = "null";
        }
        else
        {
            private _createdAt = _ied getVariable ["ALFA_repIedCreatedAt", _now];
            if (!alive _ied || { !(mineActive _ied) }) then
            {
                _deleteReason = "inactive";
            };

            if (_deleteReason isEqualTo "" && { _now - _createdAt > _lifetime }) then
            {
                _deleteReason = "expired";
            };

            if (_deleteReason isEqualTo "" && { _players isNotEqualTo [] }) then
            {
                private _nearestPlayerDistance = 1e10;
                {
                    _nearestPlayerDistance = _nearestPlayerDistance min ((vehicle _x) distance2D _ied);
                } forEach _players;

                if (_nearestPlayerDistance > _maxPlayerDistance) then
                {
                    private _farSince = _ied getVariable ["ALFA_repIedFarSince", -1];
                    if (_farSince < 0) then
                    {
                        _ied setVariable ["ALFA_repIedFarSince", _now];
                    }
                    else
                    {
                        if (_now - _farSince >= _interval) then
                        {
                            _deleteReason = "distant";
                        };
                    };
                }
                else
                {
                    _ied setVariable ["ALFA_repIedFarSince", -1];
                };
            };
        };

        if (_deleteReason isEqualTo "") then
        {
            _keptIeds pushBack _ied;
        }
        else
        {
            if (!isNull _ied) then
            {
                diag_log format ["[ALFA_REP_IED] Removing IED at %1 (%2)", getPosATL _ied, _deleteReason];
                deleteVehicle _ied;
            };
        };
    } forEach _activeIeds;

    missionNamespace setVariable ["ALFA_repActiveIeds", _keptIeds];
    _keptIeds
};

ALFA_fnc_repIedCanUsePos =
{
    params [
        ["_pos", [], [[]]],
        ["_players", [], [[]]],
        ["_activeIeds", [], [[]]]
    ];

    if (_pos isEqualTo []) exitWith { false };
    if (surfaceIsWater _pos) exitWith { false };
    if ([_pos] call ALFA_fnc_repIedNearBase) exitWith { false };

    private _minPlayerDistance = missionNamespace getVariable ["ALFA_repIedMinPlayerDistance", 120];
    private _minIedDistance = missionNamespace getVariable ["ALFA_repIedMinIedDistance", 180];
    private _valid = true;

    {
        if ((vehicle _x) distance2D _pos < _minPlayerDistance) exitWith
        {
            _valid = false;
        };
    } forEach _players;

    if (!_valid) exitWith { false };

    {
        if (!isNull _x && { _x distance2D _pos < _minIedDistance }) exitWith
        {
            _valid = false;
        };
    } forEach _activeIeds;

    _valid
};

ALFA_fnc_repIedFindPos =
{
    params [
        ["_players", [], [[]]],
        ["_activeIeds", [], [[]]]
    ];

    if (_players isEqualTo []) exitWith { [] };

    private _minRoadDistance = missionNamespace getVariable ["ALFA_repIedMinRoadDistance", 500];
    private _maxRoadDistance = missionNamespace getVariable ["ALFA_repIedMaxRoadDistance", 900];
    private _result = [];
    private _attempt = 0;

    while { _attempt < 20 && { _result isEqualTo [] } } do
    {
        private _player = selectRandom _players;
        private _anchor = getPosATL (vehicle _player);
        private _roads = (_anchor nearRoads _maxRoadDistance) select
        {
            private _roadPos = getPosATL _x;
            private _distance = _anchor distance2D _roadPos;
            _distance >= _minRoadDistance && { _distance <= _maxRoadDistance }
        };

        if (_roads isNotEqualTo []) then
        {
            private _road = selectRandom _roads;
            private _roadPos = getPosATL _road;
            private _offsetDistance = random 5;
            private _offsetDirection = random 360;
            private _candidate = _roadPos getPos [_offsetDistance, _offsetDirection];
            _candidate set [2, 0];

            if ([_candidate, _players, _activeIeds] call ALFA_fnc_repIedCanUsePos) then
            {
                _result = _candidate;
            };
        };

        _attempt = _attempt + 1;
    };

    _result
};

ALFA_fnc_repIedSpawn =
{
    params [
        ["_players", [], [[]]],
        ["_activeIeds", [], [[]]],
        ["_rep", 50, [0]]
    ];

    private _availableIeds = missionNamespace getVariable ["ALFA_repIedClasses", []];
    if (_availableIeds isEqualTo []) exitWith { objNull };

    private _pos = [_players, _activeIeds] call ALFA_fnc_repIedFindPos;
    if (_pos isEqualTo []) exitWith { objNull };

    private _iedClass = selectRandom _availableIeds;
    private _ied = createMine [_iedClass, _pos, [], 0];
    if (isNull _ied) exitWith { objNull };

    _ied setVariable ["ALFA_repIed", true, true];
    _ied setVariable ["ALFA_repIedCreatedAt", time, true];
    _ied setVariable ["ALFA_repIedSource", "civilian_reputation", true];
    _ied setVariable ["ALFA_repIedFarSince", -1];

    diag_log format ["[ALFA_REP_IED] Spawned %1 at %2 (rep=%3)", _iedClass, _pos, _rep];
    _ied
};

if (_availableIeds isEqualTo []) exitWith
{
    diag_log "[ALFA_REP_IED] No IED classes available. Civilian IED threat disabled.";
};

diag_log format ["[ALFA_REP_IED] Civilian IED threat initialized. Classes=%1", _availableIeds];

[] spawn
{
    sleep 30;

    while { true } do
    {
        private _interval = missionNamespace getVariable ["ALFA_repIedCheckInterval", 180];
        private _threshold = missionNamespace getVariable ["ALFA_repIedThreshold", 30];
        private _maxActive = missionNamespace getVariable ["ALFA_repIedMaxActive", 6];
        private _rep = missionNamespace getVariable ["ALFA_civilianReputation", 50];
        private _players = call ALFA_fnc_repIedPlayers;
        private _activeIeds = [_players] call ALFA_fnc_repIedCleanup;

        if (_rep < _threshold && { _players isNotEqualTo [] } && { count _activeIeds < _maxActive }) then
        {
            private _threat = (((_threshold - _rep) / _threshold) max 0) min 1;
            private _spawnChance = 0.15 + (_threat * 0.35);

            if ((random 1) < _spawnChance) then
            {
                private _ied = [_players, _activeIeds, _rep] call ALFA_fnc_repIedSpawn;
                if (!isNull _ied) then
                {
                    _activeIeds pushBack _ied;
                    missionNamespace setVariable ["ALFA_repActiveIeds", _activeIeds];
                };
            };
        };

        sleep _interval;
    };
};
