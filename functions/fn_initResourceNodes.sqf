/*
 * DZ_fnc_initResourceNodes
 * Initializes the strategic resource node system (Tier 1 economy).
 *
 * Each entry in DZ_resourceNodes:
 *   [nodeId, displayName, position, type, perTickIncome]
 *
 * On boot:
 *   1. Resolve each node to its containing sector (closest DZ_cells entry).
 *   2. Create a map marker per node, coloured by current owner.
 *   3. Start two PFHs:
 *      a. Tick PFH (DZ_resourceTickInterval, default 1800 s = 30 min)
 *         pays the controlling side's wallet for each node it holds,
 *         plus emits a side message and RPT log line.
 *      b. Marker refresh PFH (default 15 s) keeps the marker colour in
 *         sync with the current sector owner so players see ownership
 *         flip immediately on capture.
 *
 * Capture-time announcement: when a node's owner CHANGES between ticks,
 * we fire a one-shot side message ("APD захватили Athanos refinery —
 * следующий доход через ~XX минут") so players know the system is alive.
 *
 * Persistence: last-tick timestamp survives server restarts via
 * profileNamespace, so a 5-min-into-the-tick restart doesn't reset the
 * clock to zero.
 */

if (!isServer) exitWith { false };
if (missionNamespace getVariable ["DZ_resourceNodesInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_resourceNodesInitialized", true];

private _nodes = missionNamespace getVariable ["DZ_resourceNodes", []];
if (_nodes isEqualTo []) exitWith {
    diag_log "[DZ_RES] No DZ_resourceNodes configured. System disabled.";
    false
};

private _cells           = missionNamespace getVariable ["DZ_cells", []];
private _markerTypes     = missionNamespace getVariable ["DZ_resourceNodeMarkerType", createHashMap];
private _posOverride     = missionNamespace getVariable ["DZ_resourceNodePosOverride", createHashMap];
private _tickInterval    = missionNamespace getVariable ["DZ_resourceTickInterval", 1800];
private _refreshInterval = missionNamespace getVariable ["DZ_resourceMarkerRefreshInterval", 15];
private _playerSides     = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

// ── Build runtime state (parallel arrays keyed by node index) ────────
private _nodeIds        = [];
private _nodeNames      = [];
private _nodePositions  = [];
private _nodeTypes      = [];
private _nodeIncome     = [];
private _nodeSectorIds  = [];
private _nodeMarkers    = [];
private _nodeLastOwners = [];

{
    _x params [
        ["_nodeId",       "",         [""]],
        ["_displayName",  "",         [""]],
        ["_position",     [0,0,0],    [[]]],
        ["_type",         "",         [""]],
        ["_perTick",      0,          [0]]
    ];

    if (_nodeId == "") then { continue };

    // Eden override of position (admins can patch without editing code).
    private _resolvedPos = _posOverride getOrDefault [_nodeId, _position];

    // Find the sector that contains this node — closest DZ_cells centre.
    private _bestSector = -1;
    private _bestDist   = 1e12;
    {
        private _d = _x distance2D _resolvedPos;
        if (_d < _bestDist) then {
            _bestDist   = _d;
            _bestSector = _forEachIndex;
        };
    } forEach _cells;

    if (_bestSector < 0) then {
        diag_log format ["[DZ_RES] Node %1 (%2): no sector resolved, skipping.", _nodeId, _displayName];
        continue;
    };

    // Create map marker.
    private _markerName = format ["DZ_resource_%1", _nodeId];
    private _markerType = _markerTypes getOrDefault [_type, "mil_dot"];

    createMarker [_markerName, _resolvedPos];
    _markerName setMarkerType  _markerType;
    _markerName setMarkerColor "ColorBlack";   // will be updated by refresh PFH
    _markerName setMarkerText  _displayName;
    _markerName setMarkerSize  [1.0, 1.0];
    _markerName setMarkerAlpha 1;

    _nodeIds        pushBack _nodeId;
    _nodeNames      pushBack _displayName;
    _nodePositions  pushBack _resolvedPos;
    _nodeTypes      pushBack _type;
    _nodeIncome     pushBack _perTick;
    _nodeSectorIds  pushBack _bestSector;
    _nodeMarkers    pushBack _markerName;
    _nodeLastOwners pushBack sideUnknown;

    diag_log format ["[DZ_RES] Registered '%1' (%2) type=%3 perTick=%4 sector=%5 pos=%6",
        _nodeId, _displayName, _type, _perTick, _bestSector, _resolvedPos];
} forEach _nodes;

if (_nodeIds isEqualTo []) exitWith {
    diag_log "[DZ_RES] No nodes resolved. System disabled.";
    false
};

missionNamespace setVariable ["DZ_resourceNodeIds",        _nodeIds];
missionNamespace setVariable ["DZ_resourceNodeNames",      _nodeNames];
missionNamespace setVariable ["DZ_resourceNodePositions",  _nodePositions];
missionNamespace setVariable ["DZ_resourceNodeTypes",      _nodeTypes];
missionNamespace setVariable ["DZ_resourceNodeIncomeList", _nodeIncome];
missionNamespace setVariable ["DZ_resourceNodeSectorIds",  _nodeSectorIds];
missionNamespace setVariable ["DZ_resourceNodeMarkers",    _nodeMarkers, true];
missionNamespace setVariable ["DZ_resourceNodeLastOwners", _nodeLastOwners];

// ── Tick PFH (income payout) ─────────────────────────────────────────
// First tick uses the persisted timestamp so restarts don't reset the
// clock. If we've been past the interval already, the next tick fires
// immediately on PFH start.
private _lastTick = ["DZ_resourceLastTick", -1e9] call DZ_fnc_storeGet;
missionNamespace setVariable ["DZ_resourceLastTick", _lastTick];

private _tickHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_tickInterval"];

        private _lastTick = missionNamespace getVariable ["DZ_resourceLastTick", -1e9];
        if ((time - _lastTick) < _tickInterval && { _lastTick > 0 }) exitWith {};

        call DZ_fnc_resourceTick;

        private _now = time;
        missionNamespace setVariable ["DZ_resourceLastTick", _now];
        ["DZ_resourceLastTick", _now] call DZ_fnc_storeSet;
        call DZ_fnc_storeFlush;
    },
    60,   // check every minute; the gate inside enforces the 30-min cadence
    [_tickInterval]
] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["DZ_resourceTickHandle", _tickHandle];

