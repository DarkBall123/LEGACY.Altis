/*
 * DZ_fnc_initVehicleFlagActions
 * Removes the AFOU vehicle flag actions and adds the mission Russian flag action.
 */

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["DZ_vehicleFlagActionsInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_vehicleFlagActionsInitialized", true];

[] spawn
{
    waitUntil { !isNull player };

    waitUntil
    {
        (!isNil "ace_interact_menu_fnc_removeActionFromClass" &&
        {!isNil "ace_interact_menu_fnc_createAction"} &&
        {!isNil "ace_interact_menu_fnc_addActionToClass"}) ||
        { time > 20 }
    };

    if (!isNil "ace_interact_menu_fnc_removeActionFromClass") then
    {
        [] spawn
        {
            for "_i" from 0 to 12 do
            {
                {
                    [_x, 0, ["ACE_MainActions", "AFOU_flag_raise"], true] call ace_interact_menu_fnc_removeActionFromClass;
                    [_x, 0, ["ACE_MainActions", "AFOU_flag_remove"], true] call ace_interact_menu_fnc_removeActionFromClass;
                } forEach ["LandVehicle", "Tank", "Tank_F", "Car", "Car_F"];

                sleep 5;
            };
        };
    };

    if (!isNil "ace_interact_menu_fnc_createAction" && {!isNil "ace_interact_menu_fnc_addActionToClass"}) then
    {
        private _raiseAction = [
            "DZ_raise_russian_vehicle_flag",
            "Поднять флаг!",
            "\A3\ui_f\data\igui\cfg\simpleTasks\types\use_ca.paa",
            {
                params ["_target", "_player", "_params"];
                [_target, _player] call DZ_fnc_raiseRussianVehicleFlag;
            },
            {
                params ["_target", "_player", "_params"];
                alive _target && { _target isKindOf "LandVehicle" }
            }
        ] call ace_interact_menu_fnc_createAction;

        ["LandVehicle", 0, ["ACE_MainActions"], _raiseAction, true] call ace_interact_menu_fnc_addActionToClass;
    };
};

true