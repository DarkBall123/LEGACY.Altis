/*
 * DZ_fnc_raiseRussianVehicleFlag
 * Applies the Soviet (USSR) flag texture to a vehicle, using the same
 * mechanism as the AFOU flags. The texture path is read from
 * DZ_vehicleFlagTexture so it can point at whichever USSR flag the
 * active modset ships; the default is the guaranteed-vanilla red flag.
 */

params [["_vehicle", objNull, [objNull]], ["_caller", objNull, [objNull]]];

if (isNull _vehicle) exitWith { false };
if !(_vehicle isKindOf "LandVehicle") exitWith { false };

private _flagTexture = missionNamespace getVariable ["DZ_vehicleFlagTexture", "\A3\Data_F\Flags\Flag_Red_CO.paa"];

_vehicle forceFlagTexture _flagTexture;
[_vehicle, _flagTexture] remoteExecCall ["forceFlagTexture", 0, _vehicle];

true