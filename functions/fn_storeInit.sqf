/*
 * DZ_fnc_storeInit
 * Initializes the persistent key-value storage layer. Must be called
 * before any DZ_fnc_storeGet/Set/Flush (first statement of
 * fn_initServer).
 *
 * Backends:
 *   "extdb3"  — @extDB3 server extension + kv_store table (see
 *               tools/extdb3/README.md). Values are str-serialized,
 *               escaped for the colon protocol and chunked to stay under
 *               callExtension I/O limits. All values are preloaded into
 *               the in-memory cache (DZ_storeCache); reads never touch
 *               the DB at runtime, writes are synchronous.
 *   "profile" — profileNamespace fallback when the extension is absent
 *               or fails to initialize. The mission is fully functional
 *               without extDB3.
 *
 * Keys are case-insensitive (normalized to lower case) because
 * profileNamespace/allVariables are case-insensitive and migrated keys
 * arrive lower-cased.
 *
 * Value constraint: parseSimpleArray-safe types only (numbers, strings,
 * booleans, nested arrays thereof). All existing DZ_* keys qualify.
 */

if (!isServer) exitWith { false };

if (missionNamespace getVariable ["DZ_storeInited", false]) exitWith { true };
missionNamespace setVariable ["DZ_storeInited", true];

missionNamespace setVariable ["DZ_storeBackend", "profile"];
missionNamespace setVariable ["DZ_storeDbDegraded", false];
missionNamespace setVariable ["DZ_storeFlushPending", false];
missionNamespace setVariable ["DZ_storeCache", createHashMap];

// ── Helpers (defined here, used by fn_storeGet/Set and migration) ─────

