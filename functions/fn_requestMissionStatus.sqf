params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (!isNil "remoteExecutedOwner" && {owner _caller != remoteExecutedOwner}) exitWith {};

private _replyTarget = owner _caller;

call DZ_fnc_initMissionSystem;

if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
    ["Штаб", "Нет активной миссии."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _missionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
private _missionTitle = missionNamespace getVariable ["DZ_missionCurrentTitle", _missionId];
private _missionSource = missionNamespace getVariable ["DZ_missionSource", "manual"];
private _startTime = missionNamespace getVariable ["DZ_missionStartTime", time];

[
    "Штаб",
    format [
        "Активная миссия: %1\nИсточник: %2\nПродолжительность: %3 мин",
        _missionTitle,
        _missionSource,
        floor ((time - _startTime) / 60)
    ]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
