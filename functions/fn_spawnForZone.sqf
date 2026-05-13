/*
 * Spawns an urban sector package using custom squad arrays, mech packages, and vehicle pools.
 * Returns: [groupsArr, vehiclesArr, totalUnits]
 */

params ["_center", "_pCount"];

private _eps = missionNamespace getVariable ["DZ_eps", 300];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy", west];
private _groupRoot = missionNamespace getVariable ["DZ_enemyGroupRoot", configNull];
private _vehicleLocalRadius = missionNamespace getVariable ["DZ_vehicleCategoryLocalRadius", _eps * 2];
private _maxPosAttempts = 20;

private _buildingPool = nearestObjects [_center, ["House"], _eps - 40, true]
                      select
                      {
                          (count (_x buildingPos -1)) > 0 &&
                          { ({ !([_x] call DZ_fnc_isForbiddenSpawnPos) } count (_x buildingPos -1)) > 0 }
                      };
private _buildingCount = count _buildingPool;
private _taskKey = if (_buildingCount >= 10) then { "urban_dense" } else { "urban_sparse" };
private _spawnProfile = [_taskKey] call DZ_fnc_selectSpawnProfile;
private _groupDefs = _spawnProfile # 0;
private _packageDefs = _spawnProfile # 1;
private _vehicleDefs = _spawnProfile # 2;

if (_groupDefs isEqualTo [] && { _packageDefs isEqualTo [] } && { _vehicleDefs isEqualTo [] }) exitWith
{
    [[], [], 0]
};

private _maxAttempts = 15;
private _takenPos = [];

private _normalizePos =
{
    params ["_pos"];

    if !(_pos isEqualType []) exitWith { [] };
    if ((count _pos) < 2) exitWith { [] };

    private _result = +_pos;

    if ((count _result) < 3) then
    {
        _result pushBack (getTerrainHeightASL _result);
        _result = ASLToATL _result;
    };

    _result
};

private _pickPosInf =
{
    params ["_ref"];

    private _result = [];
    private _attempt = 0;

    while { _attempt < _maxPosAttempts && { _result isEqualTo [] } } do
    {
        private _candidate = [];

        if (_buildingPool isNotEqualTo []) then
        {
            private _house = selectRandom _buildingPool;
            private _points = (_house buildingPos -1) select { !([_x] call DZ_fnc_isForbiddenSpawnPos) };

            if (_points isNotEqualTo []) then
            {
                _candidate = selectRandom _points;
            };
        };

        if (_candidate isEqualTo []) then
        {
            _candidate = [_ref, 0, _eps - 40, 10, 0, 0.3, 0, [], [_ref, _eps * 0.5]] call BIS_fnc_findSafePos;
        };

        _candidate = [_candidate] call _normalizePos;

        if (_candidate isNotEqualTo [] && { !([_candidate] call DZ_fnc_isForbiddenSpawnPos) }) then
        {
            _result = _candidate;
        };

        _attempt = _attempt + 1;
    };

    _result
};

private _candidateVehPos =
{
    params ["_ref", "_vehType"];

    private _result = [];

    private _roadObj = [_ref, _eps - 40] call BIS_fnc_nearestRoad;
    if (!isNull _roadObj) then
    {
        private _p = getPosATL _roadObj;
        _p = [_p] call _normalizePos;

        if (
            _p isNotEqualTo [] &&
            { !([_p] call DZ_fnc_isForbiddenSpawnPos) } &&
            { (nearestObjects [_p, ["Building", "Wall", "Fence", "House", "Thing"], 8]) isEqualTo [] }
        ) exitWith
        {
            _result = _p;
        };
    };

    if (_result isNotEqualTo []) exitWith { _result };

    private _p = [_ref findEmptyPosition [20, _eps, _vehType]] call _normalizePos;
    if (_p isNotEqualTo [] && { !([_p] call DZ_fnc_isForbiddenSpawnPos) }) exitWith
    {
        _p
    };

    private _attempt = 0;

    while { _attempt < _maxPosAttempts && { _result isEqualTo [] } } do
    {
        _p = [[_ref, 0, _eps - 40, 20, 0, 0.1, 0, [], [_ref, _eps * 0.5]] call BIS_fnc_findSafePos] call _normalizePos;

        if (_p isNotEqualTo [] && { !([_p] call DZ_fnc_isForbiddenSpawnPos) }) then
        {
            _result = _p;
        };

        _attempt = _attempt + 1;
    };

    _result
};

