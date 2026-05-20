/*
 * DZ_fnc_initFobLaptop
 * Adds the Forward Operating Base contract laptop ACE actions:
 *   - "Запросить контракт (повышенная награда)" -> random mission,
 *      doubled reward (source "fob").
 *   - "Проверить статус миссии" -> current mission status.
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
    { true },
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
    { true },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _statusAction] call ace_interact_menu_fnc_addActionToObject;

diag_log format ["[DZ_FOB] FOB contract laptop initialized: %1", _laptop];

true
