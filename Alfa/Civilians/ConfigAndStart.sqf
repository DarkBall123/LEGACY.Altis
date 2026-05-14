/*
 * Alfa/Civilians/ConfigAndStart.sqf
 * Configures civilian classes, spawn limits, callbacks, and starts the civilian subsystem.
 */

private ["_parameters"];


_parameters = [
	["UNIT_CLASSES", ["LOP_AFR_Civ_Man_01", "LOP_AFR_Civ_Man_01_S", "LOP_AFR_Civ_Man_02", "LOP_AFR_Civ_Man_02_S", "LOP_AFR_Civ_Man_03", "LOP_AFR_Civ_Man_03_S", "LOP_AFR_Civ_Man_04", "LOP_AFR_Civ_Man_04_S", "LOP_AFR_Civ_Man_05", "LOP_AFR_Civ_Man_05_S", "LOP_AFR_Civ_Man_06", "LOP_AFR_Civ_Man_06_S"]],
	["UNITS_PER_BUILDING", 0.2],
	["MAX_GROUPS_COUNT", 15],
	["MIN_SPAWN_DISTANCE", 50],
	["MAX_SPAWN_DISTANCE", 500],
	["MAX_CIVILIAN_LIFETIME", 600],
	["BLACKLIST_MARKERS", []],
	["HIDE_BLACKLIST_MARKERS", true],
	["ON_UNIT_SPAWNED_CALLBACK", { params ["_unit"]; [_unit] execVM "Alfa\Civilians\setupCivilianReaction.sqf"; }],
	["ON_UNIT_REMOVE_CALLBACK", { true }],
	["DEBUG", false]
];


_parameters spawn ENGIMA_CIVILIANS_StartCivilians;
