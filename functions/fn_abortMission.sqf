/*
 * DZ_fnc_abortMission
 * Server-side handler for manual mission abort from a side's laptop.
 * Tears down THAT side's active mission via DZ_fnc_endMission with
 * the "cancelled" result. The other side's concurrent mission is
 * untouched.
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

call DZ_fnc_initMissionSystem;

private _side = [_caller] call DZ_fnc_missionSideOfPlayer;
if (_side isEqualTo sideUnknown) exitWith {
    ["Штаб", "Эта сторона не имеет штаба."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _factionLabel = [_side] call DZ_fnc_missionSideLabel;

if !([_side] call DZ_fnc_missionActiveForSide) exitWith {
    [
        "Штаб",
        format ["У %1 нет активной миссии для отмены.", _factionLabel]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _state         = [_side] call DZ_fnc_missionStateOf;
private _missionId     = _state get "id";
private _missionTitle  = _state get "title";

diag_log format ["[DZ_ABORT:%1] Mission '%2' aborted by %3 (uid=%4)",
    _factionLabel, _missionId, name _caller, getPlayerUID _caller];

["cancelled", _side] call DZ_fnc_endMission;

[
    format ["[%1] Миссия '%2' прервана по запросу %3.",
        _factionLabel, _missionTitle, name _caller],
    _side
] remoteExecCall ["DZ_fnc_sideMessage", 0];

true
