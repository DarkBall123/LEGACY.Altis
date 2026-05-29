/*
 * DZ_fnc_isTrophyVehicleSellable
 * Validates whether a vehicle can be handed over at the delivery point.
 */

params [
    ["_vehicle", objNull, [objNull]],
    ["_pad", objNull, [objNull]],
    ["_radius", 20, [0]]
];

if (isNull _vehicle) exitWith { false };
if (isNull _pad) exitWith { false };
if (!alive _vehicle) exitWith { false };
if ((_vehicle distance2D _pad) > _radius) exitWith { false };

if (_vehicle isKindOf "CAManBase") exitWith { false };
if (_vehicle isKindOf "StaticWeapon") exitWith { false };
if (_vehicle isKindOf "ReammoBox_F") exitWith { false };
if (!(_vehicle isKindOf "LandVehicle") && {!(_vehicle isKindOf "Air")}) exitWith { false };
if ((getNumber (configOf _vehicle >> "isUav")) > 0) exitWith { false };

if (_vehicle getVariable ["DZ_purchasedItem", false]) exitWith { false };
if (_vehicle getVariable ["DZ_noCleanup", false]) exitWith { false };
if (_vehicle getVariable ["DZ_trackAbandoned", false]) exitWith { false };
if (_vehicle getVariable ["DZ_trophyVehicleSaleInProgress", false]) exitWith { false };
if (_vehicle getVariable ["DZ_trophyVehicleSold", false]) exitWith { false };

private _isPersistent = _vehicle getVariable ["DZ_persist", false];
private _isTrophy = _vehicle getVariable ["DZ_trophyVehicle", false];
if (_isPersistent && {!_isTrophy}) exitWith { false };

(crew _vehicle) isEqualTo []
