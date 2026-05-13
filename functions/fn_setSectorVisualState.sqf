params
[
    ["_sectorId", -1],
    ["_styleId", -1]
];

if (_sectorId < 0 || { _styleId < 0 }) exitWith { false };

private _sectorState = missionNamespace getVariable ["DZ_sectorVisualState", []];
private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _enemyStyle = missionNamespace getVariable ["DZ_styleEnemyDormant", 0];
private _targetSize = (count _sectorGrid) max (_sectorId + 1);
private _dirty = false;

if ((count _sectorState) < _targetSize) then
{
    _sectorState resize _targetSize;
    _dirty = true;
};

for "_idx" from 0 to (_targetSize - 1) do
{
    if (isNil { _sectorState # _idx }) then
    {
        _sectorState set [_idx, _enemyStyle];
        _dirty = true;
    };
};

if ((_sectorState # _sectorId) isEqualTo _styleId) exitWith
{
    if (_dirty) then
    {
        missionNamespace setVariable ["DZ_sectorVisualState", _sectorState];
    };

    _dirty
};

_sectorState set [_sectorId, _styleId];
missionNamespace setVariable ["DZ_sectorVisualState", _sectorState];

true
