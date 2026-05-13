/*
 * DZ_fnc_missionSetupLaptop
 *
 * Attaches HQ-laptop ACE actions to a given object.
 *
 * USAGE — in the laptop's editor "Init" field, write:
 *     [this] call DZ_fnc_missionSetupLaptop;
 *
 * Editor init fields run locally on every machine (including JIP joiners),
 * so each client adds its own local ACE actions. No remoteExec needed.
 *
 * Mission state checks remain server-authoritative: clicking an action
 * remoteExec's the start request to the server (target 2).
 */

params [["_laptop", objNull, [objNull]]];

if (isNull _laptop)  exitWith {};
if (!hasInterface)   exitWith {};        // skip dedicated server / HC
if (_laptop getVariable ["DZ_missionLaptopReady", false]) exitWith {};
_laptop setVariable ["DZ_missionLaptopReady", true];

// Wait for ACE without blocking the rest of init.
[
    { !isNil "ace_interact_menu_fnc_createAction" },
    {
        params ["_laptop"];

        private _fnc_makeAction = {
            params ["_id", "_label", "_code"];
            [_id, _label, "", _code, { true }] call ace_interact_menu_fnc_createAction
        };

        // ── Mission: Convoy Interdiction ─────────────
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

        // ── Status check (reads publicVariable'd state) ──
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
