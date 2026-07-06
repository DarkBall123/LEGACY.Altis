/*
 * DZ_fnc_collectAssassinationIntel
 * Handles intel pickup for the assassination mission and reveals the
 * target area. Per-side: the caller's faction is the one that picked
 * up the intel — only THAT side's assassination mission is advanced.
 * The other side's mission state (if any) is untouched.
 */

if (!isServer) exitWith {};

params [
    ["_target", objNull, [objNull]],
    ["_caller", objNull, [objNull]]
];

if (isNull _target) exitWith {};
if (isNull _caller) exitWith {};

if (!alive _caller)                  exitWith {};
if (_caller distance _target > 5)    exitWith {};
if (_target getVariable ["intel_collected", false]) exitWith {};

private _callerSide = [_caller] call DZ_fnc_missionSideOfPlayer;
if (_callerSide isEqualTo sideUnknown) exitWith {};

private _state = [_callerSide] call DZ_fnc_missionStateOf;
if !(_state get "active") exitWith {};
if ((_state get "id") != "assassination") exitWith {};

_target setVariable ["intel_collected", true, true];
missionNamespace setVariable ["DZ_assassinationIntelTaken", true];

[
    "Штаб",
    format ["Документы получены бойцом %1. Возвращайтесь на базу.", name _caller]
] remoteExecCall ["DZ_fnc_showHint", _callerSide];
