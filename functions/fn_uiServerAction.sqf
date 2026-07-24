/*
 * DZ_fnc_uiServerAction
 * Server-side gateway for interactive tablet actions. Physical terminal
 * actions are distance checked and store prices are re-resolved from the
 * authoritative catalog.
 */

if (!isServer) exitWith {};

params
[
    ["_action", "", [""]],
    ["_caller", objNull, [objNull]],
    ["_terminal", objNull, [objNull]],
    ["_context", [], [[]]]
];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _reply = owner _caller;
private _actionKey = toLower _action;
private _requiresTerminal = _actionKey in
[
    "start_mission",
    "fob_contract",
    "abort_mission",
    "night_skip",
    "purchase"
];

if (_requiresTerminal && { isNull _terminal || { _caller distance _terminal > 8 } }) exitWith
{
    ["ПОЛЕВАЯ СЕТЬ", "Соединение с терминалом потеряно. Подойдите ближе."] remoteExecCall ["DZ_fnc_showHint", _reply];
};

switch (_actionKey) do
{
    case "start_mission":
    {
        private _terminalType = _terminal getVariable ["DZ_uiTerminalType", ""];
        if (_terminalType != "hq") exitWith
        {
            ["Штаб", "Этот терминал не имеет доступа к каталогу операций."] remoteExecCall ["DZ_fnc_showHint", _reply];
        };

        private _missionId = _context param [0, ""];
        [_missionId, _caller, "manual", side _caller] call DZ_fnc_startMission;
    };

    case "fob_contract":
    {
        if ((_terminal getVariable ["DZ_uiTerminalType", ""]) != "fob") exitWith {};
        [_caller] call DZ_fnc_requestFobMission;
    };

    case "abort_mission":
    {
        if !((_terminal getVariable ["DZ_uiTerminalType", ""]) in ["hq", "fob"]) exitWith {};
        [_caller] call DZ_fnc_abortMission;
    };

    case "night_skip":
    {
        if !((_terminal getVariable ["DZ_uiTerminalType", ""]) in ["hq", "fob"]) exitWith {};
        [_caller] call DZ_fnc_requestNightSkip;
    };

    case "purchase":
    {
        private _storeId = toLower (_context param [0, ""]);
        private _itemId = _context param [1, ""];

        if ((_terminal getVariable ["DZ_uiStoreId", ""]) != _storeId) exitWith
        {
            ["Снабжение", "Терминал магазина не прошёл проверку."] remoteExecCall ["DZ_fnc_showHint", _reply];
        };

        private _catalog = [_storeId] call DZ_fnc_getStoreCatalog;
        private _entryIndex = _catalog findIf { (_x # 1) == _itemId };
        if (_entryIndex < 0) exitWith
        {
            ["Снабжение", "Выбранная позиция отсутствует в каталоге."] remoteExecCall ["DZ_fnc_showHint", _reply];
        };

        private _entry = _catalog # _entryIndex;
        _entry params
        [
            "_category",
            "_validatedId",
            "_displayName",
            "_moneyCost",
            "_supplyCost",
            "_className",
            "_validatedStore",
            "_deliveryPad",
            "_storeName"
        ];

        [
            _validatedId,
            _className,
            _moneyCost,
            _supplyCost,
            _caller,
            _deliveryPad,
            _storeName,
            _terminal
        ] call DZ_fnc_purchaseItem;
    };
};

[_caller] call DZ_fnc_requestUiSnapshot;
