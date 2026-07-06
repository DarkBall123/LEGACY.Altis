/*
 * DZ_fnc_endMission
 * Ends the active mission for a specific side, updates cooldowns,
 * notifies listeners, and schedules cleanup of THAT side's assets.
 *
 * Side resolution: if `_side` is sideUnknown, falls back to
 * DZ_missionContextSide (set during synchronous start/PFH code),
 * then to the first active side. If still nothing, the call is a
 * no-op.
 */

params [
    ["_result", "cancelled", [""]],
    ["_side",   sideUnknown]
];

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

if (_side isEqualTo sideUnknown) then {
    _side = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
};
if (_side isEqualTo sideUnknown) then {
    private _active = call DZ_fnc_missionActiveSides;
    if (_active isNotEqualTo []) then { _side = _active # 0 };
};

if (_side isEqualTo sideUnknown) exitWith {
    diag_log "[DZ_END] No side resolvable for endMission — no-op.";
    false
};

private _state = [_side] call DZ_fnc_missionStateOf;
if !(_state get "active") exitWith {
    diag_log format ["[DZ_END] Side %1 has no active mission — no-op.", _side];
    false
};

private _factionLabel  = [_side] call DZ_fnc_missionSideLabel;
private _missionId     = _state get "id";
private _missionTitle  = _state get "title";
private _missionSource = _state get "source";

{
    [_x] call CBA_fnc_removePerFrameHandler;
} forEach (_state get "pfhHandles");

private _unitsToClean    = +(_state get "units");
private _vehiclesToClean = +(_state get "vehicles");
private _markersToClean  = +(_state get "markers");

if (_missionId != "") then
{
    private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
    _cooldowns set [_missionId, time];
    missionNamespace setVariable ["DZ_missionCooldowns", _cooldowns];
};

["DZ_missionEnded", [_missionId, _result, _missionSource, _missionTitle, _side]] call CBA_fnc_localEvent;

_state set ["active",     false];
_state set ["id",         ""];
_state set ["title",      ""];
_state set ["source",     ""];
_state set ["startTime",  0];
_state set ["units",      []];
_state set ["markers",    []];
_state set ["vehicles",   []];
_state set ["pfhHandles", []];

private _outerStates = missionNamespace getVariable ["DZ_missionStates", createHashMap];
_outerStates set [str _side, [_side] call DZ_fnc_missionEmptyState];
missionNamespace setVariable ["DZ_missionStates", _outerStates];

diag_log format ["[DZ_END:trace] side=%1 cleared. activeAfter=%2",
    _side, (_outerStates getOrDefault [str _side, createHashMap]) get "active"];

if !(call DZ_fnc_missionAnySideActive) then {
    missionNamespace setVariable ["DZ_missionStartedBySide", sideUnknown, true];
};

[] call DZ_fnc_missionSyncLegacyGlobals;

private _message = switch (_result) do
{
    case "success":   { "Миссия выполнена успешно. Хорошая работа." };
    case "failure":   { "Миссия провалена." };
    case "cancelled": { "Миссия завершена досрочно." };
    default           { "Миссия завершена." };
};

[
    format ["[%1] %2", _factionLabel, _message],
    _side
] remoteExecCall ["DZ_fnc_sideMessage", 0];

private _cleanupDelay = missionNamespace getVariable ["DZ_missionCleanupDelay", 300];

if (_result == "cancelled") then
{
    {
        deleteMarker _x;
    } forEach _markersToClean;

    _markersToClean = [];
    _cleanupDelay = missionNamespace getVariable ["DZ_missionCancelledCleanupDelay", 5];
};

[
    {
        params ["_unitsToClean", "_vehiclesToClean", "_markersToClean"];

        {
            if (!isNull _x && { alive _x }) then
            {
                deleteVehicle _x;
            };
        } forEach _unitsToClean;

        {
            if (!isNull _x && { alive _x }) then
            {
                {
                    if (alive _x) then { deleteVehicle _x; };
                } forEach (crew _x);
                deleteVehicle _x;
            };
        } forEach _vehiclesToClean;

        {
            deleteMarker _x;
        } forEach _markersToClean;
    },
    [_unitsToClean, _vehiclesToClean, _markersToClean],
    _cleanupDelay
] call CBA_fnc_waitAndExecute;

diag_log format ["[DZ_END:%1] Mission '%2' ended (result=%3, source=%4).",
    _factionLabel, _missionId, _result, _missionSource];

true
