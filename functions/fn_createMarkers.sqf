/*
 * DZ_fnc_createMarkers
 * Creates the visual map markers for each zone. Option B: each zone
 * is an ELLIPSE sized to its own radius (capital ~1000m, village
 * ~500m, …), centred on the location's actual position, with a label
 * derived from the BIS location text ("Pyrgos", "Sofia", …).
 *
 * The `_urbanHash` argument is preserved for back-compat with old
 * callers but every zone is by definition urban now (we only build
 * sectors from named locations), so the colour split is gone.
 */

params [
    ["_cells",     [], [[]]],
    ["_urbanHash", createHashMap, [createHashMap]]
];

private _alpha     = missionNamespace getVariable ["DZ_alpha",     0.35];
private _zoneRadii = missionNamespace getVariable ["DZ_zoneRadii", []];
private _zoneNames = missionNamespace getVariable ["DZ_zoneNames", []];

{
    private _idx     = _forEachIndex;
    private _pos     = _x;
    private _radius  = _zoneRadii param [_idx, 600];
    private _label   = _zoneNames param [_idx, ""];

    private _markerName = format ["DZ_zone_%1", _idx];
    createMarker [_markerName, _pos];

    _markerName setMarkerShape "ELLIPSE";
    _markerName setMarkerBrush "DiagGrid";
    _markerName setMarkerSize  [_radius, _radius];
    _markerName setMarkerColor "ColorGrey";
    _markerName setMarkerAlpha _alpha;
    _markerName setMarkerText  _label;

    publicVariable _markerName;

    diag_log format ["[DZ] > %1 ELLIPSE r=%2 @%3 \"%4\"",
        _markerName, _radius, _pos, _label];
} forEach _cells;
