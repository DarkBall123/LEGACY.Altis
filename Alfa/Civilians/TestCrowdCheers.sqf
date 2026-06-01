/*
 * Alfa/Civilians/TestCrowdCheers.sqf
 * Debug Console: [] execVM "Alfa\Civilians\TestCrowdCheers.sqf";
 */

if (!isServer) exitWith {
    hint "Run this script with Server Exec.";
};

private _clapMove = "ALFA_CrowdClap";
if !(isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _clapMove)) exitWith {
    hint "ALFA crowd reactions addon is not loaded.";
};
private _crowdMoves = [
    "ALFA_CrowdClap",
    "ALFA_CrowdCheer",
    "ALFA_CrowdExcited1",
    "ALFA_CrowdExcited3"
] select {
    isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _x)
};

private _crowdSounds = [
    "ALFA_CrowdHappy",
    "ALFA_CrowdChill",
    "ALFA_CrowdAngry",
    "ALFA_CrowdFear1"
] select {
    isClass (configFile >> "CfgSounds" >> _x)
};

private _targetPlayer = allPlayers select {
    alive _x
    && { !(_x isKindOf "HeadlessClient_F") }
    && { vehicle _x isEqualTo _x }
} param [0, objNull];

if (isNull _targetPlayer) exitWith {
    hint "No alive player on foot found.";
};

private _civilians = allUnits select {
    alive _x
    && { local _x }
    && { vehicle _x isEqualTo _x }
    && { side group _x isEqualTo civilian }
    && { _x getVariable ["ALFA_civAmbient", false] }
};

if (count _civilians < 2) exitWith {
    hint format ["Need at least 2 ambient civilians. Found: %1", count _civilians];
};

private _testCivilians = _civilians select [0, (count _civilians) min 4];
if (_crowdMoves isEqualTo []) exitWith {
    hint "No ALFA crowd animation classes are loaded.";
};

{
    _x setPosATL (_targetPlayer getPos [4 + random 4, random 360]);
    _x setVariable ["ALFA_civPanicUntil", 0];
    _x setVariable ["ALFA_civNextReactionTime", 0];
    _x setVariable ["ALFA_civCrowdCheering", true];
    doStop _x;
    _x setBehaviour "CARELESS";
    _x setUnitPos "UP";
    _x setDir (_x getDir _targetPlayer);
    _x switchMove (selectRandom _crowdMoves);
} forEach _testCivilians;

if !(_crowdSounds isEqualTo []) then {
    (_testCivilians # 0) say3D (selectRandom _crowdSounds);
};

hint format ["Crowd test started for %1 civilians. Animations: %2. Sounds: %3.", count _testCivilians, count _crowdMoves, count _crowdSounds];
