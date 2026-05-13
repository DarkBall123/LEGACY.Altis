private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _urbanHash = missionNamespace getVariable ["DZ_urbanHash", createHashMap];
private _zoneTemplate = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _styleEnemyDormant = missionNamespace getVariable ["DZ_styleEnemyDormant", 0];
private _stylePlayerOwned = missionNamespace getVariable ["DZ_stylePlayerOwned", 2];
private _maxSectorId = (count _sectorGrid) - 1;

private _saved = profileNamespace getVariable ["DZ_savedCaptures", []];
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

if !(_saved isEqualType []) then
{
    _saved = [];
};

_saved = (_saved select
{
    (_x isEqualType 0) && { _x >= 0 } && { _x <= _maxSectorId }
});

_saved = _saved arrayIntersect _saved;

private _captHash = createHashMap;
{
    _captHash set [_x, true];
} forEach _saved;

{
    private _state = +_zoneTemplate;
    _state set [4, true];
    _state set [6, true];
    _zoneData set [_x, _state];
    [_x, _stylePlayerOwned] call DZ_fnc_setSectorVisualState;
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
            [_sectorId, _styleEnemyDormant] call DZ_fnc_setSectorVisualState;
            _enemyAreaSectors = _enemyAreaSectors + 1;
        };
    } forEach _sectorGrid;
} forEach (allMissionObjects "EmptyDetector" select { !isNull _x });

profileNamespace setVariable ["DZ_savedCaptures", _saved];
saveProfileNamespace;

missionNamespace setVariable ["DZ_zoneData", _zoneData];
missionNamespace setVariable ["DZ_urbanHash", _urbanHash];
missionNamespace setVariable ["DZ_savedCapturesCache", _saved];
missionNamespace setVariable ["DZ_capturedHash", _captHash];
missionNamespace setVariable ["DZ_forbiddenSpawnAreas", _forbiddenSpawnAreas];

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
