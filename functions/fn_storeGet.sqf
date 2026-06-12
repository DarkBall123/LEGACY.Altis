/*
 * DZ_fnc_storeGet
 * Reads a value from the persistent key-value store.
 *
 * Usage: private _v = ["DZ_savedCaptures", []] call DZ_fnc_storeGet;
 *
 * Backend "profile": direct profileNamespace read.
 * Backend "extdb3":  in-memory cache (preloaded by fn_storeInit).
 */

params [["_key", "", [""]], "_default"];

if (_key == "") exitWith { _default };

private _key = toLower _key;

if ((missionNamespace getVariable ["DZ_storeBackend", "profile"]) isEqualTo "extdb3") then
{
    private _cache = missionNamespace getVariable ["DZ_storeCache", createHashMap];

    if (isNil "_default") then
    {
        _cache get _key
    }
    else
    {
        _cache getOrDefault [_key, _default]
    };
}
else
{
    if (isNil "_default") then
    {
        profileNamespace getVariable _key
    }
    else
    {
        profileNamespace getVariable [_key, _default]
    };
};
