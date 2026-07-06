/*
 * DZ_fnc_requestFobMission
 * Server-side handler for the FOB "high-risk contract" laptop.
 * The FOB is a Free Altis asset — the contract is forced to the
 * resistance side, so the doubled reward (DZ_fobRewardMultiplier)
 * lands in the Free Altis wallet.
 *
 * If a player from another faction operates the laptop somehow
 * (e.g. captured), it still resolves to resistance — the laptop is
 * resistance-gated in `fn_initFobLaptop.sqf` as an extra layer.
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

call DZ_fnc_initMissionSystem;

private _side         = east;
private _factionLabel = [_side] call DZ_fnc_missionSideLabel;

if ([_side] call DZ_fnc_missionActiveForSide) exitWith {
    [
        "Передовая база",
        format ["У %1 уже есть активная миссия. Дождитесь её завершения.", _factionLabel]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _started = ["fob", _side] call DZ_fnc_startRandomMission;

if !(_started) exitWith {
    ["Передовая база", "Нет доступных контрактов. Попробуйте позже."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _mult = missionNamespace getVariable ["DZ_fobRewardMultiplier", 2];
[
    format ["[%1] Контракт с передовой базы принят. Награда увеличена в %2 раза.",
        _factionLabel, _mult],
    _side
] remoteExecCall ["DZ_fnc_sideMessage", 0];

diag_log format ["[DZ_FOB] Contract requested by %1 (uid=%2, side=%3)",
    name _caller, getPlayerUID _caller, _factionLabel];

true
