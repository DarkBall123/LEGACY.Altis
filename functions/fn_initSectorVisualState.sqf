params
[
    ["_sectorGrid", missionNamespace getVariable ["DZ_sectorGrid", []]]
];

private _enemyStyle = missionNamespace getVariable ["DZ_styleEnemyDormant", 0];
private _sectorState = [];

_sectorState resize (count _sectorGrid);

for "_idx" from 0 to ((count _sectorGrid) - 1) do
{
    _sectorState set [_idx, _enemyStyle];
};

missionNamespace setVariable ["DZ_sectorVisualState", _sectorState];

_sectorState
