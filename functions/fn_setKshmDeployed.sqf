/*
 * DZ_fnc_setKshmDeployed
 * Deploys or undeploys a KShM vehicle as a mobile respawn position.
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_caller", objNull, [objNull]],
    ["_deploy", false, [false]]
];

if (!isServer) exitWith {};
if (isNull _vehicle || {isNull _caller}) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

// KSHM is APD-exclusive: only west-side callers may deploy/retract.
if !((side _caller) isEqualTo west) exitWith {
    ["КШМ", "КШМ доступна только бойцам APD."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if ((_caller distance _vehicle) > 20) exitWith {
    ["КШМ", "Вы слишком далеко от машины."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (_deploy) then {
    if (_vehicle getVariable ["kshm_deployed", false]) exitWith {
        ["КШМ", "КШМ уже развернута."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    };

    if (abs (speed _vehicle) > 2) exitWith {
        ["КШМ", "Остановите машину перед развертыванием."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    };

    private _respawnId = [west, _vehicle, "Мобильный штаб APD"] call BIS_fnc_addRespawnPosition;
    _vehicle setVariable ["respawn_id", _respawnId, true];
    _vehicle setVariable ["kshm_deployed", true, true];
    missionNamespace setVariable ["DZ_assetsDirty", true];
    [true] call DZ_fnc_saveAssets;

    ["КШМ", "КШМ развернута. Точка возрождения активна."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    ["КШМ развернута. APD получает мобильную точку возрождения.", west] remoteExecCall ["DZ_fnc_sideMessage", 0];
} else {
    if !(_vehicle getVariable ["kshm_deployed", false]) exitWith {
        ["КШМ", "КШМ не развернута."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    };

    private _respawnId = _vehicle getVariable ["respawn_id", []];
    if (_respawnId isNotEqualTo []) then {
        _respawnId call BIS_fnc_removeRespawnPosition;
    };

    _vehicle setVariable ["respawn_id", [], true];
    _vehicle setVariable ["kshm_deployed", false, true];
    missionNamespace setVariable ["DZ_assetsDirty", true];
    [true] call DZ_fnc_saveAssets;

    ["КШМ", "КШМ свернута."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    ["КШМ свернута. Мобильная точка возрождения APD отключена.", west] remoteExecCall ["DZ_fnc_sideMessage", 0];
};
