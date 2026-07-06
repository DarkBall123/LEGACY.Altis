/*
 * DZ_fnc_buildSectorGrid
 * Builds the mission's capturable zones from real named locations on
 * the current map. No more rectangular grid — each zone is anchored
 * on a NameCity / NameVillage / Airport / etc. location, sized by the
 * location's type, and only counts as a sector if it actually exists
 * on the map. Empty fields and rocks don't get sectors anymore.
 *
 * Returns:
 *   [_sectorGrid, _sectorLookup, _zoneRadii, _zoneNames, _zoneTypes]
 *
 *   _sectorGrid    : [[sectorId, centerX, centerY], ...]
 *   _sectorLookup  : HashMap (vestigial — kept for back-compat with
 *                    code that might still poke at it). Empty here.
 *   _zoneRadii     : array of radii, parallel to _sectorGrid (number)
 *   _zoneNames     : array of zone display names (string)
 *   _zoneTypes     : array of BIS location type strings (string)
 *
 * Sizing comes from `_radii` below, OR from the per-type override
 * hashmap `DZ_zoneRadiiOverride` in controlParams (so you can tune
 * "capital = 1200, village = 700" without touching code).
 *
 * The `_gridSize` parameter is preserved for legacy callers but no
 * longer drives sector placement. It still feeds back-compat values
 * like `DZ_counterSpawnRadius` for callers that haven't migrated to
 * the per-zone radius API yet.
 */

params
[
    ["_gridSize", missionNamespace getVariable ["DZ_gridSize", 350]],
    ["_mapSize",  worldSize]
];

private _types =
[
    "NameCityCapital",
    "NameCity",
    "NameVillage",
    "NameLocal",
    "Airport",
    "CityCenter"
];

private _defaultRadii = createHashMapFromArray
[
    ["NameCityCapital", 1000],
    ["NameCity",         800],
    ["NameVillage",      500],
    ["NameLocal",        400],
    ["Airport",          900],
    ["CityCenter",       700]
];

private _overrides = missionNamespace getVariable ["DZ_zoneRadiiOverride", createHashMap];
{
    _x params ["_typeKey", "_radiusValue"];
    if (_radiusValue isEqualType 0) then {
        _defaultRadii set [_typeKey, _radiusValue];
    };
} forEach _overrides;

private _worldCenter  = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _searchRadius = _mapSize;
private _locations    = nearestLocations [_worldCenter, _types, _searchRadius];

private _sectorGrid = [];
private _zoneRadii  = [];
private _zoneNames  = [];
private _zoneTypes  = [];
private _sectorId   = 0;

{
    private _loc      = _x;
    private _locType  = type _loc;
    private _locPos   = locationPosition _loc;

    if (surfaceIsWater _locPos) then { continue };

    private _radius = _defaultRadii getOrDefault [_locType, 600];

    private _locName = text _loc;
    if (_locName == "") then { _locName = format ["%1 %2", _locType, _sectorId]; };

    _sectorGrid pushBack [_sectorId, _locPos # 0, _locPos # 1];
    _zoneRadii  pushBack _radius;
    _zoneNames  pushBack _locName;
    _zoneTypes  pushBack _locType;

    _sectorId  = _sectorId + 1;
} forEach _locations;

diag_log format
[
    "[DZ] Sector grid built from %1 named locations (was rectangular grid; gridSize=%2 fallback for legacy callers)",
    count _sectorGrid,
    _gridSize
];

private _sectorLookup = createHashMap;

[_sectorGrid, _sectorLookup, _zoneRadii, _zoneNames, _zoneTypes]
