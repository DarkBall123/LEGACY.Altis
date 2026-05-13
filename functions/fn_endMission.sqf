/*
 * DZ_fnc_endMission
 *
 * End the active mission. SERVER ONLY.
 *
 *     ["success" | "failure" | "cancelled"] call DZ_fnc_endMission;
 *
 * Per SECTOR_CONTROL.md:
 *   - Dead bodies and destroyed vehicles are NOT removed.
 *   - Only LIVING units/vehicles get cleaned up.
 *   - Cleanup is delayed by DZ_missionCleanupDelay seconds (5 min default)
 *     so the immediate aftermath of a mission feels persistent.
 *
 * Mission state, markers, PFH handles, and cooldowns are all reset
 * immediately. Only physical asset cleanup is delayed.
 */

params [["_result", "cancelled", [""]]];

if (!isServer) exitWith { false };

private _missionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
private _missionTitle = missionNamespace getVariable ["DZ_missionCurrentTitle", _missionId];
private _missionSource = missionNamespace getVariable ["DZ_missionSource", ""];

// ── Stop tracking PFHs immediately ───────────────────────
private _pfhHandles = missionNamespace getVariable ["DZ_missionPfhHandles", []];
{
    [_x] call CBA_fnc_removePerFrameHandler;
} forEach _pfhHandles;

// ── Snapshot the assets we'll clean up later ─────────────
// Take a copy now because the missionNamespace arrays get cleared below
// for the next mission's lifecycle.
private _unitsToClean    = +(missionNamespace getVariable ["DZ_missionUnits",    []]);
private _vehiclesToClean = +(missionNamespace getVariable ["DZ_missionVehicles", []]);
private _markersToClean  = +(missionNamespace getVariable ["DZ_missionMarkers",  []]);

// ── Cooldown bookkeeping ─────────────────────────────────
if (_missionId != "") then
{
    private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
    _cooldowns set [_missionId, time];
    missionNamespace setVariable ["DZ_missionCooldowns", _cooldowns];
};

// ── Fire the mission-ended event for any listeners ───────
["DZ_missionEnded", [_missionId, _result, _missionSource, _missionTitle]] call CBA_fnc_localEvent;

// ── Clear active-mission state immediately ───────────────
// This lets a new mission be started right away — only the physical
// cleanup is delayed, not the mission-availability state.
missionNamespace setVariable ["DZ_missionActive", false, true];
missionNamespace setVariable ["DZ_missionCurrentId", "", true];
missionNamespace setVariable ["DZ_missionCurrentTitle", "", true];
missionNamespace setVariable ["DZ_missionSource", "", true];
missionNamespace setVariable ["DZ_missionStartTime", 0, true];
missionNamespace setVariable ["DZ_missionUnits", []];
missionNamespace setVariable ["DZ_missionMarkers", []];
missionNamespace setVariable ["DZ_missionVehicles", []];
missionNamespace setVariable ["DZ_missionPfhHandles", []];

// ── Player-facing summary ────────────────────────────────
private _message = switch (_result) do
{
    case "success": { "Миссия выполнена успешно. Хорошая работа." };
    case "failure": { "Миссия провалена." };
    default { "Миссия завершена досрочно." };
};

["hint", "Штаб", _message] call DZ_fnc_missionUi;

// ── Schedule delayed cleanup of LIVING assets ────────────
// Wrecks and bodies are intentionally left alone (per SECTOR_CONTROL spec).
// We only clear out things that are still alive — typically a convoy
// truck that escaped, escort infantry that are still wandering, etc.
private _cleanupDelay = missionNamespace getVariable ["DZ_missionCleanupDelay", 300];

[
    {
        params ["_unitsToClean", "_vehiclesToClean", "_markersToClean"];

        {
            // Only delete if still alive — leave bodies for persistence
            if (!isNull _x && { alive _x }) then
            {
                deleteVehicle _x;
            };
        } forEach _unitsToClean;

        {
            // Only delete if still alive — leave wrecks for persistence
            if (!isNull _x && { alive _x }) then
            {
                // Eject any living crew first so they don't vanish with the vehicle
                {
                    if (alive _x) then { deleteVehicle _x; };
                } forEach (crew _x);
                deleteVehicle _x;
            };
        } forEach _vehiclesToClean;

        // Markers can be cleared with cleanup — they're not "physical"
        {
            deleteMarker _x;
        } forEach _markersToClean;
    },
    [_unitsToClean, _vehiclesToClean, _markersToClean],
    _cleanupDelay
] call CBA_fnc_waitAndExecute;

true
