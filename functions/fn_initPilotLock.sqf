/*
 * DZ_fnc_initPilotLock
 * Hard-locks the pilot seat of every air vehicle (helicopter or plane) to
 * designated pilot slots. A player counts as a pilot if their unit has
 * DZ_isPilot set (in the mission.sqm slot init:
 *   this setVariable ["DZ_isPilot", true, true];
 * ) or its class is listed in DZ_pilotClasses. Any non-pilot who takes the
 * pilot (driver) seat of an air vehicle is immediately ejected; gunner,
 * copilot-cargo and passenger seats are unaffected.
 *
 * Called from initPlayerLocal.sqf; enforcement is local to each player and
 * re-arms on respawn.
 */

if (!hasInterface) exitWith { true };
if (missionNamespace getVariable ["DZ_pilotLockInit", false]) exitWith { true };
missionNamespace setVariable ["DZ_pilotLockInit", true];

DZ_fnc_isPilot = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith { false };
    if (_unit getVariable ["DZ_isPilot", false]) exitWith { true };
    (typeOf _unit) in (missionNamespace getVariable ["DZ_pilotClasses", []])
};

DZ_fnc_pilotLockArm = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith {};
    if (_unit getVariable ["DZ_pilotLockArmed", false]) exitWith {};
    _unit setVariable ["DZ_pilotLockArmed", true];

    _unit addEventHandler ["GetInMan", {
        params ["_unit", "_role", "_vehicle"];
        if (_role != "driver") exitWith {};
        if !(_vehicle isKindOf "Air") exitWith {};
        if ([_unit] call DZ_fnc_isPilot) exitWith {};

        moveOut _unit;
        ["Авиация", "Управление воздушной техникой доступно только пилотам."] call DZ_fnc_showHint;
    }];
};

[
    { !isNull player },
    {
        [player] call DZ_fnc_pilotLockArm;
        ["unit", { params ["_unit"]; [_unit] call DZ_fnc_pilotLockArm; }] call CBA_fnc_addPlayerEventHandler;
    },
    []
] call CBA_fnc_waitUntilAndExecute;

true
