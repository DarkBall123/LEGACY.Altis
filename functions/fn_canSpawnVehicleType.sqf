params
[
    ["_vehicleClass", ""],
    ["_origin", []],
    ["_radius", -1],
    ["_pendingVehicles", []]
];

if (_vehicleClass isEqualTo "") exitWith { false };

private _vehicleMeta = missionNamespace getVariable ["DZ_vehicleMeta", createHashMap];
private _categoryCaps = missionNamespace getVariable ["DZ_vehicleCategoryCaps", createHashMap];
private _localCaps = missionNamespace getVariable ["DZ_vehicleCategoryLocalCaps", createHashMap];

if !(_vehicleMeta isEqualType createHashMap) exitWith { true };
if !(_categoryCaps isEqualType createHashMap) exitWith { true };

private _meta = _vehicleMeta getOrDefault [_vehicleClass, []];
private _category = _meta param [0, ""];

if (_category isEqualTo "") exitWith { true };

private _globalCap = _categoryCaps getOrDefault [_category, -1];
private _checkLocal =
    (_origin isEqualType [])
    && { (count _origin) >= 2 }
    && { _radius > 0 }
    && { _localCaps isEqualType createHashMap };
private _localCap = if (_checkLocal) then { _localCaps getOrDefault [_category, -1] } else { -1 };

private _fnc_getVehicleClass =
{
    params ["_entry"];

    if (_entry isEqualType objNull) exitWith
    {
        if (isNull _entry) then { "" } else { typeOf _entry }
    };

    if (_entry isEqualType "") exitWith { _entry };

    ""
};

private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _activeCount = 0;
private _localCount = 0;

{
    private _assets = _x param [1, [[], []]];
    private _groups = _assets param [0, []];
    private _vehicles = +(_assets param [1, []]);

    {
        if (!isNull _x) then
        {
            _vehicles append ([_x, true] call BIS_fnc_groupVehicles);
        };
    } forEach _groups;

    _vehicles = _vehicles arrayIntersect _vehicles;

    {
        if (isNull _x || { !alive _x }) then
        {
            continue;
        };

        private _activeClass = typeOf _x;
        private _activeMeta = _vehicleMeta getOrDefault [_activeClass, []];

        if ((_activeMeta param [0, ""]) isEqualTo _category) then
        {
            _activeCount = _activeCount + 1;

            if (_checkLocal && { _localCap >= 0 } && { _origin distance2D _x <= _radius }) then
            {
                _localCount = _localCount + 1;
            };
        };
    } forEach (_vehicles arrayIntersect _vehicles);
} forEach _zoneData;

private _pendingCount = 0;
private _pendingLocalCount = 0;

{
    private _pendingClass = [_x] call _fnc_getVehicleClass;
    if (_pendingClass isEqualTo "") then
    {
        continue;
    };

    private _pendingMeta = _vehicleMeta getOrDefault [_pendingClass, []];
    if ((_pendingMeta param [0, ""]) isEqualTo _category) then
    {
        _pendingCount = _pendingCount + 1;

        if (
            _checkLocal &&
            { _localCap >= 0 } &&
            { _x isEqualType objNull } &&
            { !isNull _x } &&
            { _origin distance2D _x <= _radius }
        ) then
        {
            _pendingLocalCount = _pendingLocalCount + 1;
        };
    };
} forEach _pendingVehicles;

if (_globalCap >= 0 && { (_activeCount + _pendingCount) >= _globalCap }) exitWith { false };
if (_localCap >= 0 && { (_localCount + _pendingLocalCount) >= _localCap }) exitWith { false };

true
