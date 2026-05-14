/*
 * DZ_fnc_collectAssassinationIntel
 * Handles intel pickup for the assassination mission and reveals the target area.
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

if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};
if ((missionNamespace getVariable ["DZ_missionCurrentId", ""]) != "assassination") exitWith {};

_target setVariable ["intel_collected", true, true];
missionNamespace setVariable ["DZ_assassinationIntelTaken", true];

[
    "Штаб",
    format ["Документы получены бойцом %1. Возвращайтесь на базу.", name _caller]
] remoteExecCall ["DZ_fnc_showHint", 0];
