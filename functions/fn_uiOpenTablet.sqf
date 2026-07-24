/*
 * DZ_fnc_uiOpenTablet
 * Opens the field tablet or a physical HQ/FOB/store terminal.
 */

params
[
    ["_tab", "overview", [""]],
    ["_terminalKind", "field", [""]],
    ["_terminalObject", objNull, [objNull]],
    ["_context", "", [""]]
];

if (!hasInterface) exitWith { false };
if (!isNull (uiNamespace getVariable ["DZ_TabletDisplay", displayNull])) exitWith { true };

if (_terminalKind != "field" && { isNull _terminalObject || { player distance _terminalObject > 8 } }) exitWith
{
    ["ПОЛЕВАЯ СЕТЬ", "Подойдите ближе к терминалу.", "warning", 5] call DZ_fnc_uiNotify;
    false
};

uiNamespace setVariable ["DZ_uiTabletTab", toLower _tab];
uiNamespace setVariable ["DZ_uiTabletSelection", 0];
uiNamespace setVariable ["DZ_uiTabletListKey", ""];
uiNamespace setVariable ["DZ_uiTabletListUpdating", false];
uiNamespace setVariable ["DZ_uiTerminalKind", toLower _terminalKind];
uiNamespace setVariable ["DZ_uiTerminalObject", _terminalObject];
uiNamespace setVariable ["DZ_uiTerminalContext", toLower _context];

[] call DZ_fnc_uiRequestSnapshotLocal;
createDialog "DZ_TabletDisplay"
