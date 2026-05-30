/*
 * DZ_fnc_initRespawnMarkers
 * Resolves per-side respawn points from DZ_respawnPoints.
 *
 * Each entry in DZ_respawnPoints is [label, position, side]. Editor
 * respawn/module markers are the default source of actual
 * respawn positions. Script-created respawn markers are opt-in through
 * DZ_scriptRespawnMarkersEnabled for legacy/debug use.
 *
 * When script markers are enabled and multiple entries share the same
 * side, subsequent markers get "_1", "_2", etc. suffixes.
 */

if (!isServer) exitWith { false };

// Marker-name / colour lookup keyed by str(side) — sides aren't valid
// hashmap keys directly so we stringify them.
private _sideMarkerInfo = createHashMap;
_sideMarkerInfo set [str west,       ["respawn_west",     "ColorBlue"]];
_sideMarkerInfo set [str east,       ["respawn_east",     "ColorRed"]];
_sideMarkerInfo set [str resistance, ["respawn_guerrila", "ColorGreen"]];
_sideMarkerInfo set [str civilian,   ["respawn_civilian", "ColorCivilian"]];

// Clean up any markers we placed previously (so re-init is safe).
{
    if (_x isEqualType "" && { _x != "" }) then
    {
        deleteMarker _x;
    };
} forEach (missionNamespace getVariable ["DZ_respawnMarkerNames", []]);

private _rawPoints      = +(missionNamespace getVariable ["DZ_respawnPoints", []]);
private _playerSides    = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _resolvedPoints = [];

// Each input row is one of: [label, position, side] (preferred) /
// [label, position] (side defaults to first player side) / raw position.
{
    private _entry      = _x;
    private _label      = format ["База %1", _forEachIndex + 1];
    private _position   = [];
    private _entrySide  = _playerSides param [0, west];

    if (_entry isEqualType []) then
    {
        if ((count _entry) >= 3 &&
            { (_entry # 0) isEqualType "" } &&
            { (_entry # 1) isEqualType [] } &&
            { (_entry # 2) isEqualType west }) then     // any side typeof check
        {
            _label     = _entry # 0;
            _position  = +(_entry # 1);
            _entrySide = _entry # 2;
        }
        else
        {
            if ((count _entry) >= 2 &&
                { (_entry # 0) isEqualType "" } &&
                { (_entry # 1) isEqualType [] }) then
            {
                _label    = _entry # 0;
                _position = +(_entry # 1);
            }
            else
            {
                _position = +_entry;
            };
        };
    };

    if (_position isEqualType [] && { (count _position) >= 2 }) then
    {
        _resolvedPoints pushBack
        [
            _label,
            [_position # 0, _position # 1, if ((count _position) > 2) then { _position # 2 } else { 0 }],
            _entrySide
        ];
    };
} forEach _rawPoints;

// Fallback: if controlParams supplied no usable points, drop one
// generic "База" at the centre of the map for each player side.
if (_resolvedPoints isEqualTo []) then
{
    {
        _resolvedPoints pushBack ["База", [worldSize * 0.5, worldSize * 0.5, 0], _x];
    } forEach _playerSides;
};

missionNamespace setVariable ["DZ_respawnPointsResolved", _resolvedPoints];

if !(missionNamespace getVariable ["DZ_scriptRespawnMarkersEnabled", false]) exitWith
{
    missionNamespace setVariable ["DZ_respawnMarkerNames", []];
    true
};

// Per-side index so duplicate entries get suffixed marker names.
private _sideIndex     = createHashMap;
private _createdMarkers = [];

{
    _x params ["_label", "_position", "_entrySide"];

    private _info = _sideMarkerInfo getOrDefault [str _entrySide, ["respawn", "ColorWhite"]];
    _info params ["_markerBase", "_markerColor"];

    private _used = _sideIndex getOrDefault [str _entrySide, 0];
    _sideIndex set [str _entrySide, _used + 1];

    private _markerName = if (_used == 0) then
    {
        _markerBase
    }
    else
    {
        format ["%1_%2", _markerBase, _used]
    };

    private _marker = createMarker [_markerName, _position];
    _marker setMarkerShape "ICON";
    _marker setMarkerType  "mil_start";
    _marker setMarkerColor _markerColor;
    _marker setMarkerText  _label;
    _marker setMarkerAlpha 1;

    _createdMarkers pushBack _marker;
} forEach _resolvedPoints;

missionNamespace setVariable ["DZ_respawnMarkerNames",     _createdMarkers];

true
