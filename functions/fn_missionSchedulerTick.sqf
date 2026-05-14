/*
 * DZ_fnc_missionSchedulerTick
 * Runs one scheduler tick for automatic random mission starts.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _enabled = missionNamespace getVariable ["DZ_missionSchedulerEnabled", false];

if (_enabled) then
{
    call DZ_fnc_startRandomMission;
};

private _interval = missionNamespace getVariable ["DZ_missionEventInterval", 1200];
[DZ_fnc_missionSchedulerTick, [], _interval] call CBA_fnc_waitAndExecute;

true
