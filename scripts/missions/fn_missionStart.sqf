/*
 * scripts/missions/fn_missionStart.sqf
 * Legacy mission start dispatcher.
 */

if (!isServer) exitWith {};

params [["_missionId", "", [""]]];

if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith {
    ["hint", "MISSION CONTROL", "Миссия уже активна."] call DZ_fnc_missionUI;
};

missionNamespace setVariable ["DZ_missionActive",   true];
missionNamespace setVariable ["DZ_missionId",       _missionId];
missionNamespace setVariable ["DZ_missionStart",    time];
missionNamespace setVariable ["DZ_missionUnits",    []];
missionNamespace setVariable ["DZ_missionVehicles", []];
missionNamespace setVariable ["DZ_missionMarkers",  []];

publicVariable "DZ_missionActive";
publicVariable "DZ_missionId";
publicVariable "DZ_missionStart";

["hint", "MISSION CONTROL", format ["Миссия активирована: %1", _missionId]]
    call DZ_fnc_missionUI;

switch (_missionId) do {
    case "interdiction": { [] spawn DZ_fnc_m01Interdiction; };


    default {
        diag_log format ["[MISSION] Unknown mission id: %1", _missionId];
        missionNamespace setVariable ["DZ_missionActive", false];
        publicVariable "DZ_missionActive";
    };
};
