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

// ── Resolve which side's mission we are ending ───────────────────────
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

// ── Remove PFH handlers for THIS side only ────────────────────────────
{
    [_x] call CBA_fnc_removePerFrameHandler;
} forEach (_state get "pfhHandles");

// ── Snapshot side-bucket assets for delayed cleanup ───────────────────
private _unitsToClean    = +(_state get "units");
private _vehiclesToClean = +(_state get "vehicles");
private _markersToClean  = +(_state get "markers");

// ── Cooldown is global (same mission can't run on both sides back-to-back) ──
if (_missionId != "") then
{
    private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
    _cooldowns set [_missionId, time];
    missionNamespace setVariable ["DZ_missionCooldowns", _cooldowns];
};

// ── Fire missionEnded BEFORE wiping state so listeners see truth ──────
//   Signature kept as (id, result, source, title) for back-compat;
//   side is broadcast separately via DZ_missionStartedBySide which
//   the reward handlers already read. We also pass _side as a 5th
//   arg for listeners that want it.
["DZ_missionEnded", [_missionId, _result, _missionSource, _missionTitle, _side]] call CBA_fnc_localEvent;

// ── Clear side-bucket state ──────────────────────────────────────────
_state set ["active",     false];
_state set ["id",         ""];
_state set ["title",      ""];
_state set ["source",     ""];
_state set ["startTime",  0];
_state set ["units",      []];
_state set ["markers",    []];
_state set ["vehicles",   []];
_state set ["pfhHandles", []];

// Mission-started-by-side cleared if no other side is still mid-mission.
if !(call DZ_fnc_missionAnySideActive) then {
    missionNamespace setVariable ["DZ_missionStartedBySide", sideUnknown, true];
};

// Update legacy globals (point at remaining active side, or blank).
[] call DZ_fnc_missionSyncLegacyGlobals;

// ── Player-facing notification (own side only) ───────────────────────
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

// ── Cleanup schedule ─────────────────────────────────────────────────
private _cleanupDelay = missionNamespace getVariable ["DZ_missionCleanupDelay", 300];

// Cancelled missions: wipe markers now so re-pick of same mission doesn't stack.
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
