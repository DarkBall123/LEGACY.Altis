/*
 * initServer.sqf
 * Bootstraps server-side mission systems, relations, radio tracks, Alfa ambience, and squad funds.
 */

call DZ_fnc_controlParams;
call DZ_fnc_initServer;
call DZ_fnc_initAbandonedVehicleCleanup;
call DZ_fnc_initZeusCleanupHook;
call DZ_fnc_initPylonRestrictions;
east setFriend [resistance, 0];
resistance setFriend [east, 0];
west setFriend [resistance, 1];
resistance setFriend [west, 1];
DZ_RadioTracks =
[
    ["\MainMenu\meta\ZOV_1.ogg", "Z", 122],
    ["\MainMenu\meta\ZOV_2.ogg", "O", 133],
    ["\MainMenu\meta\ZOV_3.ogg", "V", 89]
];
call DZ_fnc_initMissionSystem;

call compile preprocessFileLineNumbers "Alfa\Civilians\Init.sqf";
call compile preprocessFileLineNumbers "Alfa\Traffic\Init.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Reputation\Reputation.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Reputation\IedThreat.sqf";
call DZ_fnc_initSquadFunds;
call DZ_fnc_initTrophyVehicleSale;
