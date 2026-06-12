/*
 * DZ_fnc_storeSet
 * Writes a value to the persistent key-value store.
 *
 * Usage: ["DZ_savedCaptures", _captures] call DZ_fnc_storeSet;
 *        ... more sets ...
 *        call DZ_fnc_storeFlush;   // commit (profile backend)
 *
 * Value constraint: parseSimpleArray-safe types only (numbers, strings,
 * booleans, nested arrays thereof) — sides/objects must be encoded by
 * the caller (the existing keys already store "WEST"/"GUER" strings).
 *
 * Backend "profile": profileNamespace write; pending until storeFlush.
 * Backend "extdb3":  cache write + immediate synchronous chunked DB
 *                    write. On DB failure the write is mirrored to
 *                    profileNamespace so a DB outage never loses data
 *                    (DZ_storeDbDegraded marks the divergence).
 */

params [["_key", "", [""]], "_value"];

if (!isServer) exitWith { false };
if (_key == "") exitWith { false };

private _key = toLower _key;

if ((missionNamespace getVariable ["DZ_storeBackend", "profile"]) isEqualTo "extdb3") then
{
    private _cache = missionNamespace getVariable ["DZ_storeCache", createHashMap];
    _cache set [_key, _value];

    private _ok = [_key, _value] call DZ_fnc_storeDbWrite;

    if (!_ok) then
    {
        missionNamespace setVariable ["DZ_storeDbDegraded", true];
        profileNamespace setVariable [_key, _value];
        missionNamespace setVariable ["DZ_storeFlushPending", true];
        diag_log format ["[DZ_STORE] DB write failed for '%1' - mirrored to profileNamespace", _key];
    };

    _ok
}
else
{
    profileNamespace setVariable [_key, _value];
    missionNamespace setVariable ["DZ_storeFlushPending", true];
    true
};
