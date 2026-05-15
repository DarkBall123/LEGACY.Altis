/*
 * DZ_fnc_squadFundsRequestBalance
 * Sends the current squad funds balance to the requesting player.
 */

if (!isServer) exitWith {};

params [["_caller", objNull, [objNull]]];
private _replyTarget = [owner _caller, 0] select (isNull _caller);

private _balance = missionNamespace getVariable ["DZ_squadFundsBalance", 0];

[
    "Бюджет отряда",
    format ["Текущий баланс: %1₽.", _balance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
