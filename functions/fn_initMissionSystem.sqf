/*
 * DZ_fnc_initMissionSystem
 * Initializes mission lifecycle state, definitions, assets, and cooldown storage.
 *
 * Per-side (Wave 4): every player faction has its own mission slot.
 * Slots live inside `DZ_missionStates` keyed by stringified side:
 *   {
 *       "WEST" → { active, id, title, source, startTime,
 *                   units, vehicles, markers, pfhHandles, side },
 *       "GUER" → { ... }
 *   }
 *
 * Legacy globals (DZ_missionActive, DZ_missionCurrentId, …) are
 * proxies that point at the side currently being read/written.
 * They follow `DZ_missionContextSide` while it is set; when it is
 * sideUnknown they fall back to the first active side, or to a
 * blank "no-mission" view if no side has a mission active.
 *
 * Anything calling the old globals (Zeus cleanup hook, legacy
 * mission scripts not yet refactored) gets a sensible view for the
 * common case where one side is acting at a time. Mission scripts
 * refactored for Wave 4 always pass `_side` explicitly and skip
 * the proxy.
 */

if (!isServer) exitWith { false };

if ((count (missionNamespace getVariable ["DZ_missionDefinitions", createHashMap])) == 0) then
{
    private _definitions = call DZ_fnc_getMissionDefinitions;
    missionNamespace setVariable ["DZ_missionDefinitions", _definitions, true];
};

missionNamespace setVariable ["DZ_missionSchedulerEnabled",  missionNamespace getVariable ["DZ_missionSchedulerEnabled",  false]];
missionNamespace setVariable ["DZ_missionEventInterval",      missionNamespace getVariable ["DZ_missionEventInterval",     1200]];
missionNamespace setVariable ["DZ_missionEventInitialDelay",  missionNamespace getVariable ["DZ_missionEventInitialDelay", 1200]];
missionNamespace setVariable ["DZ_missionAutoMinPlayers",     missionNamespace getVariable ["DZ_missionAutoMinPlayers",     1]];
missionNamespace setVariable ["DZ_missionCooldowns",          missionNamespace getVariable ["DZ_missionCooldowns", createHashMap]];

if (isNil "DZ_missionConvoyRoutes") then
{
    DZ_missionConvoyRoutes =
    [
        [[4500, 6200, 0], [6800, 5100, 0]],
        [[7200, 8400, 0], [5100, 9200, 0]],
        [[3800, 4100, 0], [6200, 3900, 0]]
    ];
};

if (isNil "DZ_missionHvtLocations") then
{
    DZ_missionHvtLocations =
    [
        [5200, 7800, 0],
        [8100, 6300, 0],
        [4700, 9100, 0],
        [6500, 4800, 0]
    ];
};

if (isNil "DZ_missionPilotLocations") then
{
    DZ_missionPilotLocations =
    [
        [5800, 8200, 0],
        [7400, 5600, 0],
        [4200, 7100, 0],
        [6900, 9400, 0]
    ];
};

if (isNil "DZ_missionExtractLz") then
{
    DZ_missionExtractLz =
    [
        [4100, 5900, 0],
        [7800, 7200, 0],
        [5500, 4300, 0]
    ];
};

// ── Per-side state store ──────────────────────────────────────────────

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _states      = missionNamespace getVariable ["DZ_missionStates", createHashMap];

DZ_fnc_missionEmptyState = {
    params [["_side", sideUnknown]];
    private _state = createHashMap;
    _state set ["active",     false];
    _state set ["id",         ""];
    _state set ["title",      ""];
    _state set ["source",     ""];
    _state set ["startTime",  0];
    _state set ["units",      []];
    _state set ["vehicles",   []];
    _state set ["markers",    []];
    _state set ["pfhHandles", []];
    _state set ["side",       _side];
    _state
};

{
    private _key = str _x;
    if !(_key in _states) then {
        _states set [_key, [_x] call DZ_fnc_missionEmptyState];
    };
} forEach _playerSides;

// IMPORTANT: server-local store, NO broadcast. Hashmap-broadcast on
// Arma 3 serialises across the network and (on dedicated servers with
// connected clients) replaces the server's local reference with the
// deserialised copy on every setVariable call. That breaks in-place
// mutations of inner per-side state hashmaps: endMission would set
// `state.active = false` on an orphaned reference, then the next
// initMissionSystem call would rebroadcast a fresh copy where active
// is still true. State never cleared, abort/end appeared to silently
// fail — which is exactly the bug players hit on the dedi.
//
// Clients don't need this hashmap directly; they read the broadcast
// bools (DZ_missionActive_WEST, _GUER, …) which ARE published via
// DZ_fnc_missionSyncLegacyGlobals below as scalar setVariables, where
// serialisation is harmless.
missionNamespace setVariable ["DZ_missionStates", _states];

