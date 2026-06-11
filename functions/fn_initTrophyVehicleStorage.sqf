/*
 * DZ_fnc_initTrophyVehicleStorage
 * Adds delivery-point ACE actions for saving captured vehicles.
 */

params [
    ["_pad", objNull, [objNull]]
];

private _fnc_resolvePad = {
    missionNamespace getVariable ["vehicle_delivery_pad", objNull]
};

private _fnc_resolvePads = {
    private _padNames = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
    private _pads = [];

    {
        private _pad = missionNamespace getVariable [_x, objNull];
        if (!isNull _pad) then {
            _pads pushBackUnique _pad;
        };
    } forEach _padNames;

    _pads
};

if (isServer) then {
    if !(missionNamespace getVariable ["DZ_trophyVehicleStorageServerStarted", false]) then {
        missionNamespace setVariable ["DZ_trophyVehicleStorageServerStarted", true];

        private _resolvedPad = _pad;
        if (isNull _resolvedPad) then {
            _resolvedPad = call _fnc_resolvePad;
        };

        missionNamespace setVariable ["DZ_trophyVehicleStorageRadius", missionNamespace getVariable ["DZ_trophyVehicleStorageRadius", 20], true];
        missionNamespace setVariable ["DZ_trophyVehicleStoragePadNames", missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]], true];

        private _resolvedPads = call _fnc_resolvePads;
        if (_resolvedPads isEqualTo []) then {
            diag_log "[DZ_TROPHY_STORAGE] No trophy storage pads found. Clients will wait for configured pads.";
        } else {
            diag_log format ["[DZ_TROPHY_STORAGE] System initialized with %1 pad(s).", count _resolvedPads];
        };
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

            private _padNames = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
            private _resolvedPads = [];
            {
                private _storagePad = missionNamespace getVariable [_x, objNull];
                if (!isNull _storagePad) then {
                    _resolvedPads pushBackUnique _storagePad;
                };
            } forEach _padNames;

            (_resolvedPads isNotEqualTo [] || {!isNull _resolvedPad}) &&
            { !isNil "ace_interact_menu_fnc_createAction" } &&
            { !isNil "ace_interact_menu_fnc_addActionToObject" }
        },
        {
            params ["_pad"];

            private _resolvedPad = _pad;
            if (isNull _resolvedPad) then {
                _resolvedPad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
            };

            private _action = [
                "DZ_TrophyVehicleStorage",
                "Сохранить трофейную технику",
                "",
                {
                    params ["_target", "_player"];

                    private _actualPlayer = [ACE_player, player] select (isNull ACE_player);
                    [_actualPlayer, _target] remoteExecCall ["DZ_fnc_saveTrophyVehicle", 2];
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

            private _padNames = missionNamespace getVariable ["DZ_trophyVehicleStoragePadNames", ["vehicle_delivery_pad", "logistics_point"]];
            private _resolvedPads = [];
            {
                private _storagePad = missionNamespace getVariable [_x, objNull];
                if (!isNull _storagePad) then {
                    _resolvedPads pushBackUnique _storagePad;
                };
            } forEach _padNames;

            if (_resolvedPads isEqualTo [] && {!isNull _resolvedPad}) then {
                _resolvedPads pushBack _resolvedPad;
            };

            {
                private _storagePad = _x;
                if !(_storagePad getVariable ["DZ_trophyVehicleStorageActionAdded", false]) then {
                    _storagePad setVariable ["DZ_trophyVehicleStorageActionAdded", true, false];
                    [_storagePad, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
                };
            } forEach _resolvedPads;
        },
        [_clientPad]
    ] call CBA_fnc_waitUntilAndExecute;
};

true
