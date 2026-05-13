params [["_taskKey", "urban_dense"]];

private _taskConfigs = missionNamespace getVariable ["DZ_spawnTaskConfigs", createHashMap];
if !(_taskConfigs isEqualType createHashMap) exitWith { [[], [], []] };

private _profile = _taskConfigs getOrDefault [_taskKey, createHashMap];
if !(_profile isEqualType createHashMap) exitWith { [[], [], []] };

private _fnc_parsePoolEntry =
{
    params ["_entry"];

    if (_entry isEqualType []) exitWith
    {
        [
            _entry param [0, nil],
            _entry param [1, 1]
        ]
    };

    [_entry, 1]
};

private _fnc_pickCount =
{
    params ["_range"];

    private _min = (_range param [0, 0]) max 0;
    private _max = (_range param [1, _min]) max _min;

    if (_max <= _min) exitWith { _min };

    _min + floor (random ((_max - _min) + 1))
};

private _fnc_pickWeighted =
{
    params ["_pool"];

    private _totalWeight = 0;
    private _normalized = [];

    {
        private _parsed = [_x] call _fnc_parsePoolEntry;
        _parsed params ["_value", "_weight"];

        if (isNil "_value" || { _weight <= 0 }) then
        {
            continue;
        };

        _normalized pushBack [_value, _weight];
        _totalWeight = _totalWeight + _weight;
    } forEach _pool;

    if (_totalWeight <= 0) exitWith { nil };

    private _roll = random _totalWeight;
    private _accum = 0;
    private _result = nil;

    {
        _x params ["_value", "_weight"];
        _accum = _accum + _weight;

        if (_roll <= _accum) exitWith
        {
            _result = _value;
        };
    } forEach _normalized;

    _result
};

private _fnc_pickMany =
{
    params ["_definition"];

    private _range = _definition param [0, [0, 0]];
    private _pool = _definition param [1, []];
    private _count = [_range] call _fnc_pickCount;
    private _result = [];

    for "_i" from 1 to _count do
    {
        private _pick = [_pool] call _fnc_pickWeighted;

        if (isNil "_pick") then
        {
            continue;
        };

        _result pushBack _pick;
    };

    _result
};

private _groups = [_profile getOrDefault ["groups", [[0, 0], []]]] call _fnc_pickMany;
private _packages = [_profile getOrDefault ["packages", [[0, 0], []]]] call _fnc_pickMany;
private _vehicles = [_profile getOrDefault ["vehicles", [[0, 0], []]]] call _fnc_pickMany;

[_groups, _packages, _vehicles]
