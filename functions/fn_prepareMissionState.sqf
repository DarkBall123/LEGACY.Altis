/*
 * DZ_fnc_prepareMissionState
 * Sets active mission state for a specific side before that side's
 * mission spawns its assets. Wave 4: every state field lives in the
 * per-side bucket; the context side is set so synchronous startup
 * code (and any zero-arg addMissionAssets calls) hit the right slot.
 */

params [
    ["_missionId",  "",            [""]],
    ["_source",     "manual",      [""]],
    ["_definition", createHashMap, [createHashMap]],
    ["_side",       sideUnknown]
];

if (!isServer) exitWith { false };
if (_missionId == "") exitWith { false };

call DZ_fnc_initMissionSystem;

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_side in _playerSides) exitWith {
    diag_log format ["[DZ_PREPARE] Refusing to prepare '%1' for non-player side %2.", _missionId, _side];
    false
};

private _title = _definition getOrDefault ["title", _missionId];

private _state = [_side] call DZ_fnc_missionStateOf;
_state set ["active",     true];
_state set ["id",         _missionId];
_state set ["title",      _title];
_state set ["source",     _source];
_state set ["startTime",  time];
_state set ["units",      []];
_state set ["vehicles",   []];
_state set ["markers",    []];
_state set ["pfhHandles", []];
_state set ["side",       _side];

missionNamespace setVariable ["DZ_missionContextSide", _side, true];

missionNamespace setVariable ["DZ_missionStartedBySide", _side, true];

[_side] call DZ_fnc_missionSyncLegacyGlobals;

["DZ_missionStarted", [_missionId, _source, _title, _side]] call CBA_fnc_localEvent;

true
