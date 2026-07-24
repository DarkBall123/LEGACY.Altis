/*
 * DZ_fnc_uiTabletOnSelect
 */

params ["_control", ["_index", 0]];

if (uiNamespace getVariable ["DZ_uiTabletListUpdating", false]) exitWith {};

uiNamespace setVariable ["DZ_uiTabletSelection", _index max 0];
[false] call DZ_fnc_uiRefreshTablet;
