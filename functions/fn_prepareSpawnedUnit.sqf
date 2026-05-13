params [["_unit", objNull]];

if (isNull _unit) exitWith { false };

private _uavOperatorClasses = missionNamespace getVariable ["DZ_uavOperatorClasses", []];
if !((typeOf _unit) in _uavOperatorClasses) exitWith { false };

private _backpacks = missionNamespace getVariable ["DZ_uavOperatorBackpacks", []];
if (_backpacks isEqualTo []) exitWith { true };

removeBackpackGlobal _unit;
_unit addBackpackGlobal (selectRandom _backpacks);

true
