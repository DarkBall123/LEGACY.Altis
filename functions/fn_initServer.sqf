diag_log "[DZ] === Dynamic Zones INIT ===";

private _gridSize = missionNamespace getVariable ["DZ_gridSize", 350];
private _sectorBuild = [_gridSize, worldSize] call DZ_fnc_buildSectorGrid;
private _sectorGrid = _sectorBuild # 0;
private _sectorLookup = _sectorBuild # 1;
private _cells = _sectorGrid apply { [_x # 1, _x # 2, 0] };
private _zoneTemplate = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _zoneData = [];
private _sectorAdjacency = [];
private _sectorDominance = [];
private _spawnBlockedUntil = [];
private _firstCounterDone = [];
private _nextCounterAt = [];

_zoneData resize (count _sectorGrid);
_sectorAdjacency resize (count _sectorGrid);
_sectorDominance resize (count _sectorGrid);
_spawnBlockedUntil resize (count _sectorGrid);
_firstCounterDone resize (count _sectorGrid);
_nextCounterAt resize (count _sectorGrid);

for "_idx" from 0 to ((count _sectorGrid) - 1) do
{
    _zoneData set [_idx, +_zoneTemplate];
    _sectorDominance set [_idx, [sideUnknown, -1]];
    _spawnBlockedUntil set [_idx, 0];
    _firstCounterDone set [_idx, false];
    _nextCounterAt set [_idx, 0];
};

{
    _x params ["_sectorId", "_centerX", "_centerY"];

    private _xIndex = floor (_centerX / _gridSize);
    private _yIndex = floor (_centerY / _gridSize);
    private _neighbors = [];

    {
        private _dx = _x;

        {
            private _dy = _x;

            if (_dx == 0 && { _dy == 0 }) then
            {
                continue;
            };

            private _neighborId = _sectorLookup getOrDefault [format ["%1_%2", _xIndex + _dx, _yIndex + _dy], -1];

            if (_neighborId >= 0) then
            {
                _neighbors pushBackUnique _neighborId;
            };
        } forEach [-1, 0, 1];
    } forEach [-1, 0, 1];

    _sectorAdjacency set [_sectorId, _neighbors];
} forEach _sectorGrid;

missionNamespace setVariable ["DZ_gridSize", _gridSize, true];
missionNamespace setVariable ["DZ_sectorGrid", _sectorGrid, true];
missionNamespace setVariable ["DZ_sectorLookup", _sectorLookup];
missionNamespace setVariable ["DZ_sectorAdjacency", _sectorAdjacency];
missionNamespace setVariable ["DZ_cells", _cells];
missionNamespace setVariable ["DZ_zoneData", _zoneData];
missionNamespace setVariable ["DZ_sectorDominance", _sectorDominance];
missionNamespace setVariable ["DZ_spawnBlockedUntil", _spawnBlockedUntil];
missionNamespace setVariable ["DZ_firstCounterDone", _firstCounterDone];
missionNamespace setVariable ["DZ_nextCounterAt", _nextCounterAt];
missionNamespace setVariable ["DZ_savedCapturesCache", []];
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
