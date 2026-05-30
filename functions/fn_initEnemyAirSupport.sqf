/*
 * DZ_fnc_initEnemyAirSupport
 * Starts rare background MEF air support checks.
 */

if (!isServer) exitWith { false };
if (missionNamespace getVariable ["DZ_enemyAirSupportInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_enemyAirSupportInitialized", true];

if !(missionNamespace getVariable ["DZ_enemyAirSupportEnabled", true]) exitWith
{
    diag_log "[DZ_AIR_SUPPORT] System disabled.";
    false
};

private _classPool = [];
{
    _x params [["_className", ""], ["_weight", 1]];

    if (_className == "" || { _weight <= 0 }) then
    {
        continue;
    };

    if (isClass (configFile >> "CfgVehicles" >> _className)) then
    {
        _classPool pushBack [_className, _weight];
    }
    else
    {
        diag_log format ["[DZ_AIR_SUPPORT] Missing aircraft class: %1", _className];
    };
} forEach (missionNamespace getVariable ["DZ_enemyAirSupportClasses", []]);

if (_classPool isEqualTo []) exitWith
{
    missionNamespace setVariable ["DZ_enemyAirSupportEnabled", false];
    diag_log "[DZ_AIR_SUPPORT] No configured aircraft classes are available. System disabled.";
    false
};

missionNamespace setVariable ["DZ_enemyAirSupportAvailableClasses", _classPool];
missionNamespace setVariable ["DZ_enemyAirSupportActive", missionNamespace getVariable ["DZ_enemyAirSupportActive", []]];
missionNamespace setVariable ["DZ_enemyAirSupportLastSpawn", missionNamespace getVariable ["DZ_enemyAirSupportLastSpawn", -1e9]];

private _cleanupActive =
{
    private _lifetime = missionNamespace getVariable ["DZ_enemyAirSupportLifetime", 900];
    private _active = missionNamespace getVariable ["DZ_enemyAirSupportActive", []];
    private _kept = [];

    {
        _x params [
            ["_aircraft", objNull],
            ["_crewGroup", grpNull],
            ["_createdAt", 0],
            ["_className", ""],
            ["_targetPos", []]
        ];

        private _hasPlayerCrew = !isNull _aircraft && { ({ isPlayer _x } count (crew _aircraft)) > 0 };
        private _expired = (time - _createdAt) >= _lifetime;

        if (!isNull _aircraft && { _hasPlayerCrew || { alive _aircraft && { !_expired } } }) then
        {
            _kept pushBack _x;
        }
        else
        {
            if (!isNull _crewGroup) then
            {
                {
                    if (!isNull _x) then
                    {
                        deleteVehicle _x;
                    };
                } forEach units _crewGroup;

                deleteGroup _crewGroup;
            };

            if (!isNull _aircraft) then
            {
                {
                    if (!isNull _x) then
                    {
                        deleteVehicle _x;
                    };
                } forEach crew _aircraft;

                deleteVehicle _aircraft;
            };

            diag_log format ["[DZ_AIR_SUPPORT] Cleaned air support %1 near %2.", _className, _targetPos];
        };
    } forEach _active;

    missionNamespace setVariable ["DZ_enemyAirSupportActive", _kept];
    _kept
};

[
    {
        params ["_args", "_handle"];
        _args params ["_cleanupActive"];

        if !(missionNamespace getVariable ["DZ_enemyAirSupportEnabled", true]) exitWith {};

        private _active = call _cleanupActive;
        private _maxActive = missionNamespace getVariable ["DZ_enemyAirSupportMaxActive", 1];
        if ((count _active) >= _maxActive) exitWith {};

        private _cooldown = missionNamespace getVariable ["DZ_enemyAirSupportCooldown", 1800];
        private _lastSpawn = missionNamespace getVariable ["DZ_enemyAirSupportLastSpawn", -1e9];
        if ((time - _lastSpawn) < _cooldown) exitWith {};

        private _chance = missionNamespace getVariable ["DZ_enemyAirSupportChance", 0.08];
        if ((random 1) >= _chance) exitWith {};

        [] call DZ_fnc_spawnEnemyAirSupport;
    },
    missionNamespace getVariable ["DZ_enemyAirSupportCheckInterval", 240],
    [_cleanupActive]
] call CBA_fnc_addPerFrameHandler;

diag_log format
[
    "[DZ_AIR_SUPPORT] System initialized. Classes=%1 chance=%2 interval=%3s cooldown=%4s",
    _classPool,
    missionNamespace getVariable ["DZ_enemyAirSupportChance", 0.08],
    missionNamespace getVariable ["DZ_enemyAirSupportCheckInterval", 240],
    missionNamespace getVariable ["DZ_enemyAirSupportCooldown", 1800]
];

true
