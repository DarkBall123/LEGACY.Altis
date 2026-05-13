params [["_groupDef", nil]];

if !(_groupDef isEqualType createHashMap) exitWith { _groupDef };

private _required = +(_groupDef getOrDefault ["required", []]);
private _countRange = _groupDef getOrDefault ["count", [count _required, count _required]];
private _pool = +(_groupDef getOrDefault ["pool", []]);
private _classes = +(_groupDef getOrDefault ["classes", []]);
private _unique = _groupDef getOrDefault ["unique", false];

if (_pool isEqualTo [] && { _classes isNotEqualTo [] }) then
{
    _pool = _classes apply { [_x, 1] };
};

private _min = (_countRange param [0, count _required]) max 0;
private _max = (_countRange param [1, _min]) max _min;
private _targetCount = if (_max <= _min) then
{
    _min
}
else
{
    _min + floor (random ((_max - _min) + 1))
};

_targetCount = _targetCount max (count _required);

private _fnc_pickWeighted =
{
    params ["_entries"];

    private _totalWeight = 0;
    {
        private _value = _x param [0, ""];
        private _weight = _x param [1, 1];

        if (_value isEqualType "" && { _value != "" } && { _weight > 0 }) then
        {
            _totalWeight = _totalWeight + _weight;
        };
    } forEach _entries;

    if (_totalWeight <= 0) exitWith { ["", -1] };

    private _roll = random _totalWeight;
    private _accum = 0;
    private _picked = ["", -1];

    {
        private _value = _x param [0, ""];
        private _weight = _x param [1, 1];

        if !(_value isEqualType "") then
        {
            continue;
        };

        if (_value isEqualTo "" || { _weight <= 0 }) then
        {
            continue;
        };

        _accum = _accum + _weight;
        if (_roll <= _accum) exitWith
        {
            _picked = [_value, _forEachIndex];
        };
    } forEach _entries;

    _picked
};

private _result = +_required;
private _availablePool = +_pool;

while { (count _result) < _targetCount && { count _availablePool > 0 } } do
{
    private _pick = [_availablePool] call _fnc_pickWeighted;
    _pick params [["_className", ""], ["_poolIndex", -1]];

    if (_className isEqualTo "") exitWith {};

    _result pushBack _className;

    if (_unique && { _poolIndex >= 0 }) then
    {
        _availablePool deleteAt _poolIndex;
    };
};

_result
