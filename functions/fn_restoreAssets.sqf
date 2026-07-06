/*
 * DZ_fnc_restoreAssets
 * Recreates assets serialized by DZ_fnc_saveAssets. Called once on init.
 */

if (!isServer) exitWith { 0 };

private _saved = ["DZ_savedAssets", []] call DZ_fnc_storeGet;
if !(_saved isEqualType []) exitWith {
    diag_log "[DZ_ASSETS] No saved-asset list (or wrong type) — nothing to restore.";
    0
};

private _restored = 0;

{
    private _entry = _x;

    if (_entry isEqualType [] && { (count _entry) >= 9 }) then {
        _entry params [
            "_class",
            "_posATL",
            "_vDir",
            "_vUp",
            "_dmg",
            "_fuelLvl",
            "_hits",
            "_cargo",
            "_flags"
        ];

        if (
            _class isEqualType "" &&
            { _class != "" } &&
            { isClass (configFile >> "CfgVehicles" >> _class) }
        ) then {
            private _veh = createVehicle [_class, _posATL, [], 0, "NONE"];

            if (!isNull _veh) then {
                _veh setPosATL _posATL;
                _veh setVectorDirAndUp [_vDir, _vUp];
                _veh setDamage (_dmg min 0.95);

                if (_veh isKindOf "AllVehicles" && { !(_veh isKindOf "ReammoBox_F") }) then {
                    _veh setFuel _fuelLvl;
                };

                if (_hits isEqualType [] && { (count _hits) >= 2 }) then {
                    private _hpNames  = _hits param [0, []];
                    private _hpValues = _hits param [2, []];

                    if (_hpNames isEqualType [] && { _hpValues isEqualType [] }) then {
                        {
                            private _hpName = _x;
                            private _hpVal  = _hpValues param [_forEachIndex, 0];
                            if (_hpName isEqualType "" && { _hpName != "" }) then {
                                _veh setHitPointDamage [_hpName, (_hpVal min 0.95)];
                            };
                        } forEach _hpNames;
                    };
                };

                clearWeaponCargoGlobal   _veh;
                clearMagazineCargoGlobal _veh;
                clearItemCargoGlobal     _veh;
                clearBackpackCargoGlobal _veh;

                if (_cargo isEqualType [] && { (count _cargo) >= 4 }) then {
                    _cargo params ["_wCargo", "_mCargo", "_iCargo", "_bCargo"];

                    private _restoreCargo = {
                        params ["_data", "_target", "_addFnc"];
                        if !(_data isEqualType []) exitWith {};
                        if ((count _data) < 2) exitWith {};
                        private _classes = _data param [0, []];
                        private _counts  = _data param [1, []];
                        if !(_classes isEqualType []) exitWith {};
                        if !(_counts  isEqualType []) exitWith {};
                        {
                            private _cls = _x;
                            private _n   = _counts param [_forEachIndex, 0];
                            if (_cls isEqualType "" && { _cls != "" } && { _n > 0 }) then {
                                if (isClass (configFile >> "CfgWeapons"  >> _cls) ||
                                    isClass (configFile >> "CfgMagazines" >> _cls) ||
                                    isClass (configFile >> "CfgVehicles"  >> _cls)) then {
                                    [_target, [_cls, _n]] call _addFnc;
                                };
                            };
                        } forEach _classes;
                    };

                    [_wCargo, _veh, { (_this # 0) addWeaponCargoGlobal   (_this # 1) }] call _restoreCargo;
                    [_mCargo, _veh, { (_this # 0) addMagazineCargoGlobal (_this # 1) }] call _restoreCargo;
                    [_iCargo, _veh, { (_this # 0) addItemCargoGlobal     (_this # 1) }] call _restoreCargo;
                    [_bCargo, _veh, { (_this # 0) addBackpackCargoGlobal (_this # 1) }] call _restoreCargo;
                };

                _flags params [["_purchased", false], ["_tracked", false], ["_trophy", false], ["_trophyOwnerKey", ""], ["_kshmDeployed", false]];

                [_veh] call DZ_fnc_markPersistent;
                if (_purchased) then {
                    _veh setVariable ["DZ_purchasedItem", true, true];
                    _veh setVariable ["DZ_noCleanup",     true, true];
                };
                if (_tracked) then {
                    _veh setVariable ["DZ_trackAbandoned", true, true];
                    _veh setVariable ["DZ_lastUsed",       time, true];
                };
                if (_trophy) then {
                    _veh setVariable ["DZ_trophyVehicle", true, true];
                    private _trophyOwnerSide = switch (_trophyOwnerKey) do {
                        case "west":       { west };
                        case "resistance": { resistance };
                        case "east":       { east };
                        case "civilian":   { civilian };
                        default { sideUnknown };
                    };
                    if !(_trophyOwnerSide isEqualTo sideUnknown) then {
                        _veh setVariable ["DZ_trophyVehicleOwnerSide", _trophyOwnerSide, true];
                    };
                };

                if ((typeOf _veh) isEqualTo "B_Respawn_TentA_F") then {
                    _veh setVariable ["DZ_noCleanup", true, true];
                };

                if (_kshmDeployed) then {
                    private _respawnId = [east, _veh, "Мобильный штаб APD"] call BIS_fnc_addRespawnPosition;
                    _veh setVariable ["respawn_id", _respawnId, true];
                    _veh setVariable ["kshm_deployed", true, true];
                };

                _restored = _restored + 1;
            };
        } else {
            diag_log format ["[DZ_ASSETS] Skipping restore: class '%1' not in CfgVehicles.", _class];
        };
    };
} forEach _saved;

diag_log format ["[DZ_ASSETS] Restored %1 of %2 saved asset(s).", _restored, count _saved];

_restored
