params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (!isNil "remoteExecutedOwner" && {owner _caller != remoteExecutedOwner}) exitWith {};

private _replyTarget = owner _caller;
private _cooldownSeconds = 600;
private _vehicleClass = "RHS_UAZ_MSV_01";

if !(isClass (configFile >> "CfgVehicles" >> _vehicleClass)) exitWith {
    ["Транспорт", format ["Класс машины не найден: %1", _vehicleClass]] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (isNil "logistics_point" || {isNull logistics_point}) exitWith {
    ["Транспорт", "Нет настроенной точки логистики."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if ((_caller distance logistics_point) > 25) exitWith {
    ["Транспорт", "Запрос доступен только у точки логистики на базе."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _lastRequest = missionNamespace getVariable ["DZ_transportLastRequest", -1e9];
private _elapsed = time - _lastRequest;

if (_elapsed < _cooldownSeconds) exitWith {
    private _remaining = ceil (_cooldownSeconds - _elapsed);
    private _minutes = floor (_remaining / 60);
    private _seconds = _remaining mod 60;
    private _secondsText = if (_seconds < 10) then {format ["0%1", _seconds]} else {str _seconds};
    ["Транспорт", format ["УАЗ еще не готов.\nОжидание: %1:%2", _minutes, _secondsText]] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _spawnObject = logistics_point;
private _spawnPos = getPosATL _spawnObject;
private _freePos = _spawnPos findEmptyPosition [0, 16, _vehicleClass];

if (_freePos isEqualTo []) then {
    _freePos = _spawnObject getRelPos [7, 180];
};

private _blockingVehicles = nearestObjects [_freePos, ["LandVehicle"], 5];
if (_blockingVehicles isNotEqualTo []) exitWith {
    ["Транспорт", "Точка выдачи занята. Освободите место рядом с логистикой."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _vehicle = createVehicle [_vehicleClass, _freePos, [], 0, "NONE"];
if (isNull _vehicle) exitWith {
    ["Транспорт", "Не удалось создать УАЗ."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

_vehicle setDir (getDir _spawnObject);
_vehicle setPosATL _freePos;
_vehicle setFuel 1;
_vehicle setDamage 0;

// ── Register for abandoned-vehicle cleanup ──────────────
// 15-min idle timeout (configured globally via DZ_abandonedVehicleTimeout).
// Gets deleted if nobody enters/approaches it for that long.
_vehicle setVariable ["DZ_trackAbandoned", true, true];
_vehicle setVariable ["DZ_lastUsed", time, true];

missionNamespace setVariable ["DZ_transportLastRequest", time, true];

["Транспорт", "УАЗ готов на точке логистики."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
["УАЗ выдан на базе.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
