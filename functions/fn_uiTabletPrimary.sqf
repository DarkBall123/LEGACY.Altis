/*
 * DZ_fnc_uiTabletPrimary
 */

disableSerialization;

private _display = uiNamespace getVariable ["DZ_TabletDisplay", displayNull];
if (isNull _display) exitWith {};

private _tab = uiNamespace getVariable ["DZ_uiTabletTab", "overview"];
private _kind = uiNamespace getVariable ["DZ_uiTerminalKind", "field"];
private _terminal = uiNamespace getVariable ["DZ_uiTerminalObject", objNull];
private _context = uiNamespace getVariable ["DZ_uiTerminalContext", ""];
private _list = _display displayCtrl 96020;
private _selected = (lbCurSel _list) max 0;
private _data = _list lbData _selected;

switch (_tab) do
{
    case "overview":
    {
        [] call DZ_fnc_uiRequestSnapshotLocal;
        ["ПОЛЕВАЯ СЕТЬ", "Запрошено обновление оперативных данных.", "info", 3] call DZ_fnc_uiNotify;
    };

    case "operations":
    {
        if (_kind == "hq") then
        {
            ["start_mission", player, _terminal, [_data]] remoteExecCall ["DZ_fnc_uiServerAction", 2];
        };
        if (_kind == "fob") then
        {
            ["fob_contract", player, _terminal, []] remoteExecCall ["DZ_fnc_uiServerAction", 2];
        };
    };

    case "support":
    {
        if (_data != "" && { !isNil "DZ_fnc_fireSupportOpenTargeting" }) then
        {
            closeDialog 0;
            [_data] call DZ_fnc_fireSupportOpenTargeting;
        };
    };

    case "store":
    {
        if (_data != "") then
        {
            ["purchase", player, _terminal, [_context, _data]] remoteExecCall ["DZ_fnc_uiServerAction", 2];
        };
    };
};
