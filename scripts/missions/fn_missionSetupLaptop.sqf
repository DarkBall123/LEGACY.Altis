/*
 * scripts/missions/fn_missionSetupLaptop.sqf
 * Legacy laptop setup script that adds mission start actions.
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop)  exitWith {};
if (!hasInterface)   exitWith {};
if (_laptop getVariable ["DZ_missionLaptopReady", false]) exitWith {};
_laptop setVariable ["DZ_missionLaptopReady", true];

[
    { !isNil "ace_interact_menu_fnc_createAction" },
    {
        params ["_laptop"];

        private _fnc_makeAction = {
            params ["_id", "_label", "_code"];
            [_id, _label, "", _code, { true }] call ace_interact_menu_fnc_createAction
        };

        private _aInterdiction = [
            "mission_interdiction",
            "Миссия: Перехват поставок",
            {
                if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
                    hint "Миссия уже активна.";
                };
                ["interdiction"] remoteExec ["DZ_fnc_missionStart", 2];
            }
        ] call _fnc_makeAction;

        private _aStatus = [
            "mission_status",
            "Статус миссии",
            {
                if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
                    hint "Нет активной миссии.";
                };
                hint format [
                    "Активная миссия: %1\nПродолжительность: %2 мин",
                    missionNamespace getVariable ["DZ_missionId", "?"],
                    floor ((time - (missionNamespace getVariable ["DZ_missionStart", time])) / 60)
                ];
            }
        ] call _fnc_makeAction;

        [_laptop, 0, ["ACE_MainActions"], _aInterdiction] call ace_interact_menu_fnc_addActionToObject;
        [_laptop, 0, ["ACE_MainActions"], _aStatus]       call ace_interact_menu_fnc_addActionToObject;
    },
    [_laptop]
] call CBA_fnc_waitUntilAndExecute;
