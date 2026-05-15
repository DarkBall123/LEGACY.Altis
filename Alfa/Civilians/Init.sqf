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
};
