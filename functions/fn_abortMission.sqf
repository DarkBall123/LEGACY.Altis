/*
 * DZ_fnc_abortMission
 * Server-side handler for manual mission abort from the HQ laptop.
 * Tears down the active mission via DZ_fnc_endMission with the
 * "cancelled" result (no funds/reputation reward, all spawned units,
 * vehicles, markers and PFH handlers are cleaned up the same way
 * a failure or success would clean them up).
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
    ["Штаб", "Нет активной миссии для отмены."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _missionId    = missionNamespace getVariable ["DZ_missionCurrentId", ""];
private _missionTitle = missionNamespace getVariable ["DZ_missionCurrentTitle", _missionId];

diag_log format ["[DZ_ABORT] Mission '%1' aborted by %2 (uid=%3)",
    _missionId, name _caller, getPlayerUID _caller];

["cancelled"] call DZ_fnc_endMission;

[
    format ["Миссия '%1' прервана по запросу %2.", _missionTitle, name _caller],
    east
] remoteExecCall ["DZ_fnc_sideMessage", 0];

true
