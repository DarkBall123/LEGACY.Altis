/*
 * DZ_fnc_enemyMedicBehavior
 * Makes an enemy medic move to and treat wounded / unconscious allies
 * within range while it lives. Applies a partial field heal and wakes
 * ACE-unconscious patients. Detection is cross-mod (vanilla damage, ACE
 * unconscious flag, and lifeState), and the ACE wake call is guarded so
 * it degrades gracefully when ACE medical functions are absent.
 *
 * Spawned once per medic unit from DZ_fnc_prepareSpawnedUnit.
 */

params [["_unit", objNull]];
if (!isServer) exitWith {};
if (isNull _unit) exitWith {};

private _range      = missionNamespace getVariable ["DZ_medicHealRange", 45];
private _threshold  = missionNamespace getVariable ["DZ_medicWoundThreshold", 0.35];
private _healAmount = missionNamespace getVariable ["DZ_medicHealAmount", 0.6];

while { alive _unit } do {
    sleep (6 + random 4);
    if (!alive _unit) exitWith {};

    private _side = side group _unit;
    private _candidates = (_unit nearEntities [["Man"], _range]) select {
        _x != _unit
        && { alive _x }
        && { !isPlayer _x }
        && { (side group _x) isEqualTo _side }
        && {
            (damage _x >= _threshold)
            || { _x getVariable ["ACE_isUnconscious", false] }
            || { (lifeState _x) in ["INJURED", "INCAPACITATED"] }
        }
    };
    if (_candidates isEqualTo []) then { continue };

    _candidates = [_candidates, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;
    private _patient = _candidates select 0;

    _unit doMove (getPosATL _patient);

    private _t0 = time;
    waitUntil {
        sleep 1;
        !alive _unit || { !alive _patient } || { _unit distance _patient < 4 } || { (time - _t0) > 25 }
    };

    if (alive _unit && { alive _patient } && { _unit distance _patient < 5 }) then {
        _unit doWatch _patient;
        sleep (5 + random 3);

        if (alive _patient) then {
            _patient setDamage (((damage _patient) - _healAmount) max 0);
            _patient setVariable ["ACE_isUnconscious", false, true];
            if (!isNil "ace_medical_fnc_setUnconscious") then { [_patient, false] call ace_medical_fnc_setUnconscious; };
            diag_log format ["[DZ_MEDIC] %1 treated %2", typeOf _unit, typeOf _patient];
        };

        _unit doWatch objNull;
    };
};

true
