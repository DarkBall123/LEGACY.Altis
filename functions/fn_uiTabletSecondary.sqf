/*
 * DZ_fnc_uiTabletSecondary
 */

private _tab = uiNamespace getVariable ["DZ_uiTabletTab", "overview"];
private _kind = uiNamespace getVariable ["DZ_uiTerminalKind", "field"];
private _terminal = uiNamespace getVariable ["DZ_uiTerminalObject", objNull];

switch (_tab) do
{
    case "overview":
    {
        if (_kind in ["hq", "fob"]) then
        {
            ["night_skip", player, _terminal, []] remoteExecCall ["DZ_fnc_uiServerAction", 2];
        };
    };

    case "operations":
    {
        if (_kind in ["hq", "fob"]) then
        {
            ["abort_mission", player, _terminal, []] remoteExecCall ["DZ_fnc_uiServerAction", 2];
        };
    };

    case "store":
    {
        [] call DZ_fnc_uiRequestSnapshotLocal;
        ["СНАБЖЕНИЕ", "Баланс и склад обновляются.", "info", 3] call DZ_fnc_uiNotify;
    };
};
