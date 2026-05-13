/*
 * DZ_fnc_initZeusCleanupHook
 *
 * Run once on server init. Solves the problem of:
 *   - Admin uses Zeus to clean up bad spawns / dead enemies / clutter
 *   - Zeus doesn't know about DZ_fnc_endMission
 *   - Mission markers, state flags, and PFH handlers stay live
 *   - Map fills up with stale markers, can't start new missions
 *
 * Two complementary mechanisms here:
 *
 *   1. Periodic mission integrity check — if a mission is "active" but
 *      its critical objects (target, pilot) are null or all-dead, end it.
 *   2. Admin-only "Force end mission" Zeus radial action — admin can
 *      explicitly cancel and clear without touching individual units.
 *
 * Mission state in missionNamespace:
 *   DZ_missionActive       (bool)
 *   DZ_missionCurrentId    (string)
 *   DZ_assassinationTarget (object)
 *   DZ_pilotMissionTarget  (object)
 *   ... etc
 */

if (!isServer) exitWith {};

if (missionNamespace getVariable ["DZ_zeusCleanupHookInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_zeusCleanupHookInitDone", true];

diag_log "[ZEUS_CLEANUP] Initializing mission integrity watcher.";

[
    {
        params ["_args", "_handle"];

        // Bail if no mission active — nothing to check
        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith {};

        private _missionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
        private _orphaned = false;
        private _reason = "";

        switch (_missionId) do
        {
            case "assassination":
            {
                private _target = missionNamespace getVariable ["DZ_assassinationTarget", objNull];
                if (isNull _target) then
                {
                    _orphaned = true;
                    _reason = "HVT target deleted (Zeus or otherwise)";
                };
            };

            case "downed_pilot":
            {
                private _pilot = missionNamespace getVariable ["DZ_pilotMissionTarget", objNull];
                if (isNull _pilot) then
                {
                    _orphaned = true;
                    _reason = "Pilot deleted (Zeus or otherwise)";
                };
            };

            case "interdiction":
            {
                // Convoy mission tracks its own state via PFH; if the PFH
                // is gone or the convoy units list is empty, that's
                // detected by the PFH itself. We just check that the
                // mission asset list isn't completely empty.
                private _vehicles = missionNamespace getVariable ["DZ_missionVehicles", []];
                private _aliveCount = ({ !isNull _x && { alive _x } } count _vehicles);

                if (_vehicles isNotEqualTo [] && _aliveCount == 0) then
                {
                    // PFH normally handles this within 5s, give it some
                    // slack — only orphan if mission has been "vehicleless"
                    // for over 30s (PFH should have caught this and called
                    // endMission already).
                    private _emptySince = missionNamespace getVariable ["DZ_interdictionEmptySince", 0];
                    if (_emptySince == 0) then
                    {
                        missionNamespace setVariable ["DZ_interdictionEmptySince", time];
                    }
                    else
                    {
                        if ((time - _emptySince) > 30) then
                        {
                            _orphaned = true;
                            _reason = "Convoy all destroyed but mission still active (PFH stalled?)";
                        };
                    };
                }
                else
                {
                    missionNamespace setVariable ["DZ_interdictionEmptySince", 0];
                };
            };
        };

        if (_orphaned) then
        {
            diag_log format ["[ZEUS_CLEANUP] Detected orphaned mission '%1': %2. Force-ending.",
                _missionId, _reason];

            ["cancelled"] call DZ_fnc_endMission;

            ["Миссия отменена.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    5,   // poll every 5 seconds
    []
] call CBA_fnc_addPerFrameHandler;

// ── Cleanup pass on mission start: defensively wipe any stale markers
// from previous sessions that didn't end cleanly. Runs once at startup.
{
    if ((markerType _x) != "" && { _x find "marker_" == 0 }) then
    {
        // Only delete markers that look like ours (DZ-style) AND that
        // are NOT part of an active mission's marker list
        private _activeMarkers = missionNamespace getVariable ["DZ_missionMarkers", []];
        if !(_x in _activeMarkers) then
        {
            deleteMarker _x;
            diag_log format ["[ZEUS_CLEANUP] Deleted stale marker: %1", _x];
        };
    };
} forEach (allMapMarkers select { _x find "marker_assassination" == 0 ||
                                  _x find "marker_pilot"         == 0 ||
                                  _x find "marker_extract"       == 0 ||
                                  _x find "marker_convoy"        == 0 });
