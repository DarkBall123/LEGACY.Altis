/*
 * initServer.sqf
 * Bootstraps server-side mission systems, side relations, radio tracks,
 * Alfa ambience, and squad funds for the LEGACY.Altis campaign.
 *
 * Side layout:
 *   east       (OPFOR)  — the single player faction
 *   west       (BLUFOR) — AI enemy
 *   resistance (IND)    — AI enemy, allied with west
 *   civilian            — neutral to everyone
 *
 * Players (east) are hostile to both west and resistance; the two enemy
 * sides are friendly to each other. Civilians stay neutral.
 */

call DZ_fnc_controlParams;
call DZ_fnc_initServer;
call DZ_fnc_initAbandonedVehicleCleanup;
call DZ_fnc_initZeusCleanupHook;
call DZ_fnc_initPylonRestrictions;
call DZ_fnc_initEnemyAirSupport;
call compile preprocessFileLineNumbers "functions\fn_initWeatherSystem.sqf";

east       setFriend [west,       0];
west       setFriend [east,       0];
east       setFriend [resistance, 0];
resistance setFriend [east,       0];
west       setFriend [resistance, 1];
resistance setFriend [west,       1];

DZ_RadioTracks =
[
    ["\MainMenu\meta\ZOV_1.ogg", "Z", 122],
    ["\MainMenu\meta\ZOV_2.ogg", "O", 133],
    ["\MainMenu\meta\ZOV_3.ogg", "V", 89]
];

call DZ_fnc_initMissionSystem;
call DZ_fnc_initMissionIntelLeak;

call compile preprocessFileLineNumbers "Alfa\Civilians\Init.sqf";
call compile preprocessFileLineNumbers "Alfa\Traffic\Init.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Reputation\Reputation.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Reputation\IedThreat.sqf";
call DZ_fnc_initSquadFunds;
call DZ_fnc_initFortifyEconomy;
call DZ_fnc_initTrophyVehicleStorage;
call DZ_fnc_initResourceNodes;

