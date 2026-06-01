/*
 * DZ_fnc_handleZonesPFH
 * Runs the main sector control loop for capture, spawning, despawn, and counterattack checks.
 */

private _eps = missionNamespace getVariable ["DZ_eps", 300];
private _sectorInfluenceRadius = missionNamespace getVariable ["DZ_sectorInfluenceRadius", _eps];
private _gridSize = missionNamespace getVariable ["DZ_gridSize", 350];
private _preMul = missionNamespace getVariable ["DZ_preSpawnFactor", 1.5];
private _preR = _eps * _preMul;
private _delayCleanup = missionNamespace getVariable ["DZ_cleanupDelay", 30];
private _enableLiveDespawn = missionNamespace getVariable ["DZ_enableLiveDespawn", false];
private _cpChance = missionNamespace getVariable ["DZ_cpChance", 0.003];

private _captureHold = missionNamespace getVariable ["DZ_captureHold", 60];
private _recaptureSpawnCooldown = missionNamespace getVariable ["DZ_recaptureSpawnCooldown", 180];
private _counterRepeatCooldown = missionNamespace getVariable ["DZ_counterRepeatCooldown", 180];
private _counterGlobalCooldown = missionNamespace getVariable ["DZ_counterGlobalCooldown", 180];
private _counterFirstChance = missionNamespace getVariable ["DZ_counterFirstChance", 0.03];
private _counterRepeatChance = missionNamespace getVariable ["DZ_counterRepeatChance", 0.02];
private _counterMaxActive = missionNamespace getVariable ["DZ_counterMaxActive", 2];
private _counterEnabled = missionNamespace getVariable ["DZ_counterAttacksEnabled", true];
private _frontMinEnemyNeighbors = missionNamespace getVariable ["DZ_frontMinEnemyNeighbors", 2];
private _spawnRetryCooldown = missionNamespace getVariable ["DZ_spawnRetryCooldown", 30];
private _frontierCaptureOnly = missionNamespace getVariable ["DZ_frontierCaptureOnly", true];
private _frontierSeedBaseSectors = missionNamespace getVariable ["DZ_frontierSeedBaseSectors", true];
private _frontierBaseRadius = missionNamespace getVariable ["DZ_frontierBaseRadius", _gridSize * 1.25];
private _frontierPruneDisconnectedSaves = missionNamespace getVariable ["DZ_frontierPruneDisconnectedSaves", true];
private _frontierAllowDisconnectedLandings = missionNamespace getVariable ["DZ_frontierAllowDisconnectedLandings", true];

private _cells = missionNamespace getVariable ["DZ_cells", []];
private _sectorLookup = missionNamespace getVariable ["DZ_sectorLookup", createHashMap];
private _sectorAdjacency = missionNamespace getVariable ["DZ_sectorAdjacency", []];
private _urbanHash = missionNamespace getVariable ["DZ_urbanHash", createHashMap];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _zoneTemplate = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sectorDominance = missionNamespace getVariable ["DZ_sectorDominance", []];
private _sectorOwner = missionNamespace getVariable ["DZ_sectorOwner", []];
private _spawnBlockedUntil = missionNamespace getVariable ["DZ_spawnBlockedUntil", []];
private _firstCounterDone = missionNamespace getVariable ["DZ_firstCounterDone", []];
private _nextCounterAt = missionNamespace getVariable ["DZ_nextCounterAt", []];
private _nextGlobalCounterAt = missionNamespace getVariable ["DZ_nextGlobalCounterAt", 0];
private _sideEnemy   = missionNamespace getVariable ["CH_sideEnemy", east];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _respawnPoints = missionNamespace getVariable ["DZ_respawnPoints", []];
private _now = time;
private _sectorCount = count _cells;

private _styleEnemyDormant = missionNamespace getVariable ["DZ_styleEnemyDormant", 0];
private _styleEnemyActive = missionNamespace getVariable ["DZ_styleEnemyActive", 1];
private _stylePlayerOwned = missionNamespace getVariable ["DZ_stylePlayerOwned", 2];
private _styleContested = missionNamespace getVariable ["DZ_styleContested", 3];
private _styleWestOwned = missionNamespace getVariable ["DZ_styleWestOwned", 0];
private _styleEastOwned = missionNamespace getVariable ["DZ_styleEastOwned", _styleEnemyDormant];
private _styleResistanceOwned = missionNamespace getVariable ["DZ_styleResistanceOwned", 2];

private _saved = missionNamespace getVariable ["DZ_savedCapturesCache", profileNamespace getVariable ["DZ_savedCaptures", []]];
if !(_saved isEqualType []) then
{
    _saved = [];
};

private _savedOwners = missionNamespace getVariable ["DZ_savedSectorOwners", profileNamespace getVariable ["DZ_savedSectorOwners", []]];
if !(_savedOwners isEqualType []) then
{
    _savedOwners = [];
};

private _captHash = missionNamespace getVariable ["DZ_capturedHash", createHashMap];
if ((count (keys _captHash)) == 0 && { count _saved > 0 }) then
{
    {
        _captHash set [_x, true];
    } forEach _saved;
};

private _fnc_sideToKey =
{
    params ["_side"];

    switch (true) do
    {
        case (_side isEqualTo west):       { "WEST" };
        case (_side isEqualTo east):       { "EAST" };
        case (_side isEqualTo resistance): { "GUER" };
        default { "" };
    }
};

