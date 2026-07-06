/*
 * DZ_fnc_sellTrophyVehicle
 * Server-side handler: sells a previously-saved trophy vehicle parked
 * near a logistics pad. Pays a fixed price (DZ_trophyVehicleSellPrice,
 * default 300₽) into the caller's faction wallet, then deletes the
 * vehicle.
 *
 * Only sells vehicles that:
 *   - Have already been claimed as trophies (DZ_trophyVehicle = true).
 *     Random/unowned MEF wrecks players didn't bother saving aren't
 *     eligible — the trophy system was the "claim" step.
 *   - Belong to the calling player's faction (Free Altis can't sell
 *     APD's trophies and vice versa).
 *   - Sit within DZ_trophyVehicleStorageRadius of any registered pad.
 *   - Are empty (no crew, no players inside).
 */

if (!isServer) exitWith {};

params [
    ["_caller", objNull, [objNull]],
    ["_pad",    objNull, [objNull]]
];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;
private _padNames    = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
private _knownPads   = [];

{
    private _knownPad = missionNamespace getVariable [_x, objNull];
    if (!isNull _knownPad) then {
        _knownPads pushBackUnique _knownPad;
    };
} forEach _padNames;

if (isNull _pad) then {
    private _nearestDistance = 1e9;
    {
        private _distance = _caller distance2D _x;
        if (_distance < _nearestDistance) then {
            _nearestDistance = _distance;
            _pad = _x;
        };
    } forEach _knownPads;
};

if (isNull _pad || { !(_pad in _knownPads) }) exitWith {
    ["Трофейная техника", "Пункт сбыта техники не настроен."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (!alive _caller || { (_caller distance2D _pad) > 10 }) exitWith {
    ["Трофейная техника", "Подойдите ближе к пункту сбыта."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _callerSide  = side group _caller;

if !(_callerSide in _playerSides) exitWith {
    ["Трофейная техника", "Эта сторона не может продавать трофейную технику."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _factionLabel = [_callerSide] call DZ_fnc_squadFundsSideLabel;

private _radius     = missionNamespace getVariable ["DZ_trophyVehicleStorageRadius", 20];
private _sellPrice  = missionNamespace getVariable ["DZ_trophyVehicleSellPrice", 300];
private _candidates = nearestObjects [_pad, ["LandVehicle", "Air"], _radius];

private _sellable = _candidates select {
    private _v = _x;
    !isNull _v
        && { alive _v }
        && { _v getVariable ["DZ_trophyVehicle", false] }
        && { ((_v getVariable ["DZ_trophyVehicleOwnerSide", sideUnknown]) isEqualTo _callerSide) }
        && { (crew _v) isEqualTo [] }
};

if (_sellable isEqualTo []) exitWith {
    [
        "Трофейная техника",
        format ["Рядом нет трофейной техники %1, готовой к продаже. Только сохранённые пустые трофеи можно продать.", _factionLabel]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _vehicle = _sellable # 0;
private _className   = typeOf _vehicle;
private _vehicleName = getText (configOf _vehicle >> "displayName");
if (_vehicleName == "") then { _vehicleName = _className; };

_vehicle setVariable ["DZ_trophyVehicleSaveInProgress", true, true];
_vehicle setVariable ["DZ_persist", false, true];

private _newBalance = [_sellPrice, format ["Trophy sale: %1 by %2 (%3)", _className, name _caller, _factionLabel], _callerSide] call DZ_fnc_squadFundsAdjust;

{
    if (!isNull _x) then { deleteVehicle _x; };
} forEach (crew _vehicle);
deleteVehicle _vehicle;

missionNamespace setVariable ["DZ_assetsDirty", true];
[true] call DZ_fnc_saveAssets;

diag_log format ["[DZ_TROPHY_SELL] %1 (%2) sold by %3 for %4₽. New balance: %5₽.",
    _className, _vehicleName, name _caller, _sellPrice, _newBalance];

[
    "Трофейная техника",
    format ["Продано: %1. Получено: %2₽. Баланс %3: %4₽.",
        _vehicleName, _sellPrice, _factionLabel, _newBalance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];

[
    format ["%1 продал трофейную технику %2: %3 за %4₽.",
        name _caller, _factionLabel, _vehicleName, _sellPrice],
    _callerSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];
