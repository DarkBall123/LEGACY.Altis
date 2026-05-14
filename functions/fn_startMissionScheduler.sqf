/*
 * DZ_fnc_startMissionScheduler
 * Starts the automatic mission scheduler PFH.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

if !(missionNamespace getVariable ["DZ_missionSchedulerEnabled", false]) exitWith { false };

if (missionNamespace getVariable ["DZ_missionSchedulerStarted", false]) exitWith { true };

missionNamespace setVariable ["DZ_missionSchedulerStarted", true];

private _initialDelay = missionNamespace getVariable ["DZ_missionEventInitialDelay", 1200];

[DZ_fnc_missionSchedulerTick, [], _initialDelay] call CBA_fnc_waitAndExecute;

diag_log format ["[DZ] Mission scheduler started. First event check in %1 seconds.", _initialDelay];

true
