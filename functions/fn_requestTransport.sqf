/*
 * DZ_fnc_requestTransport
 * Handles transport support requests, cooldowns, and vehicle spawning.
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

// Motorcycle request is Free Altis-exclusive (resistance/INDFOR).
if !((side _caller) isEqualTo resistance) exitWith {
    ["Транспорт", "Запрос Мотоцикла доступен только бойцам «Свободный Алтис»."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _cooldownSeconds = 600;
private _vehicleClass = "UK3CB_WEI_I_YAVA";

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
    ["Транспорт", format ["Мотоцикл еще не готов.\nОжидание: %1:%2", _minutes, _secondsText]] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
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
    ["Транспорт", "Не удалось создать Мотоцикл."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

_vehicle setDir (getDir _spawnObject);
_vehicle setPosATL _freePos;
_vehicle setFuel 1;
_vehicle setDamage 0;


_vehicle setVariable ["DZ_trackAbandoned", true, true];
_vehicle setVariable ["DZ_lastUsed", time, true];

_vehicle setVariable ["DZ_persist", true, true];
missionNamespace setVariable ["DZ_assetsDirty", true];
[true] call DZ_fnc_saveAssets;

missionNamespace setVariable ["DZ_transportLastRequest", time, true];

["Транспорт", "Мотоцикл готов на точке логистики."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
["Мотоцикл выдан на базе.", resistance] remoteExecCall ["DZ_fnc_sideMessage", 0];
