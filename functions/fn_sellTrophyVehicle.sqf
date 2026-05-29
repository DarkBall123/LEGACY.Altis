/*
 * DZ_fnc_sellTrophyVehicle
 * Converts a trophy vehicle parked at vehicle_delivery_pad into squad funds.
 */

if (!isServer) exitWith {};

params [
    ["_caller", objNull, [objNull]]
];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;
private _pad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];

if (isNull _pad) exitWith {
    diag_log "[DZ_TROPHY_SALE] vehicle_delivery_pad object not found in mission.";
    ["Трофейная техника", "Пункт передачи техники не настроен."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (!alive _caller || { (_caller distance2D _pad) > 10 }) exitWith {
    ["Трофейная техника", "Подойдите ближе к пункту передачи техники."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _radius = missionNamespace getVariable ["DZ_trophyVehicleSaleRadius", 20];
private _reward = missionNamespace getVariable ["DZ_trophyVehicleSaleReward", 100];
private _candidates = nearestObjects [_pad, ["LandVehicle", "Air"], _radius];
private _sellable = _candidates select { [_x, _pad, _radius] call DZ_fnc_isTrophyVehicleSellable };

if (_sellable isEqualTo []) exitWith {
    ["Трофейная техника", "Рядом нет пустой трофейной техники для передачи."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _vehicle = _sellable # 0;
_vehicle setVariable ["DZ_trophyVehicleSaleInProgress", true, true];

private _className = typeOf _vehicle;
private _vehicleName = getText (configOf _vehicle >> "displayName");
if (_vehicleName == "") then {
    _vehicleName = _className;
};

private _newBalance = [_reward, format ["Trophy vehicle sale: %1 by %2", _className, name _caller]] call DZ_fnc_squadFundsAdjust;

_vehicle setVariable ["DZ_trophyVehicleSold", true, true];

deleteVehicle _vehicle;

missionNamespace setVariable ["DZ_assetsDirty", true];
[true] call DZ_fnc_saveAssets;

diag_log format [
    "[DZ_TROPHY_SALE] %1 sold by %2 for %3₽ at %4. New balance: %5₽.",
    _className,
    name _caller,
    _reward,
    getPosATL _pad,
    _newBalance
];

[
    "Трофейная техника",
    format ["%1 передана союзным правительственным силам. Получено: %2₽. Баланс: %3₽.", _vehicleName, _reward, _newBalance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];

[
    format ["%1 передал трофейную технику союзникам (+%2₽). Баланс: %3₽.", name _caller, _reward, _newBalance],
    east
] remoteExecCall ["DZ_fnc_sideMessage", 0];