private _fnc_keyToSide =
{
    params [["_key", ""]];

    switch (toUpper _key) do
    {
        case "WEST": { west };
        case "EAST": { east };
        case "GUER": { resistance };
        default { sideUnknown };
    }
};

private _fnc_setSavedOwner =
{
    params ["_sectorId", "_side"];

    private _entryIdx = _savedOwners findIf { (_x param [0, -1]) isEqualTo _sectorId };
    if (_entryIdx >= 0) then
    {
        _savedOwners deleteAt _entryIdx;
    };

    private _key = [_side] call _fnc_sideToKey;
    if (_key != "" && { !(_side isEqualTo _sideEnemy) }) then
    {
        _savedOwners pushBack [_sectorId, _key];
    };
};

private _fnc_ownerStyle =
{
    params ["_side"];

    switch (true) do
    {
        case (_side isEqualTo west):       { _styleWestOwned };
        case (_side isEqualTo east):       { _styleEastOwned };
        case (_side isEqualTo resistance): { _styleResistanceOwned };
        default { _styleEastOwned };
    }
};

private _fnc_dominantSide =
{
    params ["_counts"];

    _counts params [["_westCount", 0], ["_resistanceCount", 0], ["_eastCount", 0]];

    private _bestSide = sideUnknown;
    private _bestCount = 0;
    private _tied = false;

    {
        _x params ["_side", "_count"];

        if (_count > _bestCount) then
        {
            _bestSide = _side;
            _bestCount = _count;
            _tied = false;
        }
        else
        {
            if (_count > 0 && { _count == _bestCount }) then
            {
                _tied = true;
            };
        };
    } forEach [[west, _westCount], [resistance, _resistanceCount], [_sideEnemy, _eastCount]];

    if (_bestCount <= 0 || { _tied }) exitWith { sideUnknown };

    _bestSide
};

private _fnc_resizeArray =
{
    params ["_array", "_targetSize", "_defaultValue"];

    private _result = +_array;
    _result resize _targetSize;

    for "_idx" from 0 to (_targetSize - 1) do
    {
        if (isNil { _result # _idx }) then
        {
            private _defaultEntry = if (_defaultValue isEqualType []) then { +_defaultValue } else { _defaultValue };
            _result set [_idx, _defaultEntry];
        };
    };

    _result
};

private _fnc_baseSectorIdsBySide =
{
    private _result = createHashMap;

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

                if (_dist <= _frontierBaseRadius) then
                {
                    _seedIds pushBackUnique _sectorId;
                };
            } forEach _cells;

            if (_seedIds isEqualTo [] && { _nearestId >= 0 }) then
            {
                _seedIds pushBack _nearestId;
            };

            private _key = str _side;
            private _existing = _result getOrDefault [_key, []];
            _existing append _seedIds;
            _result set [_key, _existing arrayIntersect _existing];
        };
    } forEach _respawnPoints;

    _result
};

private _baseSectorIdsBySide = call _fnc_baseSectorIdsBySide;

private _baseSectorIds = [];
{
    _baseSectorIds append (_baseSectorIdsBySide get _x);
} forEach (keys _baseSectorIdsBySide);
_baseSectorIds = _baseSectorIds arrayIntersect _baseSectorIds;

private _fnc_isDisconnectedLandSector =
{
    params ["_sectorId"];

    if (!_frontierAllowDisconnectedLandings) exitWith { false };
    if (_sectorId in _baseSectorIds) exitWith { false };

    private _visited = createHashMap;
    private _queue = [_sectorId];
    private _touchesBaseComponent = false;

    while { !_touchesBaseComponent && { _queue isNotEqualTo [] } } do
    {
        private _current = _queue deleteAt 0;

        if (isNil { _visited get _current }) then
        {
            _visited set [_current, true];

            if (_current in _baseSectorIds) then
            {
                _touchesBaseComponent = true;
            }
            else
            {
                {
                    if (isNil { _visited get _x }) then
                    {
                        _queue pushBack _x;
                    };
                } forEach (_sectorAdjacency param [_current, []]);
            };
        };
    };

    !_touchesBaseComponent
};

private _fnc_hasOwnedNeighbor =
{
    params ["_sectorId", "_side"];

    private _neighbors = _sectorAdjacency param [_sectorId, []];
    (_neighbors findIf { (_sectorOwner param [_x, _sideEnemy]) isEqualTo _side }) >= 0
};

private _fnc_canCaptureByFrontier =
{
    params ["_sectorId", "_attackerSide", "_ownerSide"];

    if (!_frontierCaptureOnly) exitWith { true };
    if (_attackerSide isEqualTo sideUnknown) exitWith { false };
    if (_attackerSide isEqualTo _ownerSide) exitWith { true };
    if ([_sectorId] call _fnc_isDisconnectedLandSector) exitWith { true };

    [_sectorId, _attackerSide] call _fnc_hasOwnedNeighbor
};

private _fnc_seedBaseSectors =
{
    if (!_frontierSeedBaseSectors) exitWith {};

    {
        private _side = [_x] call _fnc_keyToSide;
        private _seedIds = _baseSectorIdsBySide getOrDefault [_x, []];

        {
            if (_x >= 0 && { _x < _sectorCount }) then
            {
                if (!((_sectorOwner param [_x, _sideEnemy]) isEqualTo _side)) then
                {
                    _sectorOwner set [_x, _side];
                    _sectorDominance set [_x, [sideUnknown, -1]];
                    _capturesDirty = true;
                };

                if (_side in _playerSides) then
                {
                    private _wasSaved = _x in _saved;
                    _captHash set [_x, true];
                    _saved pushBackUnique _x;
                    [_x, _side] call _fnc_setSavedOwner;

                    if (!_wasSaved) then
                    {
                        _capturesDirty = true;
                    };
                };
            };
        } forEach _seedIds;
    } forEach (keys _baseSectorIdsBySide);
};

