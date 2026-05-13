params [["_laptop", objNull, [objNull]]];

if (isNull _laptop) exitWith { false };
if (!hasInterface) exitWith { true };
if (_laptop getVariable ["hq_actions_added", false]) exitWith { true };

_laptop setVariable ["hq_actions_added", true, false];

// ── ACE actions on the laptop ────────────────────────────
//
// No chat spam. Diagnostic logging goes to RPT only via diag_log.

private _missionList = [
    ["interdiction",     "Миссия: Перехват поставок"],
    ["assassination",    "Миссия: Убийство цели"],
    ["destroy_cache",    "Миссия: Уничтожить тайники"],
    ["artillery_hunt",   "Миссия: Уничтожить миномёт"],
    ["downed_pilot",     "Миссия: Сбитый пилот"],
    ["humanitarian_aid", "Миссия: Гуманитарная помощь"]
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

diag_log format ["[DZ_LAPTOP] Added %1 mission actions + status to laptop %2",
    count _missionList, _laptop];

true
