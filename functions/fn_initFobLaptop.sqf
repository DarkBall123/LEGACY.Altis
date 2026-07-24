/*
 * DZ_fnc_initFobLaptop
 * Adds the consolidated contract terminal to the ОКСВ forward base.
 * The legacy ACE actions below remain as a compatibility fallback.
 *
 * Eden setup: place a laptop prop at the FOB, init field:
 *     [this] call DZ_fnc_initFobLaptop;
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop) exitWith { false };
_laptop setVariable ["DZ_uiTerminalType", "fob", true];
if (!hasInterface) exitWith { true };
if (_laptop getVariable ["fob_actions_added", false]) exitWith { true };

_laptop setVariable ["fob_actions_added", true, false];

if (!isNil "DZ_fnc_uiOpenTablet") exitWith
{
    private _terminalAction =
    [
        "DZ_FobTerminal",
        "Терминал передовой базы",
        "",
        {
            params ["_target"];
            ["operations", "fob", _target, ""] call DZ_fnc_uiOpenTablet;
        },
        {
            params ["_target", "_player"];
            side _player == east
        },
        {},
        [],
        {[0, 0, 0.5]},
        6,
        [false, false, true, false, true]
    ] call ace_interact_menu_fnc_createAction;

    [_laptop, 0, ["ACE_MainActions"], _terminalAction] call ace_interact_menu_fnc_addActionToObject;
    true
};

private _contractAction = [
    "dz_fob_contract",
    "Запросить контракт (повышенная награда)",
    "",
    {
        params ["_target", "_player"];
        diag_log format ["[DZ_FOB] Contract action by %1", name _player];
        [_player] remoteExecCall ["DZ_fnc_requestFobMission", 2];
    },
    {
        params ["_target", "_player"];
        side _player == east
    },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _contractAction] call ace_interact_menu_fnc_addActionToObject;

private _statusAction = [
    "dz_fob_status",
    "Проверить статус миссии",
    "",
    {
        params ["_target", "_player"];
        [_player] remoteExecCall ["DZ_fnc_requestMissionStatus", 2];
    },
    {
        params ["_target", "_player"];
        side _player == east
    },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _statusAction] call ace_interact_menu_fnc_addActionToObject;

private _nightSkipAction = [
    "dz_night_skip",
    "Промотать ночь",
    "",
    {
        params ["_target", "_player"];
        [_player] remoteExecCall ["DZ_fnc_requestNightSkip", 2];
    },
    {
        params ["_target", "_player"];
        side _player == east
    },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _nightSkipAction] call ace_interact_menu_fnc_addActionToObject;

private _abortParent = [
    "dz_fob_abort",
    "Прервать контракт",
    "",
    {},
    {
        params ["_target", "_player"];
        (side _player == east) &&
        { missionNamespace getVariable ["DZ_missionActive_EAST", false] }
    },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _abortParent] call ace_interact_menu_fnc_addActionToObject;

private _abortConfirm = [
    "dz_fob_abort_confirm",
    "Подтвердить отмену",
    "",
    {
        params ["_target", "_player"];
        diag_log format ["[DZ_LAPTOP_FOB] Abort confirmed by %1", name _player];
        [_player] remoteExecCall ["DZ_fnc_abortMission", 2];
    },
    {
        params ["_target", "_player"];
        (side _player == east) &&
        { missionNamespace getVariable ["DZ_missionActive_EAST", false] }
    },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions", "dz_fob_abort"], _abortConfirm] call ace_interact_menu_fnc_addActionToObject;

diag_log format ["[DZ_FOB] FOB contract laptop initialized: %1", _laptop];

true
