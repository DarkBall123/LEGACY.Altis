/*
 * DZ_fnc_missionStart
 *
 * Start a player-pickable mission. SERVER ONLY.
 *
 * Clients invoke it via:
 *     ["interdiction"] remoteExec ["DZ_fnc_missionStart", 2];
 *
 * Mission state lives in missionNamespace on the server. The variables below
 * are publicVariable'd so clients can read them for the status check / UI.
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
    // case "assassination": { [] spawn DZ_fnc_m02Assassination; };
    // case "downed_pilot": { [] spawn DZ_fnc_m03DownedPilot; };
    default {
        diag_log format ["[MISSION] Unknown mission id: %1", _missionId];
        missionNamespace setVariable ["DZ_missionActive", false];
        publicVariable "DZ_missionActive";
    };
};
