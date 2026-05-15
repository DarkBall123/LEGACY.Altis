/*
 * DZ_fnc_startMission
 * Validates and dispatches a manual or automatic mission start request.
 */

params [
    ["_missionId", "", [""]],
    ["_caller", objNull, [objNull]],
    ["_source", "manual", [""]]
];

if (!isServer) exitWith {};

private _replyTarget = [owner _caller, 0] select (isNull _caller);

diag_log format ["[DZ_START] %1 by %2 (source=%3)", _missionId, _caller, _source];

call DZ_fnc_initMissionSystem;

private _definition = [_missionId] call DZ_fnc_getMissionDefinition;

if ((count _definition) == 0) exitWith {
    diag_log format ["[DZ_START] EXIT: empty definition for %1", _missionId];
    ["Штаб", "Неизвестный тип миссии."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
    diag_log "[DZ_START] EXIT: mission already active";
    ["Штаб", "Миссия уже активна."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _manualEnabled = _definition getOrDefault ["manualEnabled", false];
private _randomEnabled = _definition getOrDefault ["randomEnabled", false];
private _implemented = _definition getOrDefault ["implemented", false];

if (_source == "manual" && { !_manualEnabled }) exitWith {
    diag_log "[DZ_START] EXIT: not manualEnabled";
    ["Штаб", "Эта миссия недоступна для ручного запуска."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (_source == "auto" && { !_randomEnabled }) exitWith { false };

if (!_implemented) exitWith {
    diag_log "[DZ_START] EXIT: not implemented";
    [
        "Штаб",
        "Эта миссия пока только зарезервирована в меню."
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

[_missionId, _source, _definition] call DZ_fnc_prepareMissionState;

private _title = _definition getOrDefault ["title", _missionId];
["hint", "Штаб", format ["Миссия активирована: %1", _title]] call DZ_fnc_missionUi;

private _startFunction = _definition getOrDefault ["startFunction", ""];
private _startCode = missionNamespace getVariable [_startFunction, {}];

if !(_startCode isEqualType {}) exitWith
{
    diag_log format ["[DZ_START] EXIT: start function '%1' not found", _startFunction];
    ["failure"] call DZ_fnc_endMission;
    false
};

private _started = call _startCode;

if !(_started isEqualTo true) then
{
    if (missionNamespace getVariable ["DZ_missionActive", false]) then
    {
        ["failure"] call DZ_fnc_endMission;
    };
};

_started
