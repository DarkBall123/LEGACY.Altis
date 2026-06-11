/*
 * initServer.sqf
 * Bootstraps server-side mission systems, side relations, radio tracks,
 * Alfa ambience, and squad funds for the LEGACY.Altis campaign.
 *
 * Side layout:
 *   west       (BLUFOR) — Altis Police Department (APD), player faction A
 *   resistance (IND)    — "Free Altis" insurgents, player faction B
 *   east       (OPFOR)  — Malden Expeditionary Force (MEF), AI antagonist
 *   civilian            — AEGIS International, Pyrgos Cartel, locals (neutral)
 *
 * Three-way hostility: APD <-> MEF, APD <-> Free Altis, MEF <-> Free Altis
 * are all hostile. Civilians (AEGIS / Cartel) stay neutral to everyone;
 * safety inside the trading hubs is enforced by setCaptive on those NPCs.
 */

call DZ_fnc_controlParams;
call DZ_fnc_initServer;
call DZ_fnc_initAbandonedVehicleCleanup;
call DZ_fnc_initZeusCleanupHook;
call DZ_fnc_initPylonRestrictions;
call DZ_fnc_initEnemyAirSupport;
call compile preprocessFileLineNumbers "functions\fn_initWeatherSystem.sqf";

// ── Side relations: 3-way hostility triangle ──────────────────────────
// APD (west) vs MEF (east): hostile.
west       setFriend [east,       0];
east       setFriend [west,       0];
// APD (west) vs Free Altis (resistance): hostile.
west       setFriend [resistance, 0];
resistance setFriend [west,       0];
// MEF (east) vs Free Altis (resistance): hostile.
east       setFriend [resistance, 0];
resistance setFriend [east,       0];

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



