/*
 * DZ_fnc_initRadio
 * Adds ACE play, stop, and next-track controls to a radio object.
 */

params [["_radio", objNull, [objNull]]];

if (isNull _radio)  exitWith { false };
if (!hasInterface)  exitWith { true };
if (_radio getVariable ["radio_actions_added", false]) exitWith { true };

_radio setVariable ["radio_actions_added", true, false];

[
    { !isNil "ace_interact_menu_fnc_createAction" },
    {
        params ["_radio"];

        private _fnc_makeAction =
        {
            params ["_id", "_label", "_code", "_condition"];
            [_id, _label, "", _code, _condition] call ace_interact_menu_fnc_createAction
        };

        private _aRoot = [
            "radio_root",
            "Радио",
            { true },
            { true }
        ] call _fnc_makeAction;

        private _aPlay = [
            "radio_play",
            "Включить",
            {
                params ["_target", "_player"];
                [_target, "play"] remoteExecCall ["DZ_fnc_radioControl", 2];
            },
            { !((_target getVariable ['radio_playing', false])) }
        ] call _fnc_makeAction;

        private _aStop = [
            "radio_stop",
            "Выключить",
            {
                params ["_target", "_player"];
                [_target, "stop"] remoteExecCall ["DZ_fnc_radioControl", 2];
            },
            { (_target getVariable ['radio_playing', false]) }
        ] call _fnc_makeAction;

        private _aNext = [
            "radio_next",
            "Следующий трек",
            {
                params ["_target", "_player"];
                [_target, "next"] remoteExecCall ["DZ_fnc_radioControl", 2];
            },
            { (_target getVariable ['radio_playing', false]) }
        ] call _fnc_makeAction;

        [_radio, 0, ["ACE_MainActions"], _aRoot] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aPlay] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aStop] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aNext] call ace_interact_menu_fnc_addActionToObject;
    },
    [_radio]
] call CBA_fnc_waitUntilAndExecute;

true
