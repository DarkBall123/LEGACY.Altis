/*
 * DZ_fnc_initAbandonedVehicleCleanup
 * Starts cleanup for abandoned mission-spawned transport vehicles.
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

                _veh setVariable ["DZ_lastUsed", _now];
            }
            else
            {
                private _lastUsed = _veh getVariable ["DZ_lastUsed", _now];
                if ((_now - _lastUsed) >= _timeout) then
                {
                    diag_log format ["[ABANDONED_VEHICLE] Cleaning up %1 (idle for %2s) at %3",
                        typeOf _veh, round (_now - _lastUsed), getPosATL _veh];
                    if (_veh getVariable ["DZ_persist", false]) then
                    {
                        missionNamespace setVariable ["DZ_assetsDirty", true];
                    };
                    deleteVehicle _veh;
                };
            };
        } forEach _allVehicles;
    },
    _checkInterval,
    [_timeout]
] call CBA_fnc_addPerFrameHandler;
