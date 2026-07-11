/*
 * DZ_fnc_spawnEnemyAirSupport
 * Spawns one MEF aircraft as a background threat near active players.
 */

if (!isServer) exitWith { false };

private _classPool = missionNamespace getVariable ["DZ_enemyAirSupportAvailableClasses", []];
if (_classPool isEqualTo []) then
{
    _classPool = missionNamespace getVariable ["DZ_enemyAirSupportClasses", []];
};

private _validPool = [];
private _totalWeight = 0;
{
    _x params [["_className", ""], ["_weight", 1]];

    if (_className != "" && { _weight > 0 } && { isClass (configFile >> "CfgVehicles" >> _className) }) then
    {
        _validPool pushBack [_className, _weight];
        _totalWeight = _totalWeight + _weight;
    };
} forEach _classPool;

if (_validPool isEqualTo [] || { _totalWeight <= 0 }) exitWith
{
    diag_log "[DZ_AIR_SUPPORT] Spawn skipped: no valid aircraft classes.";
    false
};

private _active = missionNamespace getVariable ["DZ_enemyAirSupportActive", []];
private _activeAlive = _active select
{
    private _aircraft = _x param [0, objNull];
    !isNull _aircraft && { alive _aircraft || { ({ isPlayer _x } count (crew _aircraft)) > 0 } }
};
missionNamespace setVariable ["DZ_enemyAirSupportActive", _activeAlive];

private _maxActive = missionNamespace getVariable ["DZ_enemyAirSupportMaxActive", 1];
if ((count _activeAlive) >= _maxActive) exitWith { false };

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _baseExclusionRadius = missionNamespace getVariable ["DZ_enemyAirSupportBaseExclusionRadius", 900];
private _respawnPoints = missionNamespace getVariable ["DZ_respawnPointsResolved", []];
private _safeMarkers = missionNamespace getVariable ["DZ_enemyAirSupportSafeMarkers", ["base_safe_zone"]];

