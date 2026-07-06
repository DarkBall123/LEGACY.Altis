/*
 * DZ_fnc_initZeusCleanupHook
 * Starts defensive mission cleanup checks for Zeus-deleted assets and
 * stale markers.
 *
 * Per-side (Wave 4): each player faction's active mission is checked
 * independently. If either side's mission becomes orphaned (Zeus-
 * deleted target/vehicle), only that side's mission is force-ended;
 * the other side's contract continues unaffected.
 */

if (!isServer) exitWith {};

if (missionNamespace getVariable ["DZ_zeusCleanupHookInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_zeusCleanupHookInitDone", true];

diag_log "[ZEUS_CLEANUP] Initializing mission integrity watcher.";

[
    {
        params ["_args", "_handle"];

        call DZ_fnc_initMissionSystem;
        private _activeSides = call DZ_fnc_missionActiveSides;
        if (_activeSides isEqualTo []) exitWith {};

        {
            private _side    = _x;
            private _state   = [_side] call DZ_fnc_missionStateOf;
            private _missionId = _state get "id";
            private _orphaned  = false;
            private _reason    = "";

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

                    private _vehicles = _state get "vehicles";
                    private _aliveCount = ({ !isNull _x && { alive _x } } count _vehicles);

                    if (_vehicles isNotEqualTo [] && _aliveCount == 0) then
                    {
                        private _key = format ["DZ_interdictionEmptySince_%1", str _side];
                        private _emptySince = missionNamespace getVariable [_key, 0];
                        if (_emptySince == 0) then
                        {
                            missionNamespace setVariable [_key, time];
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
                        missionNamespace setVariable [format ["DZ_interdictionEmptySince_%1", str _side], 0];
                    };
                };
            };

            if (_orphaned) then
            {
                private _factionLabel = [_side] call DZ_fnc_missionSideLabel;
                diag_log format ["[ZEUS_CLEANUP:%1] Detected orphaned mission '%2': %3. Force-ending.",
                    _factionLabel, _missionId, _reason];

                ["cancelled", _side] call DZ_fnc_endMission;

                [
                    format ["[%1] Миссия отменена.", _factionLabel],
                    _side
                ] remoteExecCall ["DZ_fnc_sideMessage", 0];
            };
        } forEach _activeSides;
    },
    5,
    []
] call CBA_fnc_addPerFrameHandler;

{
    if ((markerType _x) != "" && { _x find "marker_" == 0 }) then
    {
        private _allActiveMarkers = [];
        {
            private _state = [_x] call DZ_fnc_missionStateOf;
            _allActiveMarkers append (_state get "markers");
        } forEach (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]);

        if !(_x in _allActiveMarkers) then
        {
            deleteMarker _x;
            diag_log format ["[ZEUS_CLEANUP] Deleted stale marker: %1", _x];
        };
    };
} forEach (allMapMarkers select { _x find "marker_assassination" == 0 ||
                                  _x find "marker_pilot"         == 0 ||
                                  _x find "marker_extract"       == 0 ||
                                  _x find "marker_convoy"        == 0 });
