/*
 * DZ_fnc_saveAssets
 * Snapshots DZ_persist=true vehicles/crates to profileNamespace.
 * Gated by DZ_assetsDirty unless _force=true.
 */

if (!isServer) exitWith { 0 };

private _force = param [0, false, [false]];

if (!_force && { !(missionNamespace getVariable ["DZ_assetsDirty", false]) }) exitWith {
    count (profileNamespace getVariable ["DZ_savedAssets", []])
};

private _snapshot = [];

{
    private _veh = _x;

    if (
        !isNull _veh &&
        { alive _veh } &&
        { _veh getVariable ["DZ_persist", false] }
    ) then {
        private _class    = typeOf _veh;
        private _posATL   = getPosATL _veh;
        private _vDir     = vectorDir _veh;
        private _vUp      = vectorUp  _veh;
        private _dmg      = damage _veh;
        private _fuelLvl  = if (_veh isKindOf "AllVehicles" && { !(_veh isKindOf "ReammoBox_F") }) then { fuel _veh } else { 1 };
        private _hits     = getAllHitPointsDamage _veh;
        if !(_hits isEqualType []) then { _hits = [[],[],[]] };

        private _wCargo = getWeaponCargo   _veh;
        private _mCargo = getMagazineCargo _veh;
        private _iCargo = getItemCargo     _veh;
        private _bCargo = getBackpackCargo _veh;

        private _flags = [
            _veh getVariable ["DZ_purchasedItem", false],
            _veh getVariable ["DZ_trackAbandoned", false]
        ];

        _snapshot pushBack [
            _class,
            _posATL,
            _vDir,
            _vUp,
            _dmg,
            _fuelLvl,
            _hits,
            [_wCargo, _mCargo, _iCargo, _bCargo],
            _flags
        ];
    };
} forEach vehicles;

profileNamespace setVariable ["DZ_savedAssets", _snapshot];
saveProfileNamespace;

missionNamespace setVariable ["DZ_assetsDirty", false];

diag_log format ["[DZ_ASSETS] Saved %1 persistent asset(s).", count _snapshot];

count _snapshot
