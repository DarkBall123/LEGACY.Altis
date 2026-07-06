/*
 * DZ_fnc_startMission
 * Validates and dispatches a mission start request for a specific
 * side. The side's own slot is checked — the OTHER side's mission
 * is irrelevant. Cooldowns are GLOBAL: the same mission ID can't
 * run on both sides back-to-back.
 *
 * Side resolution order:
 *   1. Explicit `_side` parameter.
 *   2. The caller's faction (DZ_fnc_missionSideOfPlayer).
 *   3. west (legacy default for unattended/auto calls).
 */

params [
    ["_missionId", "",      [""]],
    ["_caller",   objNull,  [objNull]],
    ["_source",   "manual", [""]],
    ["_side",     sideUnknown]
];

if (!isServer) exitWith {};

private _replyTarget = [owner _caller, 0] select (isNull _caller);

call DZ_fnc_initMissionSystem;

if (_side isEqualTo sideUnknown) then {
    _side = [_caller] call DZ_fnc_missionSideOfPlayer;
};
if (_side isEqualTo sideUnknown) then {
    _side = missionNamespace getVariable ["CH_sidePlayers", east];
};

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_side in _playerSides) exitWith {
    diag_log format ["[DZ_START] Side %1 isn't a player side. Refusing %2.", _side, _missionId];
    ["Штаб", "Эта сторона не имеет штаба."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _factionLabel = [_side] call DZ_fnc_missionSideLabel;
diag_log format ["[DZ_START:%1] %2 by %3 (source=%4)", _factionLabel, _missionId, _caller, _source];

private _definition = [_missionId] call DZ_fnc_getMissionDefinition;
if ((count _definition) == 0) exitWith {
    diag_log format ["[DZ_START:%1] EXIT: empty definition for %2", _factionLabel, _missionId];
    ["Штаб", "Неизвестный тип миссии."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if ([_side] call DZ_fnc_missionActiveForSide) exitWith {
    diag_log format ["[DZ_START:%1] EXIT: side already has an active mission", _factionLabel];
    [
        "Штаб",
        format ["У %1 уже идёт активная миссия.", _factionLabel]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _activeSides = call DZ_fnc_missionActiveSides;
private _crossBooked = _activeSides findIf {
    ([_x] call DZ_fnc_missionStateOf) get "id" == _missionId
};
if (_crossBooked >= 0) exitWith {
    diag_log format ["[DZ_START:%1] EXIT: %2 already running on another side", _factionLabel, _missionId];
    [
        "Штаб",
        "Эта миссия уже выполняется другой фракцией. Подождите её завершения."
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _manualEnabled = _definition getOrDefault ["manualEnabled", false];
private _randomEnabled = _definition getOrDefault ["randomEnabled", false];
private _implemented   = _definition getOrDefault ["implemented",   false];

if (_source == "manual" && { !_manualEnabled }) exitWith {
    ["Штаб", "Эта миссия недоступна для ручного запуска."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (_source == "auto" && { !_randomEnabled }) exitWith { false };

if (!_implemented) exitWith {
    [
        "Штаб",
        "Эта миссия пока только зарезервирована в меню."
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

[_missionId, _source, _definition, _side] call DZ_fnc_prepareMissionState;

private _title = _definition getOrDefault ["title", _missionId];
[
    format ["[%1] Миссия активирована: %2", _factionLabel, _title],
    _side
] remoteExecCall ["DZ_fnc_sideMessage", 0];

private _startFunction = _definition getOrDefault ["startFunction", ""];
private _startCode     = missionNamespace getVariable [_startFunction, {}];

if !(_startCode isEqualType {}) exitWith
{
    diag_log format ["[DZ_START:%1] EXIT: start function '%2' not found", _factionLabel, _startFunction];
    ["failure", _side] call DZ_fnc_endMission;
    false
};

missionNamespace setVariable ["DZ_missionContextSide", _side, true];

private _started = call _startCode;

missionNamespace setVariable ["DZ_missionContextSide", sideUnknown, true];

if !(_started isEqualTo true) then
{
    if ([_side] call DZ_fnc_missionActiveForSide) then
    {
        ["failure", _side] call DZ_fnc_endMission;
    };
};

_started
