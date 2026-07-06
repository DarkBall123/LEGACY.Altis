/*
 * DZ_fnc_prepareSpawnedUnit
 * Per-unit setup hook called on every MEF AI spawned by zone garrisons,
 * missions, packages, and counter-attacks.
 *
 * Responsibilities:
 *   1. Apply role-aware skill via DZ_aiSkillByClass hashmap (overrides
 *      the engine CustomDifficulty preset for this unit; preset still
 *      drives civilians and any AI not routed through this function).
 *   2. UAV operators get a randomised Crocus backpack.
 *
 * Skill values are looked up by `typeOf _unit`. Anything not listed
 * falls back to DZ_aiBaseSkill. `setSkill <number>` sets all subskills
 * uniformly — for surgical per-subskill control, call
 * `setSkill ["aimingAccuracy", N]` from a specific mission script.
 */

params [["_unit", objNull]];

if (isNull _unit) exitWith { false };

private _classSkills = missionNamespace getVariable ["DZ_aiSkillByClass", createHashMap];
private _baseSkill   = missionNamespace getVariable ["DZ_aiBaseSkill", 0.55];
private _skill       = _classSkills getOrDefault [typeOf _unit, _baseSkill];
_unit setSkill _skill;

private _uavOperatorClasses = missionNamespace getVariable ["DZ_uavOperatorClasses", []];
if !((typeOf _unit) in _uavOperatorClasses) exitWith { true };

private _backpacks = missionNamespace getVariable ["DZ_uavOperatorBackpacks", []];
if (_backpacks isEqualTo []) exitWith { true };

removeBackpackGlobal _unit;
_unit addBackpackGlobal (selectRandom _backpacks);

true