private _spawnGroupDef =
{
    params ["_groupDef"];

    private _resolvedGroupDef = [_groupDef] call DZ_fnc_resolveSpawnGroupDef;

    if (_resolvedGroupDef isEqualType configNull) exitWith
    {
        if !(isClass _resolvedGroupDef) exitWith
        {
            diag_log format ["[DZ] Missing direct config group for %1", _taskKey];
            grpNull
        };

        private _spawnPos = [_center] call _pickPosInf;
        if (_spawnPos isEqualTo []) exitWith { grpNull };
        private _grp = [_spawnPos, _sideEnemy, _resolvedGroupDef] call BIS_fnc_spawnGroup;
        if (isNull _grp) exitWith { grpNull };
        { [_x] call DZ_fnc_prepareSpawnedUnit; } forEach units _grp;
        _grp
    };

    if (_resolvedGroupDef isEqualType "") exitWith
    {
        if (_groupRoot isEqualTo configNull) exitWith { grpNull };

        private _cfg = _groupRoot >> _resolvedGroupDef;
        if !(isClass _cfg) exitWith
        {
            diag_log format ["[DZ] Missing config group %1 for %2", _resolvedGroupDef, _taskKey];
            grpNull
        };

        private _spawnPos = [_center] call _pickPosInf;
        if (_spawnPos isEqualTo []) exitWith { grpNull };
        private _grp = [_spawnPos, _sideEnemy, _cfg] call BIS_fnc_spawnGroup;
        if (isNull _grp) exitWith { grpNull };
        { [_x] call DZ_fnc_prepareSpawnedUnit; } forEach units _grp;
        _grp
    };

    if (_resolvedGroupDef isEqualType []) exitWith
    {
        if (_resolvedGroupDef isEqualTo []) exitWith { grpNull };

        private _grp = createGroup _sideEnemy;

        {
            private _unitPos = [_center] call _pickPosInf;
            if (_unitPos isEqualTo []) then
            {
                continue;
            };

            private _unit = _grp createUnit [_x, _unitPos, [], 0, "CAN_COLLIDE"];
            [_unit] call DZ_fnc_prepareSpawnedUnit;
            _unit setPosATL _unitPos;
            _unit setDir (random 360);
        } forEach _resolvedGroupDef;

        if ((units _grp) isEqualTo []) exitWith
        {
            deleteGroup _grp;
            grpNull
        };

        _grp
    };

    grpNull
};

