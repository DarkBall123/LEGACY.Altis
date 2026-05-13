/*
 * DZ_fnc_missionEnd
 *
 * End the active mission. SERVER ONLY.
 *
 *     ["success" | "failure" | "abort"] call DZ_fnc_missionEnd;
 *
 * Per SECTOR_CONTROL.md: dead bodies and destroyed vehicles are NOT removed
 * by normal cleanup. We only delete units/vehicles that are still alive.
 */

if (!isServer) exitWith {};

params [["_result", "abort", [""]]];

private _units    = missionNamespace getVariable ["DZ_missionUnits",    []];
private _vehicles = missionNamespace getVariable ["DZ_missionVehicles", []];
private _markers  = missionNamespace getVariable ["DZ_missionMarkers",  []];

// Only despawn living assets; leave bodies and wrecks for the server's
// existing battlefield-persistence behaviour to handle.
{
    if (!isNull _x && { alive _x }) then { deleteVehicle _x; };
} forEach _units;

{
    if (!isNull _x && { alive _x }) then {
        { if (alive _x) then { deleteVehicle _x; }; } forEach (crew _x);
        deleteVehicle _x;
    };
} forEach _vehicles;

{ deleteMarker _x; } forEach _markers;

missionNamespace setVariable ["DZ_missionActive",   false];
missionNamespace setVariable ["DZ_missionId",       ""];
missionNamespace setVariable ["DZ_missionUnits",    []];
missionNamespace setVariable ["DZ_missionVehicles", []];
missionNamespace setVariable ["DZ_missionMarkers",  []];

publicVariable "DZ_missionActive";
publicVariable "DZ_missionId";

private _msg = switch (_result) do {
    case "success": { "Миссия выполнена успешно. Хорошая работа." };
    case "failure": { "Миссия провалена." };
    default        { "Миссия завершена досрочно." };
};

["hint", "MISSION CONTROL", _msg] call DZ_fnc_missionUI;
