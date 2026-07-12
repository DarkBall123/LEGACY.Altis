/*
 * DZ_fnc_initHqLaptop
 * Adds ACE mission start and status actions to the APD HQ laptop.
 *
 * Per-side (Wave 4): every action's condition checks the player is
 * APD (west). The APD laptop is the WEST mission slot — actions
 * gate on west's own slot, independent of Free Altis's mission.
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop) exitWith { false };
if (!hasInterface) exitWith { true };
if (_laptop getVariable ["hq_actions_added", false]) exitWith { true };

_laptop setVariable ["hq_actions_added", true, false];

private _missionList = [
    ["interdiction",     "Миссия: Перехват конвоя Хунты"],
    ["assassination",    "Миссия: Ликвидация офицера Хунты"],
    ["destroy_cache",    "Миссия: Уничтожить склады Хунты"],
    ["artillery_hunt",   "Миссия: Контрбатарейная борьба"],
    ["downed_pilot",     "Миссия: Спасти пилота ОКСВ"],
    ["humanitarian_aid", "Миссия: Доставка гуманитарной помощи"],
    ["eod",              "Миссия: Разминирование маршрута"],
    ["idap_repair",      "Миссия: Дозаправка транспорта Красного Креста"],
    ["air_defense",      "Миссия: Подавление ПВО Хунты"],
    ["defend_informant", "Миссия: Прикрытие перебежчика"],
    ["heli_intercept",   "Миссия: Воздушный перехват"]
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

            diag_log format ["[DZ_LAPTOP_APD] Mission action: id=%1 player=%2",
                _id, name _player];

            [_id, _player, "manual", east] remoteExecCall ["DZ_fnc_startMission", 2];
        },
        {
            params ["_target", "_player"];
            side _player == east
        },
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
    "dz_mission_abort",
    "Прервать миссию",
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
    "dz_mission_abort_confirm",
    "Подтвердить отмену",
    "",
    {
        params ["_target", "_player"];
        diag_log format ["[DZ_LAPTOP_APD] Abort confirmed by %1", name _player];
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

[_laptop, 0, ["ACE_MainActions", "dz_mission_abort"], _abortConfirm] call ace_interact_menu_fnc_addActionToObject;

diag_log format ["[DZ_LAPTOP_APD] Added %1 mission actions + status + abort to APD laptop %2",
    count _missionList, _laptop];

true