private _fnc_isConnectedToBase =
{
    params ["_sectorId", "_side"];

    private _baseIds = _baseSectorIdsBySide getOrDefault [str _side, []];
    if (_baseIds isEqualTo []) exitWith { true };
    if (_sectorId in _baseIds) exitWith { true };

    private _visited = createHashMap;
    private _queue = +_baseIds;
    private _connected = false;

    while { !_connected && { _queue isNotEqualTo [] } } do
    {
        private _current = _queue deleteAt 0;

        if (isNil { _visited get _current }) then
        {
            _visited set [_current, true];

            if (_current isEqualTo _sectorId) then
            {
                _connected = true;
            }
            else
            {
                {
                    if ((_sectorOwner param [_x, _sideEnemy]) isEqualTo _side && { isNil { _visited get _x } }) then
                    {
                        _queue pushBack _x;
                    };
                } forEach (_sectorAdjacency param [_current, []]);
            };
        };
    };

    _connected
};

_zoneData = [_zoneData, _sectorCount, _zoneTemplate] call _fnc_resizeArray;
_sectorDominance = [_sectorDominance, _sectorCount, [sideUnknown, -1]] call _fnc_resizeArray;
_sectorOwner = [_sectorOwner, _sectorCount, _sideEnemy] call _fnc_resizeArray;
_spawnBlockedUntil = [_spawnBlockedUntil, _sectorCount, 0] call _fnc_resizeArray;
_firstCounterDone = [_firstCounterDone, _sectorCount, false] call _fnc_resizeArray;
_nextCounterAt = [_nextCounterAt, _sectorCount, 0] call _fnc_resizeArray;

private _capturesDirty = false;

_savedOwners = _savedOwners select
{
    (_x isEqualType []) &&
    { (_x param [0, -1]) isEqualType 0 } &&
    { (_x param [1, ""]) isEqualType "" }
};

{
    private _sectorId = _x param [0, -1];
    private _ownerSide = [_x param [1, ""]] call _fnc_keyToSide;

    if (_sectorId >= 0 && { _sectorId < _sectorCount } && { !(_ownerSide isEqualTo sideUnknown) }) then
    {
        _sectorOwner set [_sectorId, _ownerSide];
        if (_ownerSide in _playerSides) then
        {
            _captHash set [_sectorId, true];
            _saved pushBackUnique _sectorId;
        };
    };
} forEach _savedOwners;

{
    if (_x >= 0 && { _x < _sectorCount } && { (_sectorOwner param [_x, _sideEnemy]) isEqualTo _sideEnemy }) then
    {
        _sectorOwner set [_x, west];
        [_x, west] call _fnc_setSavedOwner;
    };
} forEach _saved;

call _fnc_seedBaseSectors;

if (_frontierCaptureOnly && { _frontierPruneDisconnectedSaves } && { !(missionNamespace getVariable ["DZ_frontierDisconnectedSavesPruned", false]) }) then
{
    missionNamespace setVariable ["DZ_frontierDisconnectedSavesPruned", true];

    for "_sectorId" from 0 to (_sectorCount - 1) do
    {
        private _ownerSide = _sectorOwner param [_sectorId, _sideEnemy];

        if (_ownerSide in _playerSides) then
        {
            if (!([_sectorId, _ownerSide] call _fnc_isConnectedToBase)) then
            {
                _sectorOwner set [_sectorId, _sideEnemy];
                _sectorDominance set [_sectorId, [sideUnknown, -1]];
                _captHash deleteAt _sectorId;

                private _savedIdx = _saved find _sectorId;
                if (_savedIdx >= 0) then
                {
                    _saved deleteAt _savedIdx;
                };

                [_sectorId, _sideEnemy] call _fnc_setSavedOwner;
                _capturesDirty = true;
            };
        };
    };
};

private _fnc_isUavVehicle =
{
    params ["_vehicle"];

    if (isNull _vehicle) exitWith { false };

    (getNumber (configOf _vehicle >> "isUav")) > 0
};

private _fnc_isIgnoredSectorVehicle =
{
    params ["_vehicle"];

    if (isNull _vehicle) exitWith { false };
    if (_vehicle isKindOf "Air") exitWith { true };

    [_vehicle] call _fnc_isUavVehicle
};

private _fnc_countAliveUnits =
{
    params ["_groups"];

    private _alive = 0;
    {
        _alive = _alive + ({ alive _x && { !([vehicle _x] call _fnc_isIgnoredSectorVehicle) } } count units _x);
    } forEach _groups;

    _alive
};

private _fnc_registerAssets =
{
    params ["_assets", "_sectorId", ["_role", "zone"]];

    private _groups = _assets param [0, []];
    private _vehicles = +(_assets param [1, []]);

    {
        private _grp = _x;

        if (!isNull _grp) then
        {
            _grp setVariable ["DZ_dynamicAsset", true];
            _grp setVariable ["DZ_dynamicSector", _sectorId];
            _grp setVariable ["DZ_dynamicRole", _role];

            {
                private _unit = _x;

                if (!isNull _unit) then
                {
                    _unit setVariable ["DZ_dynamicAsset", true];
                    _unit setVariable ["DZ_dynamicSector", _sectorId];
                    _unit setVariable ["DZ_dynamicRole", _role];
                };
            } forEach units _grp;

            _vehicles append ([_grp, true] call BIS_fnc_groupVehicles);
        };
    } forEach _groups;

    _vehicles = _vehicles arrayIntersect _vehicles;

    {
        if (!isNull _x) then
        {
            _x setVariable ["DZ_dynamicAsset", true];
            _x setVariable ["DZ_dynamicSector", _sectorId];
            _x setVariable ["DZ_dynamicRole", _role];
        };
    } forEach _vehicles;
};

