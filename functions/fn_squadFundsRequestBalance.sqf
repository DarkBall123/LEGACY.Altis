/*
 * DZ_fnc_squadFundsRequestBalance
 * Sends the current squad funds balance to the requesting player.
 */

if (!isServer) exitWith {};

params [["_caller", objNull, [objNull]]];
if (isNull _caller || { !isPlayer _caller }) exitWith {};
if (!isNil "remoteExecutedOwner" && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

private _balance = missionNamespace getVariable ["DZ_squadFundsBalance", 0];

[
    "Бюджет отряда",
    format ["Текущий баланс: %1₽.", _balance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
