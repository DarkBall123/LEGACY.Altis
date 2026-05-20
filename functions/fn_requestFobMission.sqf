/*
 * DZ_fnc_requestFobMission
 * Server-side handler for the FOB "high-risk contract" laptop.
 * Starts a random eligible mission with source "fob" so the reward
 * handlers pay the doubled (DZ_fobRewardMultiplier) reward on success.
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

call DZ_fnc_initMissionSystem;

if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
    ["ОО Штаб", "Миссия уже активна. Дождитесь её завершения."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _started = ["fob"] call DZ_fnc_startRandomMission;

if !(_started) exitWith {
    ["ОО Штаб", "Нет доступных контрактов. Попробуйте позже."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _mult = missionNamespace getVariable ["DZ_fobRewardMultiplier", 2];
[
    format ["Контракт с передовой базы принят. Награда увеличена в %1 раза.", _mult],
    east
] remoteExecCall ["DZ_fnc_sideMessage", 0];

diag_log format ["[DZ_FOB] Contract requested by %1 (uid=%2)", name _caller, getPlayerUID _caller];

true