private _fnc_deleteAssets =
{
    params ["_assets"];

    private _groups = _assets param [0, []];
    private _vehicles = +(_assets param [1, []]);

    {
        private _grp = _x;

        if (!isNull _grp) then
        {
            _vehicles append ([_grp, true] call BIS_fnc_groupVehicles);

            {
                if (!isNull _x) then
                {
                    deleteVehicle _x;
                };
            } forEach units _grp;

            deleteGroup _grp;
        };
    } forEach _groups;

    _vehicles = _vehicles arrayIntersect _vehicles;

    {
        private _veh = _x;

        if (!isNull _veh) then
        {
            private _storageRadius = missionNamespace getVariable ["DZ_trophyVehicleStorageRadius", 20];
            private _storagePadNames = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
            private _nearTrophyDelivery = false;
            private _hasPlayerCrew = ({ isPlayer _x } count (crew _veh)) > 0;

            {
                private _storagePad = missionNamespace getVariable [_x, objNull];
                if (!isNull _storagePad && { (_veh distance2D _storagePad) <= _storageRadius }) then {
                    _nearTrophyDelivery = true;
                };
            } forEach _storagePadNames;

            if (_veh getVariable ["DZ_trophyVehicle", false]) then
            {
                continue;
            };
            if (_nearTrophyDelivery) then
            {
                continue;
            };
            if (_hasPlayerCrew) then
            {
                continue;
            };

            {
                if (!isNull _x) then
                {
                    deleteVehicle _x;
                };
            } forEach crew _veh;

            deleteVehicle _veh;
        };
    } forEach _vehicles;
};

private _fnc_blockSpawnAround =
{
    params ["_sectorId"];

    private _blockUntil = _now + _recaptureSpawnCooldown;
    private _blockedSectors = [_sectorId] + (_sectorAdjacency param [_sectorId, []]);

    {
        private _currentBlock = _spawnBlockedUntil param [_x, 0];
        _spawnBlockedUntil set [_x, _currentBlock max _blockUntil];
    } forEach _blockedSectors;
};

private _activePlayers = allPlayers select
{
    alive _x && { !([vehicle _x] call _fnc_isIgnoredSectorVehicle) }
};

private _playerPositions = _activePlayers apply { getPosATL (vehicle _x) };

private _sectorCounts = [];
_sectorCounts resize _sectorCount;

for "_idx" from 0 to (_sectorCount - 1) do
{
    _sectorCounts set [_idx, [0, 0, 0]];
};

