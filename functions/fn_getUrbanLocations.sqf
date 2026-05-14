/*
 * DZ_fnc_getUrbanLocations
 * Collects urban map locations suitable for sector or mission placement.
 */

private _types   = ["NameCity","NameCityCapital","NameVillage","NameLocal"];
private _center  = getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition");
private _radius  = worldSize / 2;
nearestLocations [_center, _types, _radius];
