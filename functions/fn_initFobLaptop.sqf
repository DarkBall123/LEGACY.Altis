/*
 * DZ_fnc_initFobLaptop
 * Adds Forward Operating Base contract ACE actions to the Free
 * Altis FOB laptop. The FOB is a resistance asset — every action
 * is gated to resistance and dispatches against the resistance
 * mission slot. APD's mission is irrelevant here.
 *
 * Eden setup: place a laptop prop at the FOB, init field:
 *     [this] call DZ_fnc_initFobLaptop;
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop) exitWith { false };
if (!hasInterface) exitWith { true };
if (_laptop getVariable ["fob_actions_added", false]) exitWith { true };

_laptop setVariable ["fob_actions_added", true, false];

private _contractAction = [
    "dz_fob_contract",
    "Запросить контракт (повышенная награда)",
    "",
    {
        params ["_target", "_player"];
        diag_log format ["[DZ_FOB] Contract action by %1", name _player];
        [_player] remoteExecCall ["DZ_fnc_requestFobMission", 2];
    },
    { side _this == resistance },
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
    { side _this == resistance },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _statusAction] call ace_interact_menu_fnc_addActionToObject;

// Two-step abort for the resistance slot.
private _abortParent = [
    "dz_fob_abort",
    "Прервать контракт",
    "",
    {},
    {
        (side _this == resistance) &&
        { missionNamespace getVariable ["DZ_missionActive_GUER", false] }
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
        (side _this == resistance) &&
        { missionNamespace getVariable ["DZ_missionActive_GUER", false] }
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