{
    private _unit = _x;

    if (!alive _unit) then
    {
        continue;
    };

    private _vehicle = vehicle _unit;
    if ([_vehicle] call _fnc_isIgnoredSectorVehicle) then
    {
        continue;
    };

    private _unitSide = side group _unit;
    if (!(_unitSide in _playerSides) && { !(_unitSide isEqualTo _sideEnemy) }) then
    {
        continue;
    };

    private _pos = getPosATL _vehicle;
    private _sectorId = _sectorLookup getOrDefault [format ["%1_%2", floor ((_pos # 0) / _gridSize), floor ((_pos # 1) / _gridSize)], -1];

    if (_sectorId < 0 || { _sectorId >= _sectorCount }) then
    {
        continue;
    };

    private _candidateSectors = [_sectorId] + (_sectorAdjacency param [_sectorId, []]);
    _candidateSectors = _candidateSectors arrayIntersect _candidateSectors;

    {
        private _candidateId = _x;
        private _candidateCenter = _cells param [_candidateId, []];

        if (_candidateCenter isEqualTo []) then
        {
            continue;
        };

        if ((_pos distance2D _candidateCenter) > _sectorInfluenceRadius) then
        {
            continue;
        };

        private _counts = +(_sectorCounts # _candidateId);
        _counts params ["_westCount", "_resistanceCount", "_eastCount"];

        switch (true) do
        {
            case (_unitSide isEqualTo west):
            {
                _sectorCounts set [_candidateId, [_westCount + 1, _resistanceCount, _eastCount]];
            };
            case (_unitSide isEqualTo resistance):
            {
                _sectorCounts set [_candidateId, [_westCount, _resistanceCount + 1, _eastCount]];
            };
            case (_unitSide isEqualTo _sideEnemy):
            {
                _sectorCounts set [_candidateId, [_westCount, _resistanceCount, _eastCount + 1]];
            };
        };
    } forEach _candidateSectors;
} forEach allUnits;

for "_idx" from 0 to (_sectorCount - 1) do
{
    private _center = _cells # _idx;
    private _isUrban = _idx in _urbanHash;
    private _savedCap = _idx in _captHash;
    private _state = +(_zoneData param [_idx, _zoneTemplate]);

    _state params
    [
        "_spawned",
        "_assets",
        "_lastOut",
        "_total",
        "_captured",
        "_lastSp",
        "_preDone",
        "_counterActive",
        "_counterStart",
        "_ctrLog"
    ];

    if (_savedCap && { !_captured }) then
    {
        if ((_sectorOwner param [_idx, _sideEnemy]) isEqualTo _sideEnemy) then
        {
            _sectorOwner set [_idx, west];
            [_idx, west] call _fnc_setSavedOwner;
        };

        _preDone = true;
    };

    private _ownerSide = _sectorOwner param [_idx, _sideEnemy];
    _captured = _ownerSide in _playerSides;

    private _distMin = _eps * 10;

    {
        private _distance = _center distance2D _x;
        if (_distance < _distMin) then
        {
            _distMin = _distance;
        };
    } forEach _playerPositions;

    private _inPre = _distMin <= _preR;
    private _spawnBlocked = (_spawnBlockedUntil param [_idx, 0]) > _now;
    private _counts = _sectorCounts # _idx;
    _counts params ["_westCount", "_resistanceCount", "_eastCount"];

    private _dominantSide = [_counts] call _fnc_dominantSide;
    private _sectorCenter = _cells # _idx;
    private _playerCaptureSide = sideUnknown;
    private _ownerNearForCapture = false;

    {
        private _unitSide = side group _x;
        private _unitVehicle = vehicle _x;

        if (!alive _x || { [_unitVehicle] call _fnc_isIgnoredSectorVehicle }) then
        {
            continue;
        };

        if (((getPosATL _unitVehicle) distance2D _sectorCenter) > _sectorInfluenceRadius) then
        {
            continue;
        };

        if (_unitSide isEqualTo _ownerSide) then
        {
            _ownerNearForCapture = true;
        };

        if (_unitSide in _playerSides && { !(_unitSide isEqualTo _ownerSide) }) then
        {
            if (_playerCaptureSide isEqualTo sideUnknown) then
            {
                _playerCaptureSide = _unitSide;
            }
            else
            {
                if (!(_playerCaptureSide isEqualTo _unitSide)) then
                {
                    _playerCaptureSide = sideUnknown;
                    _ownerNearForCapture = true;
                };
            };
        };
    } forEach _activePlayers;

    if (!_ownerNearForCapture && { !(_playerCaptureSide isEqualTo sideUnknown) } && { [_idx, _playerCaptureSide, _ownerSide] call _fnc_canCaptureByFrontier }) then
    {
        _dominantSide = _playerCaptureSide;
    };

    if (!([_idx, _dominantSide, _ownerSide] call _fnc_canCaptureByFrontier)) then
    {
        _dominantSide = sideUnknown;
    };

    private _dominanceState = +(_sectorDominance param [_idx, [sideUnknown, -1]]);
    _dominanceState params [["_lastDominantSide", sideUnknown], ["_holdStart", -1]];

    if (_dominantSide isEqualTo sideUnknown) then
    {
        _dominanceState = [sideUnknown, -1];
    }
    else
    {
        if (!(_dominantSide isEqualTo _lastDominantSide) || { _holdStart < 0 }) then
        {
            _dominanceState = [_dominantSide, _now];
        };
    };

    _sectorDominance set [_idx, _dominanceState];
    _dominanceState params ["_activeDominantSide", "_activeHoldStart"];

    if (!(_activeDominantSide isEqualTo sideUnknown) && { _activeHoldStart >= 0 } && { _now - _activeHoldStart >= _captureHold }) then
    {
        if (!(_activeDominantSide isEqualTo _ownerSide)) then
        {
            _ownerSide = _activeDominantSide;
            _captured = _ownerSide in _playerSides;
            _spawned = false;
            _counterActive = false;
            _counterStart = -1;
            _lastOut = -1;
            _preDone = true;
            _ctrLog = -1;

            _sectorOwner set [_idx, _ownerSide];
            _firstCounterDone set [_idx, false];
            _nextCounterAt set [_idx, 0];
            _capturesDirty = true;

            if (_captured) then
            {
                _captHash set [_idx, true];
                _saved pushBackUnique _idx;
                [_idx, _ownerSide] call _fnc_setSavedOwner;
            }
            else
            {
                _preDone = false;

                if (_idx in _saved) then
                {
                    _saved deleteAt (_saved find _idx);
                };

                if (_idx in _captHash) then
                {
                    _captHash deleteAt _idx;
                };

                [_idx, _ownerSide] call _fnc_setSavedOwner;
            };

            [_idx] call _fnc_blockSpawnAround;
            diag_log format
            [
                "[DZ:%1] Sector owner changed to %2 by dominance (west=%3, resistance=%4, east=%5)",
                _idx,
                _ownerSide,
                _westCount,
                _resistanceCount,
                _eastCount
            ];
        };
    };

    if (_counterActive) then
    {
        if (_ctrLog < 0 || { _now - _ctrLog >= 5 }) then
        {
            private _aliveDebug = [_assets # 0] call _fnc_countAliveUnits;
            diag_log format ["[DZ:%1] Counter tick: alive=%2", _idx, _aliveDebug];
            _ctrLog = _now;
        };

        if (([_assets # 0] call _fnc_countAliveUnits) == 0) then
        {
            _spawned = false;
            _counterActive = false;
            _counterStart = -1;
            _lastOut = -1;
            _assets = [[], []];
            _total = 0;
            _ctrLog = -1;
            _nextCounterAt set [_idx, _now + _counterRepeatCooldown];
            _nextGlobalCounterAt = _now + _counterGlobalCooldown;

            diag_log format ["[DZ:%1] Counterattack ended: no alive BLUFOR units", _idx];
        };
    };

    if (_spawned && { _lastSp >= 0 } && { _now - _lastSp >= 3 } && { ([_assets # 0] call _fnc_countAliveUnits) == 0 }) then
    {
        _spawned = false;
        _counterActive = false;
        _counterStart = -1;
        _lastOut = -1;
        _total = 0;
        _ctrLog = -1;

        diag_log format ["[DZ:%1] Spawn package inactive: no alive BLUFOR units", _idx];
    };

    if (!_captured && { !_spawned } && { !_spawnBlocked }) then
    {


        private _inSafeZone = false;
        if ((markerType "base_safe_zone") != "") then
        {
            private _safeCenter = getMarkerPos "base_safe_zone";
            private _safeSize = getMarkerSize "base_safe_zone";
            private _safeShape = markerShape "base_safe_zone";
            private _safeDir = markerDir "base_safe_zone";

            private _sizeA = _safeSize # 0;
            private _sizeB = _safeSize # 1;

            if (_safeShape == "RECTANGLE") then
            {

                private _dx = (_center # 0) - (_safeCenter # 0);
                private _dy = (_center # 1) - (_safeCenter # 1);

                private _localX = (_dx * cos _safeDir) - (_dy * sin _safeDir);
                private _localY = (_dx * sin _safeDir) + (_dy * cos _safeDir);
                if (abs _localX <= _sizeA && { abs _localY <= _sizeB }) then
                {
                    _inSafeZone = true;
                };
            }
            else
            {

                private _safeRadius = _sizeA max _sizeB;
                if (_center distance2D _safeCenter <= _safeRadius) then
                {
                    _inSafeZone = true;
                };
            };
        };

        if (!_inSafeZone) then {
        if (!_isUrban && _inPre && { (random 1) < _cpChance }) then
        {
            private _spawnResult = [_center] call DZ_fnc_spawnCheckpoint;
            private _spawnGroups = _spawnResult # 0;
            private _spawnVehicles = _spawnResult # 1;

            if (_spawnGroups isNotEqualTo [] || { _spawnVehicles isNotEqualTo [] }) then
            {
                _assets = [_spawnGroups, _spawnVehicles];
                _total = _spawnResult # 2;
                _spawned = true;
                _lastSp = _now;
                _preDone = true;
                _lastOut = -1;

                [_assets, _idx, "checkpoint"] call _fnc_registerAssets;
                diag_log format ["[DZ:%1] Enemy checkpoint activated (%2 units)", _idx, _total];
            };
        };

        if (_isUrban && !_preDone && _inPre && { _lastSp < 0 || { _now - _lastSp >= _spawnRetryCooldown } }) then
        {
            _lastSp = _now;

            private _spawnResult = [_center, 0] call DZ_fnc_spawnForZone;
            private _spawnGroups = _spawnResult # 0;
            private _spawnVehicles = _spawnResult # 1;

            if (_spawnGroups isNotEqualTo [] || { _spawnVehicles isNotEqualTo [] }) then
            {
                _assets = [_spawnGroups, _spawnVehicles];
                _total = _spawnResult # 2;
                _spawned = true;
                _lastSp = _now;
                _preDone = true;
                _lastOut = -1;

                [_assets, _idx, "sector"] call _fnc_registerAssets;
                diag_log format ["[DZ:%1] Enemy urban sector activated (%2 units)", _idx, _total];
            };
        };
        };
    };

    if (_enableLiveDespawn && { _spawned } && { !_inPre } && { !_counterActive }) then
    {
        if (_lastOut < 0) then
        {
            _lastOut = _now;
        }
        else
        {
            if (_now - _lastOut >= _delayCleanup) then
            {
                [_assets] call _fnc_deleteAssets;

                _spawned = false;
                _assets = [[], []];
                _lastOut = -1;
                _lastSp = -1;
                _preDone = false;
                _total = 0;
                _ctrLog = -1;

                diag_log format ["[DZ:%1] Enemy sector live-despawned", _idx];
            };
        };
    }
    else
    {
        if (_spawned && _inPre) then
        {
            _lastOut = -1;
        };
    };

    _zoneData set
    [
        _idx,
        [_spawned, _assets, _lastOut, _total, _captured, _lastSp, _preDone, _counterActive, _counterStart, _ctrLog]
    ];
};

private _playerOwned = [];
_playerOwned resize _sectorCount;

for "_idx" from 0 to (_sectorCount - 1) do
{
    private _state = _zoneData param [_idx, _zoneTemplate];
    _playerOwned set [_idx, (_state # 4) || { _idx in _captHash }];
};

private _activeCounters = 0;
{
    if ((_x param [7, false])) then
    {
        _activeCounters = _activeCounters + 1;
    };
} forEach _zoneData;

private _counterCandidates = [];

if (_counterEnabled && { _now >= _nextGlobalCounterAt }) then
{
    for "_idx" from 0 to (_sectorCount - 1) do
    {
        private _state = _zoneData param [_idx, _zoneTemplate];
        _state params
        [
            "_spawned",
            "_assets",
            "_lastOut",
            "_total",
            "_captured",
            "_lastSp",
            "_preDone",
            "_counterActive",
            "_counterStart",
            "_ctrLog"
        ];

        if (!_captured || { _spawned } || { _counterActive }) then
        {
            continue;
        };


        if ((markerType "base_safe_zone") != "") then
        {
            private _safeCenter = getMarkerPos "base_safe_zone";
            private _safeSize = getMarkerSize "base_safe_zone";
            private _safeShape = markerShape "base_safe_zone";
            private _safeDir = markerDir "base_safe_zone";
            private _cellPos = _cells param [_idx, [0,0,0]];
            private _sizeA = _safeSize # 0;
            private _sizeB = _safeSize # 1;
            private _inSafe = false;

            if (_safeShape == "RECTANGLE") then
            {
                private _dx = (_cellPos # 0) - (_safeCenter # 0);
                private _dy = (_cellPos # 1) - (_safeCenter # 1);
                private _localX = (_dx * cos _safeDir) - (_dy * sin _safeDir);
                private _localY = (_dx * sin _safeDir) + (_dy * cos _safeDir);
                if (abs _localX <= _sizeA && { abs _localY <= _sizeB }) then
                {
                    _inSafe = true;
                };
            }
            else
            {
                private _safeRadius = _sizeA max _sizeB;
                if (_cellPos distance2D _safeCenter <= _safeRadius) then
                {
                    _inSafe = true;
                };
            };

            if (_inSafe) then
            {
                continue;
            };
        };

        if ((_spawnBlockedUntil param [_idx, 0]) > _now) then
        {
            continue;
        };

        private _neighbors = _sectorAdjacency param [_idx, []];
        private _enemyNeighbors = 0;
        private _enemySpawnNeighbors = [];
        private _surrounded = (count _neighbors) > 0;

        {
            if (_playerOwned param [_x, false]) then
            {
                _surrounded = false;
            }
            else
            {
                _enemyNeighbors = _enemyNeighbors + 1;

                if ((_spawnBlockedUntil param [_x, 0]) <= _now) then
                {
                    _enemySpawnNeighbors pushBack _x;
                };
            };
        } forEach _neighbors;

        if (_enemyNeighbors < _frontMinEnemyNeighbors) then
        {
            continue;
        };

        if (_enemySpawnNeighbors isEqualTo []) then
        {
            continue;
        };

        private _firstDone = _firstCounterDone param [_idx, false];
        private _nextAllowed = _nextCounterAt param [_idx, 0];
        private _eligible = false;

        if (_now >= _nextAllowed) then
        {
            private _counterChance = if (_firstDone) then { _counterRepeatChance } else { _counterFirstChance };

            if ((random 1) < _counterChance) then
            {
                _eligible = true;
            }
            else
            {
                _firstCounterDone set [_idx, true];
                _nextCounterAt set [_idx, _now + _counterRepeatCooldown];
            };
        };

        if (_eligible) then
        {
            private _priority = if (_surrounded) then { 0 } else { 1 };
            private _spawnSectorId = selectRandom _enemySpawnNeighbors;
            _counterCandidates pushBack [_priority, -_enemyNeighbors, _idx, _spawnSectorId];
        };
    };
};

_counterCandidates sort true;

{
    if (_activeCounters >= _counterMaxActive) exitWith {};
    if (_now < _nextGlobalCounterAt) exitWith {};

    _x params ["_priority", "_negEnemyNeighbors", "_idx", "_spawnSectorId"];

    private _state = +(_zoneData param [_idx, _zoneTemplate]);
    _state params
    [
        "_spawned",
        "_assets",
        "_lastOut",
        "_total",
        "_captured",
        "_lastSp",
        "_preDone",
        "_counterActive",
        "_counterStart",
        "_ctrLog"
    ];

    if (!_captured || { _spawned } || { _counterActive }) then
    {
        continue;
    };


    if ((markerType "base_safe_zone") != "") then
    {
        private _safeCenter = getMarkerPos "base_safe_zone";
        private _safeSize = getMarkerSize "base_safe_zone";
        private _safeShape = markerShape "base_safe_zone";
        private _safeDir = markerDir "base_safe_zone";
        private _cellPos = _cells param [_idx, [0,0,0]];
        private _sizeA = _safeSize # 0;
        private _sizeB = _safeSize # 1;
        private _inSafe = false;

        if (_safeShape == "RECTANGLE") then
        {
            private _dx = (_cellPos # 0) - (_safeCenter # 0);
            private _dy = (_cellPos # 1) - (_safeCenter # 1);
            private _localX = (_dx * cos _safeDir) - (_dy * sin _safeDir);
            private _localY = (_dx * sin _safeDir) + (_dy * cos _safeDir);
            if (abs _localX <= _sizeA && { abs _localY <= _sizeB }) then
            {
                _inSafe = true;
            };
        }
        else
        {
            private _safeRadius = _sizeA max _sizeB;
            if (_cellPos distance2D _safeCenter <= _safeRadius) then
            {
                _inSafe = true;
            };
        };

        if (_inSafe) then
        {
            continue;
        };
    };

    if ((_playerOwned param [_spawnSectorId, true]) || { (_spawnBlockedUntil param [_spawnSectorId, 0]) > _now }) then
    {
        _nextCounterAt set [_idx, _now + _counterRepeatCooldown];
        continue;
    };

    private _center = _cells # _idx;
    private _spawnCenter = _cells # _spawnSectorId;
    private _isUrban = _idx in _urbanHash;
    private _counterTaskKey = if (_isUrban) then { "counterattack_urban" } else { "counterattack_open" };
    private _counterSpawn = [_center, _counterTaskKey, _spawnCenter] call DZ_fnc_spawnCounterattackForce;
    private _counterGroups = _counterSpawn # 0;
    private _counterVehicles = _counterSpawn # 1;

    if (_counterGroups isNotEqualTo [] || { _counterVehicles isNotEqualTo [] }) then
    {
        _assets = [_counterGroups, _counterVehicles];
        _total = _counterSpawn # 2;
        _spawned = true;
        _counterActive = true;
        _counterStart = -1;
        _lastSp = _now;
        _lastOut = -1;
        _ctrLog = -1;

        _firstCounterDone set [_idx, true];
        _nextCounterAt set [_idx, _now + _counterRepeatCooldown];
        _nextGlobalCounterAt = _now + _counterGlobalCooldown;
        _activeCounters = _activeCounters + 1;

        [_assets, _idx, "counterattack"] call _fnc_registerAssets;
        diag_log format
        [
            "[DZ:%1] Counterattack started (%2 units, enemyNeighbors=%3, surrounded=%4, spawnSector=%5)",
            _idx,
            _total,
            abs _negEnemyNeighbors,
            _priority == 0,
            _spawnSectorId
        ];
    }
    else
    {
        _nextCounterAt set [_idx, _now + _counterRepeatCooldown];
        _nextGlobalCounterAt = _now + _counterGlobalCooldown;
        diag_log format ["[DZ:%1] Counterattack spawn failed; retry delayed", _idx];
    };

    _zoneData set
    [
        _idx,
        [_spawned, _assets, _lastOut, _total, _captured, _lastSp, _preDone, _counterActive, _counterStart, _ctrLog]
    ];
} forEach _counterCandidates;

for "_idx" from 0 to (_sectorCount - 1) do
{
    private _state = _zoneData param [_idx, _zoneTemplate];
    private _counts = _sectorCounts param [_idx, [0, 0, 0]];

    _counts params ["_westCount", "_resistanceCount", "_eastCount"];

    private _counterActive = _state param [7, false];
    private _ownerSide = _sectorOwner param [_idx, _sideEnemy];
    private _dominantSide = [_counts] call _fnc_dominantSide;

    if (!([_idx, _dominantSide, _ownerSide] call _fnc_canCaptureByFrontier)) then
    {
        _dominantSide = sideUnknown;
    };

    private _ownerCount = switch (true) do
    {
        case (_ownerSide isEqualTo west): { _westCount };
        case (_ownerSide isEqualTo resistance): { _resistanceCount };
        case (_ownerSide isEqualTo _sideEnemy): { _eastCount };
        default { 0 };
    };

    private _attackerCount = switch (true) do
    {
        case (_ownerSide isEqualTo west): { _resistanceCount + _eastCount };
        case (_ownerSide isEqualTo resistance): { _westCount + _eastCount };
        case (_ownerSide isEqualTo _sideEnemy): { _westCount + _resistanceCount };
        default { _westCount + _resistanceCount + _eastCount };
    };

    private _activeSideCount = 0;

    {
        if (_x > 0) then
        {
            _activeSideCount = _activeSideCount + 1;
        };
    } forEach [_westCount, _resistanceCount, _eastCount];

    private _playerAttackerNear = false;
    private _ownerNear = false;
    private _sectorCenter = _cells # _idx;

    {
        private _unitSide = side group _x;
        private _unitVehicle = vehicle _x;

        if (!alive _x || { [_unitVehicle] call _fnc_isIgnoredSectorVehicle }) then
        {
            continue;
        };

        if (((getPosATL _unitVehicle) distance2D _sectorCenter) > _sectorInfluenceRadius) then
        {
            continue;
        };

        if (_unitSide isEqualTo _ownerSide) then
        {
            _ownerNear = true;
        };

        if (!(_unitSide isEqualTo _ownerSide) && { _unitSide in _playerSides }) then
        {
            _playerAttackerNear = true;
        };
    } forEach allUnits;

    private _styleId = [_ownerSide] call _fnc_ownerStyle;

    if (_counterActive) then
    {
        _styleId = _styleContested;
    }
    else
    {
        if ((_attackerCount > 0 && { _ownerCount == 0 }) || { _playerAttackerNear && { !_ownerNear } }) then
        {
            _styleId = _styleContested;
        }
        else
        {
            if (_activeSideCount > 1) then
            {
                _styleId = _styleContested;
            }
            else
            {
                if (!(_dominantSide isEqualTo sideUnknown) && { !(_dominantSide isEqualTo _ownerSide) }) then
                {
                    _styleId = _styleContested;
                };
            };
        };
    };

    [_idx, _styleId] call DZ_fnc_setSectorVisualState;
};

missionNamespace setVariable ["DZ_zoneData", _zoneData];
missionNamespace setVariable ["DZ_sectorDominance", _sectorDominance];
missionNamespace setVariable ["DZ_sectorOwner", _sectorOwner];
missionNamespace setVariable ["DZ_spawnBlockedUntil", _spawnBlockedUntil];
missionNamespace setVariable ["DZ_firstCounterDone", _firstCounterDone];
missionNamespace setVariable ["DZ_nextCounterAt", _nextCounterAt];
missionNamespace setVariable ["DZ_nextGlobalCounterAt", _nextGlobalCounterAt];
missionNamespace setVariable ["DZ_savedCapturesCache", _saved];
missionNamespace setVariable ["DZ_savedSectorOwners", _savedOwners];
missionNamespace setVariable ["DZ_capturedHash", _captHash];

if (_capturesDirty) then
{
    profileNamespace setVariable ["DZ_savedCaptures", _saved];
    profileNamespace setVariable ["DZ_savedSectorOwners", _savedOwners];
    saveProfileNamespace;
};

call DZ_fnc_publishSectorState;
