private _sectorState = missionNamespace getVariable ["DZ_sectorVisualState", []];
private _lastSectorState = missionNamespace getVariable ["DZ_lastSectorVisualState", []];

if (_sectorState isEqualTo _lastSectorState) exitWith { false };

private _payload = missionNamespace getVariable ["DZ_sectorStatePayload", [0, []]];
private _revision = (_payload # 0) + 1;

missionNamespace setVariable ["DZ_lastSectorVisualState", +_sectorState];
missionNamespace setVariable ["DZ_sectorStatePayload", [_revision, +_sectorState], true];

true
