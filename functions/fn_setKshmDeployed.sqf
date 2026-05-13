params [
    ["_vehicle", objNull, [objNull]],
    ["_caller", objNull, [objNull]],
    ["_deploy", false, [false]]
];

if (!isServer) exitWith {};
if (isNull _vehicle || {isNull _caller}) exitWith {};
if (!isNil "remoteExecutedOwner" && {owner _caller != remoteExecutedOwner}) exitWith {};

private _replyTarget = owner _caller;

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

    private _respawnId = [east, _vehicle, "Мобильный штаб"] call BIS_fnc_addRespawnPosition;
    _vehicle setVariable ["respawn_id", _respawnId, true];
    _vehicle setVariable ["kshm_deployed", true, true];

    ["КШМ", "КШМ развернута. Точка возрождения активна."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    ["КШМ развернута. Доступна мобильная точка возрождения.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
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

    ["КШМ", "КШМ свернута."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    ["КШМ свернута. Мобильная точка возрождения отключена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
};
