/*
 * DZ_fnc_initRadio
 *
 * Adds ACE interaction actions (Play / Stop / Next) to a radio object.
 *
 * USAGE — radio object's editor "Init" field:
 *     [this] call DZ_fnc_initRadio;
 *
 * Architecture:
 *   - Actions are local (every machine adds its own, like the laptop).
 *   - Clicking a button remoteExec's DZ_fnc_radioControl on the SERVER
 *     so the radio's playing-state stays authoritative.
 *   - The actual playSound3D fires globally so every nearby player
 *     hears it positionally — playSound3D respects 3D distance natively.
 *
 * Track list lives in DZ_RadioTracks (set in initServer.sqf alongside
 * the radio so it's easy to add tracks without editing the function).
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

        // Parent action — players open this and the three controls sit inside.
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

        // Mount the parent under ACE_MainActions, then nest controls inside it.
        [_radio, 0, ["ACE_MainActions"], _aRoot] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aPlay] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aStop] call ace_interact_menu_fnc_addActionToObject;
        [_radio, 0, ["ACE_MainActions", "radio_root"], _aNext] call ace_interact_menu_fnc_addActionToObject;
    },
    [_radio]
] call CBA_fnc_waitUntilAndExecute;

true
