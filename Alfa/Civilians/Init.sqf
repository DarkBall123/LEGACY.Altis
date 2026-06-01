/*
 * Alfa/Civilians/Init.sqf
 * Selects the machine that should run Alfa civilians and starts the subsystem there.
 */

call compile preprocessFileLineNumbers "Alfa\Civilians\Common\Common.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Common\Debug.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\HeadlessClient.sqf";


private _headlessClientPresent =  !(isNil Engima_Civilians_HeadlessClientName);
private _runOnThisMachine = false;

if (_headlessClientPresent && isMultiplayer) then {
    if (!isServer && !hasInterface) then {
        _runOnThisMachine = true;
    };
}
else {
    if (isServer) then {
        _runOnThisMachine = true;;
    };
};

ENGIMA_CIVILIANS_MAXWAITINGTIME = 300;
ENGIMA_CIVILIANS_RUNNINGCHANCE = 0.05;

if (_runOnThisMachine) then {

    if (isNil "ENGIMA_CIVILIANS_GROUP_INSTANCE_NO") then {
        ENGIMA_CIVILIANS_GROUP_INSTANCE_NO = 0;
    };

call compile preprocessFileLineNumbers "Alfa\Civilians\Server\ServerFunctions.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\ConfigAndStart.sqf";
[] execVM "Alfa\Civilians\CrowdCheers.sqf";

if (isNil { missionNamespace getVariable "ALFA_civZeusAutoScriptEh" }) then {
    private _eh = addMissionEventHandler ["EntityCreated", {
        params ["_entity"];

        [_entity] spawn {
            params ["_entity"];

            sleep 0.2;

            if (isNull _entity) exitWith {};
            if !(_entity isKindOf "CAManBase") exitWith {};
            if (!alive _entity) exitWith {};
            if (!((side group _entity) isEqualTo civilian)) exitWith {};
            if (isNil { missionNamespace getVariable "ALFA_fnc_prepareCivilianUnit" }) exitWith {};

            [_entity] call ALFA_fnc_prepareCivilianUnit;
        };
    }];

    missionNamespace setVariable ["ALFA_civZeusAutoScriptEh", _eh];
    diag_log "[ALFA_CIV] Zeus-created civilians will be scripted automatically.";
};
};