// Escape a serialized value for the extDB3 colon protocol and its input
// sanitizer. After escaping, every "~" starts a two-char pair, which
// makes sequential unescaping unambiguous.
DZ_fnc_storeEscape =
{
    params ["_txt"];

    _txt = _txt regexReplace ["~/g", "~t"];
    _txt = _txt regexReplace [":/g", "~c"];
    _txt = _txt regexReplace ["""/g", "~q"];
    _txt regexReplace ["'/g", "~a"]
};

DZ_fnc_storeUnescape =
{
    params ["_txt"];

    _txt = _txt regexReplace ["~a/g", "'"];
    _txt = _txt regexReplace ["~q/g", """"];
    _txt = _txt regexReplace ["~c/g", ":"];
    _txt regexReplace ["~t/g", "~"]
};

// Run one synchronous SQL_CUSTOM call. Returns the parsed response
// array ([1, rows] / [0, error]), or [] on a malformed response.
DZ_fnc_storeDbCall =
{
    params ["_request"];

    private _raw = "extDB3" callExtension format ["1:STORE:%1", _request];
    if (_raw isEqualTo "") exitWith { [] };

    private _parsed = parseSimpleArray _raw;
    if !(_parsed isEqualType []) exitWith { [] };

    _parsed
};

// First cell of the first result row, coerced to string.
DZ_fnc_storeDbCell =
{
    params ["_response", ["_default", ""]];

    private _cell = ((_response param [1, []]) param [0, []]) param [0, _default];
    if !(_cell isEqualType "") then { _cell = str _cell };

    _cell
};

// Write one key (delete + chunked insert). Returns true on success.
DZ_fnc_storeDbWrite =
{
    params ["_key", "_value"];

    // Wrapped in a one-element array so scalars/strings round-trip.
    private _txt = [str [_value]] call DZ_fnc_storeEscape;

    private _del = [format ["delKey:%1", _key]] call DZ_fnc_storeDbCall;
    if (((_del param [0, 0]) isEqualTo 0)) exitWith { false };

    private _chunkSize = 8000;
    private _total = count _txt;
    private _index = 0;
    private _offset = 0;
    private _ok = true;

    while { _ok && { _offset < _total } } do
    {
        private _chunk = _txt select [_offset, _chunkSize];
        private _put = [format ["putChunk:%1:%2:%3", _key, _index, _chunk]] call DZ_fnc_storeDbCall;

        if (((_put param [0, 0]) isEqualTo 0)) then
        {
            _ok = false;
        };

        _offset = _offset + _chunkSize;
        _index = _index + 1;
    };

    _ok
};

// Read and decode one key from the DB. Returns [value] on success or []
// when the key is missing/corrupt (lets the caller distinguish "no key").
DZ_fnc_storeDbReadKey =
{
    params ["_key"];

    private _cnt = [format ["countChunks:%1", _key]] call DZ_fnc_storeDbCall;
    if (((_cnt param [0, 0]) isEqualTo 0)) exitWith { [] };

    private _chunkCount = parseNumber ([_cnt, "0"] call DZ_fnc_storeDbCell);
    if (_chunkCount <= 0) exitWith { [] };

    private _txt = "";
    private _failed = false;

    for "_i" from 0 to (_chunkCount - 1) do
    {
        private _res = [format ["getChunk:%1:%2", _key, _i]] call DZ_fnc_storeDbCall;

        if (((_res param [0, 0]) isEqualTo 0)) then
        {
            _failed = true;
        }
        else
        {
            _txt = _txt + ([_res] call DZ_fnc_storeDbCell);
        };
    };

    if (_failed) exitWith { [] };

    private _decoded = parseSimpleArray ([_txt] call DZ_fnc_storeUnescape);
    if (!(_decoded isEqualType []) || { _decoded isEqualTo [] }) exitWith { [] };

    [_decoded # 0]
};

// ── Backend detection ─────────────────────────────────────────────────

private _backend = "profile";
private _version = "extDB3" callExtension "9:VERSION";

if (_version != "") then
{
    private _addDb = parseSimpleArray ("extDB3" callExtension "9:ADD_DATABASE:legacy_altis");
    if !(_addDb isEqualType []) then { _addDb = [0] };

    if (((_addDb param [0, 0]) isEqualTo 1)) then
    {
        private _addProto = parseSimpleArray ("extDB3" callExtension "9:ADD_DATABASE_PROTOCOL:legacy_altis:SQL_CUSTOM:STORE:legacy_store");
        if !(_addProto isEqualType []) then { _addProto = [0] };

        if (((_addProto param [0, 0]) isEqualTo 1)) then
        {
            _backend = "extdb3";
        }
        else
        {
            diag_log format ["[DZ_STORE] extDB3 protocol setup failed (%1) - falling back to profileNamespace", _addProto];
        };
    }
    else
    {
        diag_log format ["[DZ_STORE] extDB3 database setup failed (%1) - falling back to profileNamespace", _addDb];
    };
};

missionNamespace setVariable ["DZ_storeBackend", _backend];

// ── Cache preload + migration (extDB3 only) ───────────────────────────

if (_backend isEqualTo "extdb3") then
{
    private _cache = missionNamespace getVariable ["DZ_storeCache", createHashMap];
    private _pageSize = 50;
    private _page = 0;
    private _keys = [];
    private _more = true;

    while { _more } do
    {
        private _res = [format ["listKeys:%1:%2", _pageSize, _page * _pageSize]] call DZ_fnc_storeDbCall;
        private _rows = _res param [1, []];

        if (((_res param [0, 0]) isEqualTo 0) || { !(_rows isEqualType []) } || { _rows isEqualTo [] }) then
        {
            _more = false;
        }
        else
        {
            {
                private _k = _x param [0, ""];
                if !(_k isEqualType "") then { _k = str _k };
                if (_k != "") then { _keys pushBackUnique (toLower _k) };
            } forEach _rows;

            _more = (count _rows) >= _pageSize;
            _page = _page + 1;
        };
    };

    {
        private _read = [_x] call DZ_fnc_storeDbReadKey;
        if (_read isNotEqualTo []) then
        {
            _cache set [_x, _read # 0];
        };
    } forEach _keys;

    diag_log format ["[DZ_STORE] Preloaded %1 key(s) from extDB3", count (keys _cache)];

    call DZ_fnc_storeMigrate;
};

// ── Backend-change watchdog ───────────────────────────────────────────

private _lastBackend = profileNamespace getVariable ["DZ_meta_backend", ""];
if (_lastBackend != "" && { _lastBackend != _backend }) then
{
    diag_log format
    [
        "[DZ_STORE] WARNING: storage backend changed since last run (%1 -> %2) - persisted data may diverge",
        _lastBackend,
        _backend
    ];
};
profileNamespace setVariable ["DZ_meta_backend", _backend];
saveProfileNamespace;

diag_log format ["[DZ_STORE] backend=%1", _backend];

true
