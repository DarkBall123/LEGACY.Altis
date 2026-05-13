private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];

private _types =
[
    "NameCity",
    "NameCityCapital",
    "NameVillage",
    "NameLocal",
    "NameMarine",
    "Airport",
    "CityCenter"
];

private _radii = createHashMapFromArray
[
    ["NameCityCapital", 1000],
    ["NameCity", 800],
    ["NameVillage", 600],
    ["NameLocal", 450],
    ["NameMarine", 600],
    ["Airport", 900],
    ["CityCenter", 700]
];

private _worldCenter = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _searchRadius = worldSize / 2;
private _locations = nearestLocations [_worldCenter, _types, _searchRadius];
private _locationData = [];

{
    private _locationPos = locationPosition _x;

    if (surfaceIsWater _locationPos) then
    {
        continue;
    };

    private _radius = _radii getOrDefault [type _x, 600];
    _locationData pushBack [_locationPos, _radius];
} forEach _locations;

private _urban = createHashMap;

{
    _x params ["_locationPos", "_radius"];

    {
        _x params ["_sectorId", "_centerX", "_centerY"];
        private _center = [_centerX, _centerY, 0];

        if (!(_sectorId in _urban) && { _center distance2D _locationPos <= _radius }) then
        {
            _urban set [_sectorId, true];
        };
    } forEach _sectorGrid;
} forEach _locationData;

diag_log format
[
    "[DZ] Urban scan: %1 / %2 sectors marked urban | locations=%3",
    count _urban,
    count _sectorGrid,
    count _locationData
];

_urban
