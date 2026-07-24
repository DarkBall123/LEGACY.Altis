/*
 * DZ_fnc_uiTabletOnLoad
 * Applies context-specific title and initial tab state.
 */

disableSerialization;

private _display = uiNamespace getVariable ["DZ_TabletDisplay", displayNull];
if (isNull _display) exitWith {};

private _kind = uiNamespace getVariable ["DZ_uiTerminalKind", "field"];
private _context = uiNamespace getVariable ["DZ_uiTerminalContext", ""];

private _header = switch (_kind) do
{
    case "hq":    { "КОМАНДНЫЙ ТЕРМИНАЛ // ПОЛНЫЙ ДОСТУП" };
    case "fob":   { "ПЕРЕДОВАЯ БАЗА // КОНТРАКТНАЯ СЕТЬ" };
    case "store":
    {
        if (_context == "vdv") then { "СНАБЖЕНИЕ ВДВ // ЗАКРЫТЫЙ КАНАЛ" } else { "СНАБЖЕНИЕ ГРУ // БАЗОВЫЙ СКЛАД" }
    };
    default       { "ПОЛЕВОЙ ПЛАНШЕТ // ИНФОРМАЦИОННЫЙ РЕЖИМ" };
};

(_display displayCtrl 96002) ctrlSetText _header;
(_display displayCtrl 96015) ctrlShow (_kind == "store");

if (_kind == "store") then
{
    uiNamespace setVariable ["DZ_uiTabletTab", "store"];
};

[true] call DZ_fnc_uiRefreshTablet;
