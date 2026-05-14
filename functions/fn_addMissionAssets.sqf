/*
 * DZ_fnc_addMissionAssets
 * Registers mission-spawned units, vehicles, markers, and PFH handles for cleanup.
 */

params [
    ["_unitsToAdd", [], [[]]],
    ["_vehiclesToAdd", [], [[]]],
    ["_markersToAdd", [], [[]]],
    ["_pfhHandlesToAdd", [], [[]]]
];

if (!isServer) exitWith { false };

private _units = missionNamespace getVariable ["DZ_missionUnits", []];
private _vehicles = missionNamespace getVariable ["DZ_missionVehicles", []];
private _markers = missionNamespace getVariable ["DZ_missionMarkers", []];
private _pfhHandles = missionNamespace getVariable ["DZ_missionPfhHandles", []];

{
    _units pushBackUnique _x;
} forEach (_unitsToAdd select { !isNull _x });

{
    _vehicles pushBackUnique _x;
} forEach (_vehiclesToAdd select { !isNull _x });

{
    _markers pushBackUnique _x;
} forEach (_markersToAdd select { _x != "" });

{
    _pfhHandles pushBackUnique _x;
} forEach _pfhHandlesToAdd;

missionNamespace setVariable ["DZ_missionUnits", _units];
missionNamespace setVariable ["DZ_missionVehicles", _vehicles];
missionNamespace setVariable ["DZ_missionMarkers", _markers];
missionNamespace setVariable ["DZ_missionPfhHandles", _pfhHandles];

true
