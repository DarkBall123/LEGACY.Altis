call DZ_fnc_controlParams;
call DZ_fnc_initServer;
call DZ_fnc_initAbandonedVehicleCleanup;
call DZ_fnc_initZeusCleanupHook;
east setFriend [resistance, 0];
resistance setFriend [east, 0];
west setFriend [resistance, 1];
resistance setFriend [west, 1];
DZ_RadioTracks =
[
    ["sound\ZOV_1.ogg", "Z", 122],
    ["sound\ZOV_2.ogg", "O", 133],
    ["sound\ZOV_3.ogg", "V", 89]
];
call DZ_fnc_initMissionSystem;
call compile preprocessFileLineNumbers "Alfa\Civilians\Reputation\Reputation.sqf";
call compile preprocessFileLineNumbers "Alfa\Civilians\Init.sqf";
call compile preprocessFileLineNumbers "Alfa\Traffic\Init.sqf";

