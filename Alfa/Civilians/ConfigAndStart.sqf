/*
 * Alfa/Civilians/ConfigAndStart.sqf
 * Configures civilian classes, spawn limits, callbacks, and starts the civilian subsystem.
 */

private ["_parameters"];


_parameters = [
	["UNIT_CLASSES", ["C_man_p_fugitive_F", "C_man_p_shorts_1_F", "C_man_1", "C_man_polo_1_F", "C_ManJacket_01_white", "C_Man_Fisherman_01_F", "C_Man_UtilityWorker_01_F", "C_man_p_beggar_F", "C_man_hunter_1_F", "C_Man_Messenger_01_F", "C_man_polo_6_F", "C_ManSweater_01_khaki"]],
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