private _assignVehicleCrew =
{
    params ["_veh", "_sourceGroups", ["_allowCargo", false]];

    private _free = [];
    {
        _free append ((units _x) select { alive _x && { isNull objectParent _x } });
    } forEach _sourceGroups;

    private _vacancies = fullCrew [_veh, "", true] select { (_x # 0) isEqualTo objNull };

    {
        if (_forEachIndex < count _free) then
        {
            private _man = _free select _forEachIndex;
            private _role = _x # 1;

            switch _role do
            {
                case "driver":
                {
                    _man assignAsDriver _veh;
                    _man moveInDriver _veh;
                };
                case "gunner":
                {
                    _man assignAsGunner _veh;
                    _man moveInGunner _veh;
                };
                case "commander":
                {
                    _man assignAsCommander _veh;
                    _man moveInCommander _veh;
                };
                case "turret":
                {
                    _man moveInTurret [_veh, _x # 3];
                };
                default
                {
                    _man moveInAny _veh;
                };
            };

            if (!isNull objectParent _man) then
            {
                _free set [_forEachIndex, objNull];
            };
        };
    } forEach _vacancies;

    if (_allowCargo) then
    {
        private _cargoUnits = _free select { alive _x && { isNull objectParent _x } };
        private _cargoSlots = fullCrew [_veh, "cargo", true] select { (_x # 0) isEqualTo objNull };

        {
            if (_forEachIndex < count _cargoUnits) then
            {
                private _man = _cargoUnits select _forEachIndex;
                _man assignAsCargo _veh;
                _man moveInCargo _veh;
            };
        } forEach _cargoSlots;
    };

    { !isNull _x } count crew _veh
};

private _spawnVehicleForGroups =
{
    params ["_vehType", "_sourceGroups", ["_allowCargo", false]];

    if !([_vehType, _center, _vehicleLocalRadius, _vehs] call DZ_fnc_canSpawnVehicleType) exitWith { objNull };

    private _pos = [];
    private _tries = 0;
    private _unique = false;

    while { !_unique && _tries < _maxAttempts } do
    {
        _pos = [_center, _vehType] call _candidateVehPos;
        _tries = _tries + 1;
        if (_pos isEqualTo []) then
        {
            continue;
        };

        _unique = true;
        {
            if (_pos distance2D _x < 1) exitWith
            {
                _unique = false;
            };
        } forEach _takenPos;
    };

    if (!_unique) exitWith
    {
        diag_log format ["[DZ] spawnForZone: skipped duplicate vehicle position for %1", _vehType];
        objNull
    };

    private _veh = createVehicle [_vehType, _pos, [], 0, "NONE"];
    _veh setDir (random 360);
    _takenPos pushBack _pos;

    private _assignedCrew = [_veh, _sourceGroups, _allowCargo] call _assignVehicleCrew;
    if (_assignedCrew <= 0 || { isNull driver _veh }) exitWith
    {
        {
            deleteVehicle _x;
        } forEach crew _veh;

        deleteVehicle _veh;
        objNull
    };

    private _vehicleGroup = group driver _veh;
    if (!isNull _vehicleGroup) then
    {
        [_vehicleGroup, _center, _eps] call BIS_fnc_taskPatrol;
    };

    _veh
};

private _groups = [];
private _vehs = [];
private _total = 0;

{
    private _grp = [_x] call _spawnGroupDef;
    if (isNull _grp) then
    {
        continue;
    };

    {
        if (isNull objectParent _x) then
        {
            private _unitPos = [_center] call _pickPosInf;
            if (_unitPos isNotEqualTo []) then
            {
                _x setPosATL _unitPos;
                _x setDir (random 360);
            };
        };
    } forEach units _grp;

    _grp setCombatMode "RED";
    _grp setSpeedMode "LIMITED";
    [_grp, _center, _eps] call BIS_fnc_taskDefend;

    _groups pushBack _grp;
    _total = _total + count units _grp;
} forEach _groupDefs;

{
    _x params [["_packageUnits", []], ["_vehicleType", ""]];

    private _grp = [_packageUnits] call _spawnGroupDef;
    if (isNull _grp) then
    {
        continue;
    };

    {
        if (isNull objectParent _x) then
        {
            private _unitPos = [_center] call _pickPosInf;
            if (_unitPos isNotEqualTo []) then
            {
                _x setPosATL _unitPos;
                _x setDir (random 360);
            };
        };
    } forEach units _grp;

    _grp setCombatMode "RED";
    _grp setSpeedMode "LIMITED";
    [_grp, _center, _eps] call BIS_fnc_taskDefend;

    _groups pushBack _grp;
    _total = _total + count units _grp;

    if !(_vehicleType isEqualTo "") then
    {
        private _veh = [_vehicleType, [_grp], false] call _spawnVehicleForGroups;
        if (!isNull _veh) then
        {
            _vehs pushBack _veh;
        };
    };
} forEach _packageDefs;

{
    if !(_x isEqualType "") then
    {
        continue;
    };

    private _veh = [_x, _groups, false] call _spawnVehicleForGroups;
    if (!isNull _veh) then
    {
        _vehs pushBack _veh;
    };
} forEach _vehicleDefs;

[_groups, _vehs, _total]
