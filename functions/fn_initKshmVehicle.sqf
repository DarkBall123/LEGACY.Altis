/*
 * DZ_fnc_initKshmVehicle
 * Adds ACE actions for deploying a KShM vehicle as a mobile respawn point.
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith { false };

if (isServer) then
{
    _vehicle setVariable ["respawn_id", [], true];
    _vehicle setVariable ["kshm_deployed", false, true];

    if !(_vehicle getVariable ["kshm_killedEh", false]) then
    {
        _vehicle setVariable ["kshm_killedEh", true, true];
        _vehicle addEventHandler
        [
            "Killed",
            {
                params ["_vehicle"];

                private _respawnId = _vehicle getVariable ["respawn_id", []];
                if (_respawnId isNotEqualTo []) then
                {
                    _respawnId call BIS_fnc_removeRespawnPosition;
                };

                _vehicle setVariable ["respawn_id", [], true];
                _vehicle setVariable ["kshm_deployed", false, true];
            }
        ];
    };
};

if (!hasInterface) exitWith { true };
if (_vehicle getVariable ["kshm_actions_added", false]) exitWith { true };

_vehicle setVariable ["kshm_actions_added", true, false];

// KSHM is an APD-exclusive (west) asset — Free Altis insurgents see no actions.
_vehicle addAction
[
    "Развернуть КШМ",
    {
        params ["_target", "_caller"];

        [_target, _caller, true] remoteExecCall ["DZ_fnc_setKshmDeployed", 2];
    },
    nil,
    1,
    false,
    false,
    "",
    "(side _this == west) && {!(_target getVariable ['kshm_deployed', false])}"
];

_vehicle addAction
[
    "Свернуть КШМ",
    {
        params ["_target", "_caller"];

        [_target, _caller, false] remoteExecCall ["DZ_fnc_setKshmDeployed", 2];
    },
    nil,
    1,
    false,
    false,
    "",
    "(side _this == west) && {(_target getVariable ['kshm_deployed', false])}"
];

true