private _isNearSafeArea =
{
    params ["_pos"];

    private _nearSafe = false;

    {
        private _entryPos = _x param [1, []];
        if (_entryPos isEqualType [] && { (count _entryPos) >= 2 } && { _pos distance2D _entryPos < _baseExclusionRadius }) exitWith
        {
            _nearSafe = true;
        };
    } forEach _respawnPoints;

    if (_nearSafe) exitWith { true };

    {
        if ((markerShape _x) == "") then
        {
            continue;
        };

        private _markerPos = getMarkerPos _x;
        private _markerSize = getMarkerSize _x;
        private _sizeA = (_markerSize param [0, 0]) max 1;
        private _sizeB = (_markerSize param [1, 0]) max 1;
        private _markerDir = markerDir _x;
        private _dx = (_pos # 0) - (_markerPos # 0);
        private _dy = (_pos # 1) - (_markerPos # 1);
        private _localX = (_dx * cos _markerDir) - (_dy * sin _markerDir);
        private _localY = (_dx * sin _markerDir) + (_dy * cos _markerDir);

        switch (markerShape _x) do
        {
            case "RECTANGLE":
            {
                if (abs _localX <= _sizeA && { abs _localY <= _sizeB }) exitWith
                {
                    _nearSafe = true;
                };
            };
            case "ELLIPSE":
            {
                if (((_localX / _sizeA) ^ 2) + ((_localY / _sizeB) ^ 2) <= 1) exitWith
                {
                    _nearSafe = true;
                };
            };
            default
            {
                if (_pos distance2D _markerPos <= (_sizeA max _sizeB)) exitWith
                {
                    _nearSafe = true;
                };
            };
        };

        if (_nearSafe) exitWith {};
    } forEach _safeMarkers;

    _nearSafe
};

private _players = allPlayers select
{
    private _unit = _x;
    alive _unit &&
    { (side _unit) in _playerSides } &&
    { !([getPosATL (vehicle _unit)] call _isNearSafeArea) }
};

if (_players isEqualTo []) exitWith { false };

private _roll = random _totalWeight;
private _accum = 0;
private _aircraftClass = (_validPool # 0) # 0;
{
    _x params ["_className", "_weight"];
    _accum = _accum + _weight;

    if (_roll <= _accum) exitWith
    {
        _aircraftClass = _className;
    };
} forEach _validPool;

private _targetPlayer = selectRandom _players;
private _targetPos = getPosATL (vehicle _targetPlayer);
private _isMystere = (_aircraftClass isKindOf "Plane");
private _spawnDistance = if (_isMystere) then
{
    missionNamespace getVariable ["DZ_enemyAirSupportPlaneSpawnDistance", 4500]
}
else
{
    missionNamespace getVariable ["DZ_enemyAirSupportHeliSpawnDistance", 2500]
};
private _spawnAltitude = if (_isMystere) then { 450 } else { 180 };
private _flyHeight = if (_isMystere) then { 350 } else { 130 };
private _worldMargin = 500;
private _spawnPos = [];

for "_i" from 0 to 15 do
{
    private _candidate = _targetPos getPos [_spawnDistance + random 800, random 360];
    if (
        (_candidate # 0) > _worldMargin &&
        { (_candidate # 1) > _worldMargin } &&
        { (_candidate # 0) < (worldSize - _worldMargin) } &&
        { (_candidate # 1) < (worldSize - _worldMargin) }
    ) exitWith
    {
        _spawnPos = [_candidate # 0, _candidate # 1, _spawnAltitude];
    };
};

if (_spawnPos isEqualTo []) exitWith
{
    diag_log format ["[DZ_AIR_SUPPORT] Spawn skipped: no airborne spawn position near %1.", _targetPos];
    false
};

private _aircraft = createVehicle [_aircraftClass, _spawnPos, [], 0, "FLY"];
if (isNull _aircraft) exitWith { false };

_aircraft setPosATL _spawnPos;
_aircraft setDir (_spawnPos getDir _targetPos);
_aircraft setFuel 1;
_aircraft setVehicleAmmo 1;
_aircraft flyInHeight _flyHeight;
_aircraft lock 0;
_aircraft setVariable ["DZ_enemyAirSupport", true, true];
_aircraft setVariable ["DZ_noCleanup", true, true];

private _crewGroup = createVehicleCrew _aircraft;
if (isNull _crewGroup || { (crew _aircraft) isEqualTo [] }) exitWith
{
    deleteVehicle _aircraft;
    diag_log format ["[DZ_AIR_SUPPORT] Spawn failed: no crew for %1.", _aircraftClass];
    false
};

_crewGroup setBehaviour "AWARE";
_crewGroup setCombatMode "RED";
_crewGroup setSpeedMode (["NORMAL", "FULL"] select _isMystere);

{
    _x allowFleeing 0;
    [_x] call DZ_fnc_prepareSpawnedUnit;
} forEach units _crewGroup;

private _patrolRadius = missionNamespace getVariable ["DZ_enemyAirSupportPatrolRadius", 900];
{
    if (_x distance2D _targetPos < (_patrolRadius * 1.5)) then
    {
        _crewGroup reveal [_x, 4];
        _crewGroup reveal [vehicle _x, 4];
    };
} forEach _players;

private _firstWp = _crewGroup addWaypoint [_targetPos, 0];
_firstWp setWaypointType "SAD";
_firstWp setWaypointBehaviour "AWARE";
_firstWp setWaypointCombatMode "RED";
_firstWp setWaypointSpeed (["NORMAL", "FULL"] select _isMystere);

for "_i" from 1 to 3 do
{
    private _wpPos = _targetPos getPos [_patrolRadius, random 360];
    private _wp = _crewGroup addWaypoint [_wpPos, 0];
    _wp setWaypointType (["MOVE", "SAD"] select (!_isMystere && { _i == 2 }));
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";
    _wp setWaypointSpeed (["NORMAL", "FULL"] select _isMystere);
};

private _cycleWp = _crewGroup addWaypoint [_targetPos, 0];
_cycleWp setWaypointType "CYCLE";

private _activeEntry = [_aircraft, _crewGroup, time, _aircraftClass, _targetPos];
_activeAlive pushBack _activeEntry;
missionNamespace setVariable ["DZ_enemyAirSupportActive", _activeAlive];
missionNamespace setVariable ["DZ_enemyAirSupportLastSpawn", time];

diag_log format
[
    "[DZ_AIR_SUPPORT] Spawned %1 at %2 against player %3 near %4.",
    _aircraftClass,
    _spawnPos,
    name _targetPlayer,
    _targetPos
];

true
