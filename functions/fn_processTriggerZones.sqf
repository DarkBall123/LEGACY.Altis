/*
 * DZ_fnc_processTriggerZones
 * Reads editor trigger zones and applies sector ownership or restrictions.
 */

private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _urbanHash = missionNamespace getVariable ["DZ_urbanHash", createHashMap];
private _zoneTemplate = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _styleEnemyDormant = missionNamespace getVariable ["DZ_styleEnemyDormant", 0];
private _stylePlayerOwned = missionNamespace getVariable ["DZ_stylePlayerOwned", 2];
private _styleEastOwned = missionNamespace getVariable ["DZ_styleEastOwned", _styleEnemyDormant];
private _maxSectorId = (count _sectorGrid) - 1;
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy", east];
private _sectorOwner = missionNamespace getVariable ["DZ_sectorOwner", []];
private _savedOwners = ["DZ_savedSectorOwners", []] call DZ_fnc_storeGet;

private _saved = ["DZ_savedCaptures", []] call DZ_fnc_storeGet;
private _forbiddenSpawnAreas = [];
private _playerAreaTriggers = 0;
private _enemyAreaTriggers = 0;
private _playerAreaSectors = 0;
private _enemyAreaSectors = 0;

private _fnc_hasTriggerZoneFlag =
{
    params ["_trigger", "_flagName"];

    private _directValue = _trigger getVariable [_flagName, false];
    if (_directValue isEqualType true && { _directValue }) exitWith { true };

    private _statements = triggerStatements _trigger;
    if !(_statements isEqualType []) exitWith { false };

    private _activation = _statements param [1, ""];
    if !(_activation isEqualType "") exitWith { false };

    ((toLower _activation) find (toLower _flagName)) >= 0
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
        case (_side isEqualTo west):       { missionNamespace getVariable ["DZ_styleWestOwned", 0] };
        case (_side isEqualTo east):       { missionNamespace getVariable ["DZ_styleEastOwned", 1] };
        case (_side isEqualTo resistance): { missionNamespace getVariable ["DZ_styleResistanceOwned", 2] };
        default { _styleEastOwned };
    }
};

if !(_saved isEqualType []) then
{
    _saved = [];
};

_saved = (_saved select
{
    (_x isEqualType 0) && { _x >= 0 } && { _x <= _maxSectorId }
});

_saved = _saved arrayIntersect _saved;

if !(_savedOwners isEqualType []) then
{
    _savedOwners = [];
};

_savedOwners = _savedOwners select
{
    (_x isEqualType []) &&
    { (_x param [0, -1]) isEqualType 0 } &&
    { (_x param [1, ""]) isEqualType "" }
};

_sectorOwner resize (count _sectorGrid);
for "_idx" from 0 to ((count _sectorGrid) - 1) do
{
    if (isNil { _sectorOwner # _idx }) then
    {
        _sectorOwner set [_idx, _sideEnemy];
    };
};

private _captHash = createHashMap;
{
    private _sectorId = _x;
    private _hasSavedOwner = (_savedOwners findIf { (_x param [0, -1]) isEqualTo _sectorId }) >= 0;

    _captHash set [_sectorId, true];

    if (!_hasSavedOwner) then
    {
        _sectorOwner set [_sectorId, west];
        [_sectorId, west] call _fnc_setSavedOwner;
    };
} forEach _saved;

if (_savedOwners isEqualType []) then
{
    {
        private _sectorId = _x param [0, -1];
        private _ownerSide = [_x param [1, ""]] call _fnc_keyToSide;

        if (_sectorId >= 0 && { _sectorId <= _maxSectorId } && { !(_ownerSide isEqualTo sideUnknown) }) then
        {
            _sectorOwner set [_sectorId, _ownerSide];
            if (!(_ownerSide isEqualTo _sideEnemy)) then
            {
                _captHash set [_sectorId, true];
                _saved pushBackUnique _sectorId;
            };
        };
    } forEach _savedOwners;
}
else
{
    _savedOwners = [];
};

{
    private _state = +_zoneTemplate;
    _state set [4, true];
    _state set [6, true];
    _zoneData set [_x, _state];
    [_x, [_sectorOwner param [_x, west]] call _fnc_ownerStyle] call DZ_fnc_setSectorVisualState;
} forEach _saved;

{
    private _trigger = _x;
    private _playerArea = [_trigger, "DZ_playerArea"] call _fnc_hasTriggerZoneFlag;
    private _enemyArea = [_trigger, "DZ_enemyArea"] call _fnc_hasTriggerZoneFlag;

    if (!(_playerArea || _enemyArea)) then
    {
        continue;
    };

    if (_playerArea) then
    {
        _playerAreaTriggers = _playerAreaTriggers + 1;
        _forbiddenSpawnAreas pushBackUnique _trigger;
    };

    if (_enemyArea) then
    {
        _enemyAreaTriggers = _enemyAreaTriggers + 1;
    };

    {
        _x params ["_sectorId", "_centerX", "_centerY"];
        private _center = [_centerX, _centerY, 0];

        if !(_center inArea _trigger) then
        {
            continue;
        };

        if (_playerArea) then
        {
            if !(_sectorId in _captHash) then
            {
                _saved pushBack _sectorId;
                _captHash set [_sectorId, true];
            };

            private _state = +_zoneTemplate;
            _state set [4, true];
            _state set [6, true];
            _zoneData set [_sectorId, _state];
            _sectorOwner set [_sectorId, west];
            [_sectorId, west] call _fnc_setSavedOwner;
            [_sectorId, _stylePlayerOwned] call DZ_fnc_setSectorVisualState;
            _playerAreaSectors = _playerAreaSectors + 1;
        }
        else
        {
            if (_sectorId in _saved) then
            {
                _saved deleteAt (_saved find _sectorId);
            };

            if (_sectorId in _captHash) then
            {
                _captHash deleteAt _sectorId;
            };

            _urbanHash set [_sectorId, true];
            _zoneData set [_sectorId, +_zoneTemplate];
            _sectorOwner set [_sectorId, _sideEnemy];
            [_sectorId, _sideEnemy] call _fnc_setSavedOwner;
            [_sectorId, _styleEnemyDormant] call DZ_fnc_setSectorVisualState;
            _enemyAreaSectors = _enemyAreaSectors + 1;
        };
    } forEach _sectorGrid;
} forEach (allMissionObjects "EmptyDetector" select { !isNull _x });

missionNamespace setVariable ["DZ_zoneData", _zoneData];
missionNamespace setVariable ["DZ_sectorOwner", _sectorOwner];
missionNamespace setVariable ["DZ_urbanHash", _urbanHash];
missionNamespace setVariable ["DZ_savedCapturesCache", _saved];
missionNamespace setVariable ["DZ_savedSectorOwners", _savedOwners];
missionNamespace setVariable ["DZ_capturedHash", _captHash];
missionNamespace setVariable ["DZ_forbiddenSpawnAreas", _forbiddenSpawnAreas];

call DZ_fnc_saveSectors;

call DZ_fnc_publishSectorState;
diag_log format
[
    "[DZ] Static trigger zones processed | player triggers=%1 sectors=%2 | enemy triggers=%3 sectors=%4 | forbidden spawn areas=%5",
    _playerAreaTriggers,
    _playerAreaSectors,
    _enemyAreaTriggers,
    _enemyAreaSectors,
    count _forbiddenSpawnAreas
];
