if (!isServer) exitWith { "" };

call DZ_fnc_initMissionSystem;

private _definitions = missionNamespace getVariable ["DZ_missionDefinitions", createHashMap];
private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
private _candidates = [];
private _totalWeight = 0;

{
    private _id = _x;
    private _definition = _y;
    private _implemented = _definition getOrDefault ["implemented", false];
    private _randomEnabled = _definition getOrDefault ["randomEnabled", false];
    private _cooldown = _definition getOrDefault ["cooldown", 0];
    private _lastFinished = _cooldowns getOrDefault [_id, -1e9];
    private _weight = _definition getOrDefault ["weight", 1];

    if (_implemented && { _randomEnabled } && { _weight > 0 } && { (time - _lastFinished) >= _cooldown }) then
    {
        _totalWeight = _totalWeight + _weight;
        _candidates pushBack [_id, _definition, _weight];
    };
} forEach _definitions;

if (_candidates isEqualTo []) exitWith { "" };

private _roll = random _totalWeight;
private _cursor = 0;
private _selected = (_candidates # 0) # 0;
private _found = false;

{
    _x params ["_id", "_definition", "_weight"];

    if (!_found) then
    {
        _cursor = _cursor + _weight;

        if (_roll <= _cursor) then
        {
            _selected = _id;
            _found = true;
        };
    };
} forEach _candidates;

_selected
