params
[
    ["_unit", objNull],
    ["_loadout", []],
    ["_force", false]
];

if (!hasInterface) exitWith { false };
if (isNull _unit) exitWith { false };

if (!_force && { missionNamespace getVariable ["DZ_originalLoadoutReady", false] }) exitWith
{
    true
};

private _snapshot = if (_loadout isEqualType [] && { _loadout isNotEqualTo [] }) then
{
    +_loadout
}
else
{
    getUnitLoadout _unit
};

if !(_snapshot isEqualType []) exitWith { false };
if (_snapshot isEqualTo []) exitWith { false };

missionNamespace setVariable ["DZ_originalLoadout", +_snapshot];
missionNamespace setVariable ["DZ_originalLoadoutReady", true];

true
