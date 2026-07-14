/*
 * DZ_fnc_missionRunStateMachine
 * Shared terminal state-machine scaffold for mission scripts. Factors
 * out the boilerplate every mission repeats: a throttled per-frame
 * handler that aborts cleanly when the side's mission is no longer
 * active, fails on timeout, tracks its own handle for cleanup, and
 * otherwise calls the mission-specific tick.
 *
 * Usage:
 *   [
 *       _side,
 *       { params ["_args","_elapsed","_side"]; ... ["continue"|"success"|"failure", _msg] },
 *       _tickArgs,        (closure state passed to the tick each pass)
 *       _timeout,         (seconds, default 3600)
 *       _interval,        (PFH delay in seconds, default 2)
 *       _timeoutMsg       (side message on timeout, "" = silent)
 *   ] call DZ_fnc_missionRunStateMachine;
 *
 * The tick returns [_status, _msg]:
 *   "continue" — keep running (no message needed)
 *   "success"  — endMission "success" for the side, optional side message
 *   "failure"  — endMission "failure" for the side, optional side message
 *
 * The handler is registered as a mission asset, so fn_endMission removes
 * it as part of normal cleanup.
 */

params [
    ["_side",       sideUnknown],
    ["_tickCode",   {}, [{}]],
    ["_tickArgs",   []],
    ["_timeout",    3600, [0]],
    ["_interval",   2, [0]],
    ["_timeoutMsg", "Время вышло. Миссия провалена.", [""]]
];

if (!isServer) exitWith { -1 };

private _handle = [
    {
        params ["_a", "_h"];
        _a params ["_side", "_tickCode", "_tickArgs", "_timeout", "_timeoutMsg", "_startTime"];

        if !([_side] call DZ_fnc_missionActiveForSide) exitWith {
            [_h] call CBA_fnc_removePerFrameHandler;
        };

        if ((time - _startTime) > _timeout) exitWith {
            [_h] call CBA_fnc_removePerFrameHandler;
            ["failure", _side] call DZ_fnc_endMission;
            if (_timeoutMsg != "") then { [_timeoutMsg, _side] remoteExecCall ["DZ_fnc_sideMessage", 0]; };
        };

        private _r = [_tickArgs, (time - _startTime), _side] call _tickCode;
        if !(_r isEqualType []) then { _r = ["continue", ""] };
        _r params [["_status", "continue"], ["_msg", ""]];

        if (_status isEqualTo "success") exitWith {
            [_h] call CBA_fnc_removePerFrameHandler;
            ["success", _side] call DZ_fnc_endMission;
            if (_msg != "") then { [_msg, _side] remoteExecCall ["DZ_fnc_sideMessage", 0]; };
        };

        if (_status isEqualTo "failure") exitWith {
            [_h] call CBA_fnc_removePerFrameHandler;
            ["failure", _side] call DZ_fnc_endMission;
            if (_msg != "") then { [_msg, _side] remoteExecCall ["DZ_fnc_sideMessage", 0]; };
        };
    },
    _interval,
    [_side, _tickCode, _tickArgs, _timeout, _timeoutMsg, time]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_handle], _side] call DZ_fnc_addMissionAssets;

_handle
