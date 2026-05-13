/*
 * DZ_fnc_initAbandonedVehicleCleanup
 *
 * Run once on server init. Sets up a periodic check that:
 *   1. Looks at every vehicle tagged with DZ_trackAbandoned = true
 *   2. Tracks how long since any player was inside or within 30m
 *   3. Deletes vehicles that have been "abandoned" for too long
 *
 * To register a vehicle for this system, set in its init or after spawn:
 *     _vehicle setVariable ["DZ_trackAbandoned", true, true];
 *
 * To EXEMPT a specific vehicle from cleanup (e.g. base ambient vehicles
 * placed in Eden), set in its init field:
 *     this setVariable ["DZ_noCleanup", true, true];
 *
 * Or ignore the system entirely for a vehicle by simply not tagging it
 * (only tagged vehicles are tracked).
 */

if (!isServer) exitWith {};

if (missionNamespace getVariable ["DZ_abandonedVehicleInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_abandonedVehicleInitDone", true];

private _enabled = missionNamespace getVariable ["DZ_abandonedVehicleEnabled", true];
if (!_enabled) exitWith {
    diag_log "[ABANDONED_VEHICLE] System disabled, skipping init.";
};

private _timeout       = missionNamespace getVariable ["DZ_abandonedVehicleTimeout", 900];
private _checkInterval = missionNamespace getVariable ["DZ_abandonedVehicleCheckInterval", 60];

diag_log format ["[ABANDONED_VEHICLE] System enabled. Timeout: %1s, Check interval: %2s",
    _timeout, _checkInterval];

[
    {
        params ["_args", "_handle"];
        _args params ["_timeout"];

        private _now = time;
        private _proximityRadius = 30;

        // Find all candidate vehicles
        private _allVehicles = vehicles select {
            !isNull _x &&
            { _x getVariable ["DZ_trackAbandoned", false] } &&
            { !(_x getVariable ["DZ_noCleanup", false]) } &&
            { alive _x }
        };

        {
            private _veh = _x;
            private _hasOccupant = (count (crew _veh)) > 0 && {
                {
                    if (alive _x) exitWith { true };
                    false
                } forEach (crew _veh)
            };

            // Player nearby check (any player within proximityRadius)
            private _playerNearby = false;
            if (!_hasOccupant) then
            {
                {
                    if (alive _x && { _x distance _veh < _proximityRadius }) exitWith
                    {
                        _playerNearby = true;
                    };
                } forEach allPlayers;
            };

            if (_hasOccupant || _playerNearby) then
            {
                // Mark as "in use" — reset abandon timer
                _veh setVariable ["DZ_lastUsed", _now];
            }
            else
            {
                private _lastUsed = _veh getVariable ["DZ_lastUsed", _now];
                if ((_now - _lastUsed) >= _timeout) then
                {
                    diag_log format ["[ABANDONED_VEHICLE] Cleaning up %1 (idle for %2s) at %3",
                        typeOf _veh, round (_now - _lastUsed), getPosATL _veh];
                    deleteVehicle _veh;
                };
            };
        } forEach _allVehicles;
    },
    _checkInterval,
    [_timeout]
] call CBA_fnc_addPerFrameHandler;