// ── Marker refresh PFH (visual colour by owner) ──────────────────────
// Lightweight tick — just re-colours markers. Doesn't pay money.
private _refreshHandle = [
    {
        private _nodeMarkers   = missionNamespace getVariable ["DZ_resourceNodeMarkers", []];
        private _nodeSectorIds = missionNamespace getVariable ["DZ_resourceNodeSectorIds", []];
        private _nodeLastOwners = missionNamespace getVariable ["DZ_resourceNodeLastOwners", []];
        private _nodeNames     = missionNamespace getVariable ["DZ_resourceNodeNames", []];
        private _sectorOwner   = missionNamespace getVariable ["DZ_sectorOwner", []];
        private _playerSides   = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
        private _tickInterval  = missionNamespace getVariable ["DZ_resourceTickInterval", 1800];

        {
            private _idx        = _forEachIndex;
            private _marker     = _x;
            private _sectorId   = _nodeSectorIds param [_idx, -1];
            private _owner      = if (_sectorId >= 0) then { _sectorOwner param [_sectorId, sideUnknown] } else { sideUnknown };
            private _prevOwner  = _nodeLastOwners param [_idx, sideUnknown];

            private _color = switch (true) do {
                case (_owner isEqualTo west):       { "ColorBlue" };
                case (_owner isEqualTo resistance): { "ColorGreen" };
                default { "ColorBlack" };   // MEF / contested / unowned
            };

            _marker setMarkerColor _color;

            // Capture flip — emit a one-shot announcement.
            if !(_owner isEqualTo _prevOwner) then {
                _nodeLastOwners set [_idx, _owner];

                if (_owner in _playerSides) then {
                    private _factionLabel = switch (true) do {
                        case (_owner isEqualTo west):       { "APD" };
                        case (_owner isEqualTo resistance): { "Free Altis" };
                        default { str _owner };
                    };
                    private _nodeName = _nodeNames param [_idx, "?"];
                    private _minsToNext = floor (_tickInterval / 60);

                    [
                        format ["[%1] Захвачен %2. Следующий доход через ~%3 мин.",
                            _factionLabel, _nodeName, _minsToNext],
                        _owner
                    ] remoteExecCall ["DZ_fnc_sideMessage", 0];
                };
            };
        } forEach _nodeMarkers;

        missionNamespace setVariable ["DZ_resourceNodeLastOwners", _nodeLastOwners];
    },
    _refreshInterval,
    []
] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["DZ_resourceRefreshHandle", _refreshHandle];

diag_log format ["[DZ_RES] System initialized. %1 nodes, tick=%2s, marker refresh=%3s, lastTick=%4",
    count _nodeIds, _tickInterval, _refreshInterval, _lastTick];

true
