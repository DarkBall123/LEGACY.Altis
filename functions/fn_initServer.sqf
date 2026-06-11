/*
 * DZ_fnc_initServer
 * Initializes server-side sector control state and starts the sector PFH.
 */

diag_log "[DZ] === Dynamic Zones INIT ===";

private _gridSize    = missionNamespace getVariable ["DZ_gridSize", 350];
private _sectorBuild = [_gridSize, worldSize] call DZ_fnc_buildSectorGrid;
private _sectorGrid   = _sectorBuild # 0;
private _sectorLookup = _sectorBuild # 1;
private _zoneRadii    = _sectorBuild param [2, []];   // NEW (Option B refactor)
private _zoneNames    = _sectorBuild param [3, []];   // NEW
private _zoneTypes    = _sectorBuild param [4, []];   // NEW
private _cells = _sectorGrid apply { [_x # 1, _x # 2, 0] };
private _zoneTemplate = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _zoneData = [];
private _sectorAdjacency = [];
private _sectorDominance = [];
private _sectorOwner = [];
private _spawnBlockedUntil = [];
private _firstCounterDone = [];
private _nextCounterAt = [];

_zoneData resize (count _sectorGrid);
_sectorAdjacency resize (count _sectorGrid);
_sectorDominance resize (count _sectorGrid);
_sectorOwner resize (count _sectorGrid);
_spawnBlockedUntil resize (count _sectorGrid);
_firstCounterDone resize (count _sectorGrid);
_nextCounterAt resize (count _sectorGrid);

private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy", east];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

for "_idx" from 0 to ((count _sectorGrid) - 1) do
{
    _zoneData set [_idx, +_zoneTemplate];
    _sectorDominance set [_idx, [sideUnknown, -1]];
    _sectorOwner set [_idx, _sideEnemy];
    _spawnBlockedUntil set [_idx, 0];
    _firstCounterDone set [_idx, false];
    _nextCounterAt set [_idx, 0];
};

// Proximity-based adjacency (Option B): two zones are neighbours if
// their boundaries are close enough to walk between. Threshold is
// (radius_A + radius_B + DZ_adjacencyBuffer). Default buffer 800 m.
//
// Each zone is also capped at DZ_adjacencyMaxNeighbours (default 8)
// nearest neighbours so a capital surrounded by villages doesn't end
// up with 20+ links bogging down the frontier graph.
private _adjacencyBuffer  = missionNamespace getVariable ["DZ_adjacencyBuffer", 800];
private _adjacencyMaxN    = missionNamespace getVariable ["DZ_adjacencyMaxNeighbours", 8];

{
    _x params ["_sectorId", "_centerX", "_centerY"];
    private _ownPos    = [_centerX, _centerY, 0];
    private _ownRadius = _zoneRadii param [_sectorId, 600];

    private _candidates = [];

    {
        _x params ["_otherId", "_otherX", "_otherY"];
        if (_otherId == _sectorId) then { continue };

        private _otherPos    = [_otherX, _otherY, 0];
        private _otherRadius = _zoneRadii param [_otherId, 600];
        private _dist        = _ownPos distance2D _otherPos;
        private _threshold   = _ownRadius + _otherRadius + _adjacencyBuffer;

        if (_dist <= _threshold) then
        {
            _candidates pushBack [_dist, _otherId];
        };
    } forEach _sectorGrid;

    // Keep only the N closest, sorted ascending by distance.
    _candidates sort true;
    private _neighbors = (_candidates select [0, _adjacencyMaxN]) apply { _x # 1 };

    _sectorAdjacency set [_sectorId, _neighbors];
} forEach _sectorGrid;

if (missionNamespace getVariable ["DZ_frontierSeedBaseSectors", true]) then
{
    private _baseRadius = missionNamespace getVariable ["DZ_frontierBaseRadius", _gridSize * 1.25];
    private _respawnPoints = missionNamespace getVariable ["DZ_respawnPoints", []];

    {
        _x params ["_label", "_pos", "_side"];

        if (_side in _playerSides) then
        {
            private _seedIds = [];
            private _nearestId = -1;
            private _nearestDist = 1e12;

            {
                private _sectorId = _forEachIndex;
                private _dist = _x distance2D _pos;

                if (_dist < _nearestDist) then
                {
                    _nearestDist = _dist;
                    _nearestId = _sectorId;
                };

                if (_dist <= _baseRadius) then
                {
                    _seedIds pushBackUnique _sectorId;
                };
            } forEach _cells;

            if (_seedIds isEqualTo [] && { _nearestId >= 0 }) then
            {
                _seedIds pushBack _nearestId;
            };

            {
                _sectorOwner set [_x, _side];
            } forEach _seedIds;
        };
    } forEach _respawnPoints;
};

missionNamespace setVariable ["DZ_gridSize",       _gridSize, true];
missionNamespace setVariable ["DZ_sectorGrid",     _sectorGrid, true];
missionNamespace setVariable ["DZ_sectorLookup",   _sectorLookup];
missionNamespace setVariable ["DZ_sectorAdjacency",_sectorAdjacency];
missionNamespace setVariable ["DZ_cells",          _cells];
missionNamespace setVariable ["DZ_zoneData",       _zoneData];

// NEW (Option B refactor): per-zone radius / display name / type.
missionNamespace setVariable ["DZ_zoneRadii",      _zoneRadii, true];
missionNamespace setVariable ["DZ_zoneNames",      _zoneNames, true];
missionNamespace setVariable ["DZ_zoneTypes",      _zoneTypes, true];

// Helper that resolves a sector's effective radius. Falls back to the
// legacy DZ_sectorInfluenceRadius constant for safety so any caller
// that misses the new array still gets a usable value.
DZ_fnc_sectorRadius = {
    params [["_sectorId", -1, [0]]];
    private _radii    = missionNamespace getVariable ["DZ_zoneRadii", []];
    private _fallback = missionNamespace getVariable ["DZ_sectorInfluenceRadius", 315];
    if (_sectorId < 0 || { _sectorId >= count _radii }) exitWith { _fallback };
    _radii param [_sectorId, _fallback]
};

// Helper for human-readable name (side messages, hints, debug logs).
DZ_fnc_sectorName = {
    params [["_sectorId", -1, [0]]];
    private _names = missionNamespace getVariable ["DZ_zoneNames", []];
    if (_sectorId < 0 || { _sectorId >= count _names }) exitWith { format ["сектор #%1", _sectorId] };
    _names param [_sectorId, format ["сектор #%1", _sectorId]]
};
missionNamespace setVariable ["DZ_sectorDominance", _sectorDominance];
missionNamespace setVariable ["DZ_sectorOwner", _sectorOwner];
missionNamespace setVariable ["DZ_spawnBlockedUntil", _spawnBlockedUntil];
missionNamespace setVariable ["DZ_firstCounterDone", _firstCounterDone];
missionNamespace setVariable ["DZ_nextCounterAt", _nextCounterAt];
missionNamespace setVariable ["DZ_savedCapturesCache", profileNamespace getVariable ["DZ_savedCaptures", []]];
missionNamespace setVariable ["DZ_savedSectorOwners", profileNamespace getVariable ["DZ_savedSectorOwners", []]];
missionNamespace setVariable ["DZ_capturedHash", createHashMap];
missionNamespace setVariable ["DZ_lastSectorVisualState", []];
missionNamespace setVariable ["DZ_loadoutsDirty", false];

private _urbanHash = call DZ_fnc_getUrbanCells;
missionNamespace setVariable ["DZ_urbanHash", _urbanHash];

private _savedLoadoutsCache = createHashMap;
{
    private _entry = _x;
    private _entryUid = _entry param [0, ""];
    private _entryLoadout = _entry param [1, []];

    if (_entryUid != "" && { _entryLoadout isEqualType [] } && { _entryLoadout isNotEqualTo [] }) then
    {
        _savedLoadoutsCache set [_entryUid, _entryLoadout];
    };
} forEach (profileNamespace getVariable ["DZ_savedPlayerLoadouts", []]);
missionNamespace setVariable ["DZ_savedLoadoutsCache", _savedLoadoutsCache];

call DZ_fnc_initRespawnMarkers;
[_sectorGrid] call DZ_fnc_initSectorVisualState;
call DZ_fnc_processTriggerZones;
call DZ_fnc_publishSectorState;

missionNamespace setVariable ["DZ_assetsDirty", false];
call DZ_fnc_restoreAssets;

if !(missionNamespace getVariable ["DZ_zoneSchedulerStarted", false]) then
{
    missionNamespace setVariable ["DZ_zoneSchedulerStarted", true];

    [] spawn
    {
        while { true } do
        {
            [] call DZ_fnc_handleZonesPFH;
            sleep (missionNamespace getVariable ["DZ_updateInterval", 1]);
        };
    };
};

addMissionEventHandler
[
    "HandleDisconnect",
    {
        params ["_unit", "_id", "_uid"];

        [_unit, true, _uid] call DZ_fnc_savePlayerLoadout;
        [true] call DZ_fnc_saveAssets;
        false
    }
];

if !(missionNamespace getVariable ["DZ_loadoutSaveStarted", false]) then
{
    missionNamespace setVariable ["DZ_loadoutSaveStarted", true];

    [] spawn
    {
        while { true } do
        {
            sleep (missionNamespace getVariable ["DZ_loadoutSaveInterval", 60]);

            {
                [_x] call DZ_fnc_savePlayerLoadout;
            } forEach (allPlayers select { !isNull _x && { isPlayer _x } && { alive _x } });

            if (missionNamespace getVariable ["DZ_loadoutsDirty", false]) then
            {
                call DZ_fnc_flushSavedLoadouts;
            };
        };
    };
};

if !(missionNamespace getVariable ["DZ_assetSaveStarted", false]) then
{
    missionNamespace setVariable ["DZ_assetSaveStarted", true];

    [] spawn
    {
        while { true } do
        {
            sleep (missionNamespace getVariable ["DZ_assetSaveInterval", 300]);
            missionNamespace setVariable ["DZ_assetsDirty", true];
            call DZ_fnc_saveAssets;
        };
    };
};

if ((missionNamespace getVariable ["DZ_enableCorpseCleanup", false]) && { !(missionNamespace getVariable ["DZ_corpseCleanupStarted", false]) }) then
{
    missionNamespace setVariable ["DZ_corpseCleanupStarted", true];

    [] spawn
    {
        while { true } do
        {
            sleep (missionNamespace getVariable ["DZ_corpseCleanupInterval", 600]);

            private _corpses = allDeadMen select { !isNull _x };
            private _vehicleCleanupCandidates = vehicles select
            {
                private _vehicle = _x;

                !isNull _vehicle &&
                { !(_vehicle isKindOf "CAManBase") } &&
                { (!alive _vehicle) || { !canMove _vehicle } } &&
                { ({ alive _x } count crew _vehicle) == 0 }
            };
            private _deadVehicles = _vehicleCleanupCandidates arrayIntersect _vehicleCleanupCandidates;

            {
                deleteVehicle _x;
            } forEach _corpses;

            {
                {
                    if (!isNull _x) then
                    {
                        deleteVehicle _x;
                    };
                } forEach crew _x;

                deleteVehicle _x;
            } forEach _deadVehicles;

            diag_log format
            [
                "[DZ] Cleanup removed %1 corpses and %2 dead vehicles",
                count _corpses,
                count _deadVehicles
            ];
        };
    };
};

if !(missionNamespace getVariable ["DZ_enableCorpseCleanup", false]) then
{
    diag_log "[DZ] Corpse and dead vehicle cleanup disabled";
};

diag_log "[DZ] === Dynamic Zones READY ===";
