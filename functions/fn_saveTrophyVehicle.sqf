/*
 * DZ_fnc_saveTrophyVehicle
 * Persists a captured vehicle and attributes it to the caller's faction.
 */

if (!isServer) exitWith {};

params [
    ["_caller", objNull, [objNull]],
    ["_pad", objNull, [objNull]]
];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;
private _padNames = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
private _knownPads = [];

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

if (isNull _pad || {!(_pad in _knownPads)}) exitWith {
    diag_log "[DZ_TROPHY_STORAGE] Trophy storage pad object not found in mission.";
    ["Трофейная техника", "Пункт сохранения техники не настроен."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (!alive _caller || { (_caller distance2D _pad) > 10 }) exitWith {
    ["Трофейная техника", "Подойдите ближе к пункту сохранения техники."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _callerSide = side group _caller;

if !(_callerSide in _playerSides) exitWith {
    ["Трофейная техника", "Эта сторона не может сохранять трофейную технику."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _radius = missionNamespace getVariable ["DZ_trophyVehicleStorageRadius", 20];
private _candidates = nearestObjects [_pad, ["LandVehicle", "Air"], _radius];
private _storable = _candidates select { [_x, _pad, _radius] call DZ_fnc_isTrophyVehicleStorable };

if (_storable isEqualTo []) exitWith {
    ["Трофейная техника", "Рядом нет пустой несохранённой трофейной техники."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _vehicle = _storable # 0;
_vehicle setVariable ["DZ_trophyVehicleSaveInProgress", true, true];

private _className = typeOf _vehicle;
private _vehicleName = getText (configOf _vehicle >> "displayName");
if (_vehicleName == "") then {
    _vehicleName = _className;
};

private _factionLabel = [_callerSide] call DZ_fnc_squadFundsSideLabel;

_vehicle setVariable ["DZ_trophyVehicle", true, true];
_vehicle setVariable ["DZ_trophyVehicleOwnerSide", _callerSide, true];
_vehicle setVariable ["DZ_trophyVehicleSavedBy", name _caller, true];
_vehicle setVariable ["DZ_trophyVehicleSavedAt", time, true];
_vehicle setVariable ["DZ_trophyVehicleSaveInProgress", false, true];
_vehicle setVariable ["DZ_persist", true, true];

missionNamespace setVariable ["DZ_assetsDirty", true];
[true] call DZ_fnc_saveAssets;

diag_log format [
    "[DZ_TROPHY_STORAGE] %1 saved by %2 for %3 at %4.",
    _className,
    name _caller,
    _factionLabel,
    getPosATL _vehicle
];

[
    "Трофейная техника",
    format ["%1 сохранена как трофей %2.", _vehicleName, _factionLabel]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];

[
    format ["%1 сохранил трофейную технику для %2: %3.", name _caller, _factionLabel, _vehicleName],
    _callerSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];
