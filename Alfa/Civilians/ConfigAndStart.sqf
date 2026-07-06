/*
 * Alfa/Civilians/ConfigAndStart.sqf
 * Configures civilian classes, spawn limits, callbacks, and starts the civilian subsystem.
 */

private ["_parameters"];

if (isNil { missionNamespace getVariable "ALFA_fnc_prepareCivilianUnit" }) then {
	ALFA_fnc_prepareCivilianUnit = {
		params ["_unit"];

		if (isNull _unit) exitWith {};
		if (!alive _unit) exitWith {};
		if !(vehicle _unit isEqualTo _unit) exitWith {};
		if (!((side group _unit) isEqualTo civilian)) exitWith {};
		if (_unit getVariable ["ALFA_civScripted", false]) exitWith {};

		_unit setVariable ["ALFA_civScripted", true, true];
		_unit setVariable ["ALFA_civAmbient", true, true];

		private _rep = missionNamespace getVariable ["ALFA_civilianReputation", 50];
		private _roleRoll = random 1;
		private _role = switch (true) do {
			case (_rep >= 80): { if (_roleRoll < 0.80) then { "grateful" } else { "friendly" } };
			case (_rep >= 50): { if (_roleRoll < 0.65) then { "friendly" } else { "neutral" } };
			case (_rep >= 20): { if (_roleRoll < 0.75) then { "cautious" } else { "neutral" } };
			default { if (_roleRoll < 0.70) then { "hostile" } else { "cautious" } };
		};

		_unit setVariable ["ALFA_civCrowdRole", _role, true];
		_unit setBehaviour "CARELESS";
		_unit setCombatMode "BLUE";
		_unit disableAI "AUTOCOMBAT";
		_unit allowFleeing 0;
		[_unit] execVM "Alfa\Civilians\setupCivilianReaction.sqf";
	};
};
_parameters = [
	["UNIT_CLASSES", ["LOP_CHR_Civ_Worker_02", "LOP_CHR_Civ_Worker_01", "LOP_CHR_Civ_Worker_04", "LOP_CHR_Civ_Worker_03", "LOP_CHR_Civ_Woodlander_04", "LOP_CHR_Civ_Woodlander_03", "LOP_CHR_Civ_Villager_02", "LOP_CHR_Civ_Villager_03", "LOP_CHR_Civ_Villager_04", "LOP_CHR_Civ_Villager_01", "LOP_CHR_Civ_SchoolTeacher", "LOP_CHR_Civ_Rocker_04", "LOP_CHR_Civ_Rocker_01", "LOP_CHR_Civ_Profiteer_04", "LOP_CHR_Civ_Random", "LOP_CHR_Civ_Priest_01", "LOP_CHR_Civ_Policeman_01", "LOP_CHR_Civ_Functionary_02", "LOP_CHR_Civ_Functionary_01", "LOP_CHR_Civ_Doctor_01", "LOP_CHR_Civ_Citizen_02", "LOP_CHR_Civ_Citizen_01", "LOP_CHR_Civ_Citizen_04", "LOP_CHR_Civ_Assistant"]],
	["UNITS_PER_BUILDING", 0.2],
	["MAX_GROUPS_COUNT", 25],
	["MIN_SPAWN_DISTANCE", 50],
	["MAX_SPAWN_DISTANCE", 300],
	["MAX_CIVILIAN_LIFETIME", 600],
	["BLACKLIST_MARKERS", []],
	["HIDE_BLACKLIST_MARKERS", true],
	["ON_UNIT_SPAWNED_CALLBACK", {
		params ["_unit"];
		[_unit] call ALFA_fnc_prepareCivilianUnit;
	}],
	["ON_UNIT_REMOVE_CALLBACK", { true }],
	["DEBUG", false]
];

_parameters spawn ENGIMA_CIVILIANS_StartCivilians;
