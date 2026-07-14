/*
 * DZ_fnc_saveAssets
 * Snapshots DZ_persist=true vehicles/crates to profileNamespace.
 * Gated by DZ_assetsDirty unless _force=true.
 */

if (!isServer) exitWith { 0 };

private _force = param [0, false, [false]];

if (!_force && { !(missionNamespace getVariable ["DZ_assetsDirty", false]) }) exitWith {
    count (["DZ_savedAssets", []] call DZ_fnc_storeGet)
};

private _snapshot = [];

private _registry = missionNamespace getVariable ["DZ_persistRegistry", []];
_registry = _registry select { !isNull _x && { alive _x } };
missionNamespace setVariable ["DZ_persistRegistry", _registry];

private _saveTargets = _registry + vehicles + (allMissionObjects "B_Respawn_TentA_F") + (allMissionObjects "ReammoBox_F");
_saveTargets = _saveTargets arrayIntersect _saveTargets;

{
    private _veh = _x;

    if (
        !isNull _veh &&
        { alive _veh } &&
        { _veh getVariable ["DZ_persist", false] } &&

        { (_veh getVariable ["DZ_persistMode", "recreate"]) isEqualTo "recreate" } &&
        { (_veh getVariable ["DZ_trophyCrateId", ""]) isEqualTo "" }
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

        private _ownerSide = _veh getVariable ["DZ_trophyVehicleOwnerSide", sideUnknown];
        private _ownerSideKey = switch (true) do {
            case (_ownerSide isEqualTo west):       { "west" };
            case (_ownerSide isEqualTo resistance): { "resistance" };
            case (_ownerSide isEqualTo east):       { "east" };
            case (_ownerSide isEqualTo civilian):   { "civilian" };
            default { "" };
        };

        private _flags = [
            _veh getVariable ["DZ_purchasedItem", false],
            _veh getVariable ["DZ_trackAbandoned", false],
            _veh getVariable ["DZ_trophyVehicle", false],
            _ownerSideKey,
            _veh getVariable ["kshm_deployed", false],
            _veh getVariable ["DZ_supplies", -1]
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
} forEach _saveTargets;

["DZ_savedAssets", _snapshot] call DZ_fnc_storeSet;
call DZ_fnc_storeFlush;

missionNamespace setVariable ["DZ_assetsDirty", false];

diag_log format ["[DZ_ASSETS] Saved %1 persistent asset(s).", count _snapshot];

count _snapshot
