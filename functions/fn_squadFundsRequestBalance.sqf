/*
 * DZ_fnc_squadFundsRequestBalance
 *
 * Server-side. Sends the current squad funds balance to the calling
 * player as a hint.
 */

if (!isServer) exitWith {};

params [["_caller", objNull, [objNull]]];
private _replyTarget = if (isNull _caller) then {0} else {owner _caller};

private _balance = missionNamespace getVariable ["DZ_squadFundsBalance", 0];

[
    "Бюджет отряда",
    format ["Текущий баланс: %1₽.", _balance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
