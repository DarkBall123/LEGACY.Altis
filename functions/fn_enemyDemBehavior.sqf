/*
 * DZ_fnc_enemyDemBehavior
 * Makes an enemy demolition / engineer unit actually use its explosives:
 * while it lives and players are near its area, it plants victim-triggered
 * IEDs around its current position, up to a per-unit cap. Reuses the ALFA
 * reputation IED classes and safe-zone check so it never mines the base.
 *
 * Spawned once per DEM/ENG unit from DZ_fnc_prepareSpawnedUnit.
 */

params [["_unit", objNull]];
if (!isServer) exitWith {};
if (isNull _unit) exitWith {};

private _iedClasses = missionNamespace getVariable ["ALFA_repIedClasses", []];
if (_iedClasses isEqualTo []) then {
    _iedClasses = ["IEDLandSmall_F", "IEDLandBig_F"] select { isClass (configFile >> "CfgVehicles" >> _x) };
};
if (_iedClasses isEqualTo []) exitWith {};

private _cap         = missionNamespace getVariable ["DZ_demMineCount", 2];
private _radius      = missionNamespace getVariable ["DZ_demMineRadius", 30];
private _threatRange = missionNamespace getVariable ["DZ_demPlayerRange", 900];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [east]];
private _planted     = 0;

while { alive _unit && { _planted < _cap } } do {
    sleep (20 + random 25);
    if (!alive _unit) exitWith {};

    private _playerNear = allPlayers findIf {
        alive _x && { (side group _x) in _playerSides } && { (vehicle _x) distance _unit < _threatRange }
    };
    if (_playerNear < 0) then { continue };

    private _pos = (getPosATL _unit) getPos [6 + random _radius, random 360];
    _pos set [2, 0];

    if (surfaceIsWater _pos) then { continue };
    if (!isNil "ALFA_fnc_repIedInSafeZone" && { [_pos] call ALFA_fnc_repIedInSafeZone }) then { continue };

    private _ied = createMine [selectRandom _iedClasses, _pos, (units group _unit), 0];
    if (!isNull _ied) then {
        _ied setVariable ["DZ_demMine", true, true];
        _planted = _planted + 1;
        diag_log format ["[DZ_DEM] %1 planted %2 at %3", typeOf _unit, typeOf _ied, _pos];
    };

    sleep (3 + random 4);
};

true
