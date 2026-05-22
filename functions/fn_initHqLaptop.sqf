/*
 * DZ_fnc_initHqLaptop
 * Adds ACE mission start and status actions to the HQ laptop.
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop) exitWith { false };
if (!hasInterface) exitWith { true };
if (_laptop getVariable ["hq_actions_added", false]) exitWith { true };

_laptop setVariable ["hq_actions_added", true, false];

private _missionList = [
    ["interdiction",     "Миссия: Перехват поставок"],
    ["assassination",    "Миссия: Убийство цели"],
    ["destroy_cache",    "Миссия: Уничтожить тайники"],
    ["artillery_hunt",   "Миссия: Уничтожить миномёт"],
    ["downed_pilot",     "Миссия: Сбитый пилот"],
    ["humanitarian_aid", "Миссия: Гуманитарная помощь"],
    ["eod",              "Миссия: Разминирование маршрута"],
    ["idap_repair",      "Миссия: Дозаправка транспорта IDAP"],
    ["air_defense",      "Миссия: Подавление ПВО"],
    ["defend_informant", "Миссия: Защита информатора"]
];

{
    _x params ["_missionId", "_missionTitle"];

    private _action = [
        format ["dz_mission_%1", _missionId],
        _missionTitle,
        "",
        {
            params ["_target", "_player", "_args"];
            _args params ["_id"];

            diag_log format ["[DZ_LAPTOP] Mission action: id=%1 player=%2",
                _id, name _player];

            [_id, _player] remoteExecCall ["DZ_fnc_startMission", 2];
        },
        { true },
        {},
        [_missionId],
        {[0, 0, 0.5]},
        5,
        [false, false, true, false, true]
    ] call ace_interact_menu_fnc_createAction;

    [_laptop, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach _missionList;

private _statusAction = [
    "dz_mission_status",
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

// Abort menu: parent + confirmation child. Parent is only shown when a
// mission is active; the second click on "Подтвердить отмену" actually
// fires the abort. The two-step form keeps a misclick from killing the
// squad's mission.
private _abortParent = [
    "dz_mission_abort",
    "Прервать миссию",
    "",
    {},
    { missionNamespace getVariable ["DZ_missionActive", false] },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions"], _abortParent] call ace_interact_menu_fnc_addActionToObject;

private _abortConfirm = [
    "dz_mission_abort_confirm",
    "Подтвердить отмену",
    "",
    {
        params ["_target", "_player"];
        diag_log format ["[DZ_LAPTOP] Abort confirmed by %1", name _player];
        [_player] remoteExecCall ["DZ_fnc_abortMission", 2];
    },
    { missionNamespace getVariable ["DZ_missionActive", false] },
    {},
    [],
    {[0, 0, 0.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_laptop, 0, ["ACE_MainActions", "dz_mission_abort"], _abortConfirm] call ace_interact_menu_fnc_addActionToObject;

diag_log format ["[DZ_LAPTOP] Added %1 mission actions + status + abort to laptop %2",
    count _missionList, _laptop];

true
