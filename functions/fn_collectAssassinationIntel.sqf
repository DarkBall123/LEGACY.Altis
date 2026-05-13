/*
 * DZ_fnc_collectAssassinationIntel
 *
 * Server-side handler called when a player uses the "Забрать документы"
 * action on the target's corpse. Validates the request, marks intel as
 * collected, and lets the assassination mission's PFH transition to
 * success.
 *
 *     [_target, _caller] remoteExecCall ["DZ_fnc_collectAssassinationIntel", 2];
 */

if (!isServer) exitWith {};

params [
    ["_target", objNull, [objNull]],
    ["_caller", objNull, [objNull]]
];

if (isNull _target) exitWith {};
if (isNull _caller) exitWith {};

// Light spoof check — caller must be near the body, alive, and on the
// player side. Saves us from accepting bogus calls (e.g. from a desynced
// or rogue client passing a different _target).
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
