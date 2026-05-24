/*
 * DZ_fnc_raiseRussianVehicleFlag
 * Applies the Russian flag texture to a vehicle using the same mechanism as AFOU flags.
 */

params [["_vehicle", objNull, [objNull]], ["_caller", objNull, [objNull]]];

if (isNull _vehicle) exitWith { false };
if !(_vehicle isKindOf "LandVehicle") exitWith { false };

private _russianFlagTexture = "\rhsafrf\addons\rhs_main\data\flag_rus_co.paa";

_vehicle forceFlagTexture _russianFlagTexture;
[_vehicle, _russianFlagTexture] remoteExecCall ["forceFlagTexture", 0, _vehicle];

true