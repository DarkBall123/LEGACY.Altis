/*
 * DZ_fnc_storeMigrate
 * One-time import of existing profileNamespace data into the extDB3
 * backend. Runs from fn_storeInit when the DB backend is active, the DB
 * holds no DZ_* data yet and no migration marker exists — so a populated
 * database is never overwritten by stale profile data.
 */

if (!isServer) exitWith { 0 };
if !((missionNamespace getVariable ["DZ_storeBackend", "profile"]) isEqualTo "extdb3") exitWith { 0 };

private _cache = missionNamespace getVariable ["DZ_storeCache", createHashMap];

if (!isNil { _cache get "dz_meta_migratedat" }) exitWith { 0 };

private _dataKeys = (keys _cache) select
{
    ((_x select [0, 3]) isEqualTo "dz_" && { !((_x select [0, 8]) isEqualTo "dz_meta_") }) ||
    { (_x select [0, 5]) isEqualTo "alfa_" }
};
if (_dataKeys isNotEqualTo []) exitWith
{

    ["DZ_meta_migratedAt", str systemTimeUTC] call DZ_fnc_storeSet;
    0
};

private _migrated = 0;

{
    private _name = toLower _x;

    if (((_name select [0, 3]) isEqualTo "dz_") || { (_name select [0, 5]) isEqualTo "alfa_" }) then
    {
        private _value = profileNamespace getVariable _name;

        if (!isNil "_value" && { (_value isEqualType []) || { _value isEqualType "" } || { _value isEqualType 0 } || { _value isEqualType true } }) then
        {
            [_name, _value] call DZ_fnc_storeSet;
            _migrated = _migrated + 1;
        };
    };
} forEach (allVariables profileNamespace);

["DZ_meta_migratedAt", str systemTimeUTC] call DZ_fnc_storeSet;

diag_log format ["[DZ_STORE] Migrated %1 key(s) from profileNamespace to extDB3", _migrated];

_migrated