// ── Helpers ──────────────────────────────────────────────────────────

DZ_fnc_missionStateOf = {
    params [["_side", sideUnknown]];
    if (_side isEqualTo sideUnknown) exitWith { [sideUnknown] call DZ_fnc_missionEmptyState };

    private _states = missionNamespace getVariable ["DZ_missionStates", createHashMap];
    private _key    = str _side;

    if !(_key in _states) then {
        _states set [_key, [_side] call DZ_fnc_missionEmptyState];
    };
    _states get _key
};

DZ_fnc_missionActiveForSide = {
    params [["_side", sideUnknown]];
    private _state = [_side] call DZ_fnc_missionStateOf;
    _state get "active"
};

DZ_fnc_missionAnySideActive = {
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _hit = _playerSides findIf { [_x] call DZ_fnc_missionActiveForSide };
    _hit >= 0
};

DZ_fnc_missionActiveSides = {
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    _playerSides select { [_x] call DZ_fnc_missionActiveForSide }
};

DZ_fnc_missionSideOfPlayer = {
    // Side of a player as a player-side, or sideUnknown if the unit
    // isn't on west/resistance/etc.
    params [["_unit", objNull, [objNull]]];
    if (isNull _unit) exitWith { sideUnknown };
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _candidate   = side _unit;
    if (_candidate in _playerSides) exitWith { _candidate };
    sideUnknown
};

DZ_fnc_missionSideLabel = {
    params [["_side", sideUnknown]];
    switch (true) do {
        case (_side isEqualTo east):       { "APD" };
        default { str _side };
    }
};

// Refresh legacy globals so older code sees the chosen side, AND
// broadcast simple per-side booleans / titles that clients can
// read directly (server-only helpers like missionActiveForSide are
// not visible from client action-conditions).
//
// _resolveSide: sideUnknown → use DZ_missionContextSide; if still
// unknown, pick the first active side, or blank everything.
DZ_fnc_missionSyncLegacyGlobals = {
    params [["_resolveSide", sideUnknown]];

    // Always re-broadcast every player side's active/title bools so
    // every client laptop knows the current world state.
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    {
        private _s        = [_x] call DZ_fnc_missionStateOf;
        private _sideKey  = str _x;
        missionNamespace setVariable [format ["DZ_missionActive_%1",     _sideKey], _s get "active",    true];
        missionNamespace setVariable [format ["DZ_missionTitle_%1",      _sideKey], _s get "title",     true];
        missionNamespace setVariable [format ["DZ_missionId_%1",         _sideKey], _s get "id",        true];
        missionNamespace setVariable [format ["DZ_missionStartTime_%1",  _sideKey], _s get "startTime", true];
    } forEach _playerSides;

    private _side = _resolveSide;
    if (_side isEqualTo sideUnknown) then {
        _side = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
    };
    if (_side isEqualTo sideUnknown) then {
        private _active = call DZ_fnc_missionActiveSides;
        if (_active isNotEqualTo []) then { _side = _active # 0 };
    };

    private _state = if (_side isEqualTo sideUnknown) then {
        [sideUnknown] call DZ_fnc_missionEmptyState
    } else {
        [_side] call DZ_fnc_missionStateOf
    };

    missionNamespace setVariable ["DZ_missionActive",       _state get "active",     true];
    missionNamespace setVariable ["DZ_missionCurrentId",    _state get "id",         true];
    missionNamespace setVariable ["DZ_missionCurrentTitle", _state get "title",      true];
    missionNamespace setVariable ["DZ_missionSource",       _state get "source",     true];
    missionNamespace setVariable ["DZ_missionStartTime",    _state get "startTime",  true];
    missionNamespace setVariable ["DZ_missionUnits",        _state get "units"];
    missionNamespace setVariable ["DZ_missionVehicles",     _state get "vehicles"];
    missionNamespace setVariable ["DZ_missionMarkers",      _state get "markers"];
    missionNamespace setVariable ["DZ_missionPfhHandles",   _state get "pfhHandles"];
};

// Initial proxy: pick whichever side already has a mission (none on
// first init), or blank.
[] call DZ_fnc_missionSyncLegacyGlobals;

true
