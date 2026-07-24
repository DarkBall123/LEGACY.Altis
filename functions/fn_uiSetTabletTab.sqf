/*
 * DZ_fnc_uiSetTabletTab
 */

params [["_tab", "overview", [""]]];

if (_tab == "store" && { (uiNamespace getVariable ["DZ_uiTerminalKind", "field"]) != "store" }) exitWith {};

uiNamespace setVariable ["DZ_uiTabletTab", toLower _tab];
uiNamespace setVariable ["DZ_uiTabletSelection", 0];
uiNamespace setVariable ["DZ_uiTabletListKey", ""];
[true] call DZ_fnc_uiRefreshTablet;
