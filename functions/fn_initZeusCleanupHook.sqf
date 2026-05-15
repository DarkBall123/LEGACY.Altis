/*
 * DZ_fnc_initZeusCleanupHook
 * Starts defensive mission cleanup checks for Zeus-deleted assets and stale markers.
 */

if (!isServer) exitWith {};

if (missionNamespace getVariable ["DZ_zeusCleanupHookInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_zeusCleanupHookInitDone", true];

diag_log "[ZEUS_CLEANUP] Initializing mission integrity watcher.";

[
    {
        params ["_args", "_handle"];


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


                private _vehicles = missionNamespace getVariable ["DZ_missionVehicles", []];
                private _aliveCount = ({ !isNull _x && { alive _x } } count _vehicles);

                if (_vehicles isNotEqualTo [] && _aliveCount == 0) then
                {


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
    5,
    []
] call CBA_fnc_addPerFrameHandler;


{
    if ((markerType _x) != "" && { _x find "marker_" == 0 }) then
    {


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
