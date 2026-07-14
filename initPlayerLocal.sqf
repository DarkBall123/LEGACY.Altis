/*
 * initPlayerLocal.sqf
 * Starts local client initialization for each player.
 */

[] call DZ_fnc_clientInit;
[] call DZ_fnc_initVehicleFlagActions;
call DZ_fnc_initFortifyEconomy;
call DZ_fnc_initSupplySystem;
call DZ_fnc_initPylonRestrictions;
