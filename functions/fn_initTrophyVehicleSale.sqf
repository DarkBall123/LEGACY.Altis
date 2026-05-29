/*
 * DZ_fnc_initTrophyVehicleSale
 * Adds delivery-point ACE actions and marks parked trophy vehicles for persistence.
 */

params [
    ["_pad", objNull, [objNull]]
];

private _fnc_resolvePad = {
    missionNamespace getVariable ["vehicle_delivery_pad", objNull]
};

if (isServer) then {
    if !(missionNamespace getVariable ["DZ_trophyVehicleSaleServerStarted", false]) then {
        missionNamespace setVariable ["DZ_trophyVehicleSaleServerStarted", true];

        private _resolvedPad = _pad;
        if (isNull _resolvedPad) then {
            _resolvedPad = call _fnc_resolvePad;
        };

        missionNamespace setVariable ["DZ_trophyVehicleSaleReward", missionNamespace getVariable ["DZ_trophyVehicleSaleReward", 100], true];
        missionNamespace setVariable ["DZ_trophyVehicleSaleRadius", missionNamespace getVariable ["DZ_trophyVehicleSaleRadius", 20], true];
        missionNamespace setVariable ["DZ_trophyVehicleSaleCheckInterval", missionNamespace getVariable ["DZ_trophyVehicleSaleCheckInterval", 60]];

        if (isNull _resolvedPad) then {
            diag_log "[DZ_TROPHY_SALE] vehicle_delivery_pad object not found. Trophy sale disabled until pad exists.";
        } else {
            diag_log format ["[DZ_TROPHY_SALE] System initialized at %1.", getPosATL _resolvedPad];
        };

        private _checkInterval = missionNamespace getVariable ["DZ_trophyVehicleSaleCheckInterval", 60];

        [
            {
                private _pad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
                if (isNull _pad) exitWith {};

                private _radius = missionNamespace getVariable ["DZ_trophyVehicleSaleRadius", 20];
                private _vehicles = nearestObjects [_pad, ["LandVehicle", "Air"], _radius];
                private _changed = false;

                {
                    private _vehicle = _x;

                    if ([_vehicle, _pad, _radius] call DZ_fnc_isTrophyVehicleSellable) then {
                        if !(_vehicle getVariable ["DZ_trophyVehicle", false]) then {
                            _vehicle setVariable ["DZ_trophyVehicle", true, true];
                            _vehicle setVariable ["DZ_persist", true, true];
                            _changed = true;

                            diag_log format [
                                "[DZ_TROPHY_SALE] Trophy vehicle marked persistent: %1 at %2.",
                                typeOf _vehicle,
                                getPosATL _vehicle
                            ];
                        };
                    };
                } forEach _vehicles;

                if (_changed) then {
                    missionNamespace setVariable ["DZ_assetsDirty", true];
                    [true] call DZ_fnc_saveAssets;
                };
            },
            _checkInterval,
            []
        ] call CBA_fnc_addPerFrameHandler;
    };
};

if (hasInterface) then {
    private _clientPad = _pad;

    [
        {
            params ["_pad"];

            private _resolvedPad = _pad;
            if (isNull _resolvedPad) then {
                _resolvedPad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
            };

            !isNull _resolvedPad &&
            { !isNil "ace_interact_menu_fnc_createAction" } &&
            { !isNil "ace_interact_menu_fnc_addActionToObject" }
        },
        {
            params ["_pad"];

            private _resolvedPad = _pad;
            if (isNull _resolvedPad) then {
                _resolvedPad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
            };

            if (isNull _resolvedPad) exitWith {};
            if (_resolvedPad getVariable ["DZ_trophyVehicleSaleActionAdded", false]) exitWith {};
            _resolvedPad setVariable ["DZ_trophyVehicleSaleActionAdded", true, false];

            private _action = [
                "DZ_TrophyVehicleSale",
                "Передать трофейную технику союзникам",
                "",
                {
                    params ["_target", "_player"];

                    private _actualPlayer = [ACE_player, player] select (isNull ACE_player);
                    [_actualPlayer] remoteExecCall ["DZ_fnc_sellTrophyVehicle", 2];
                },
                {
                    params ["_target", "_player"];

                    alive _player && { (_player distance2D _target) <= 8 }
                },
                {},
                [],
                {[0, 0, 1.5]},
                5,
                [false, false, true, false, true]
            ] call ace_interact_menu_fnc_createAction;

            [_resolvedPad, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
        },
        [_clientPad]
    ] call CBA_fnc_waitUntilAndExecute;
};

true
