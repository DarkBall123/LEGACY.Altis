if (!isServer) exitWith { false };

private _cache = missionNamespace getVariable ["DZ_savedLoadoutsCache", createHashMap];
if !(_cache isEqualType createHashMap) exitWith { false };

private _serialized = [];

{
    private _uid = _x;
    private _loadout = _cache getOrDefault [_uid, []];

    if (_uid isEqualType "" && { _uid != "" } && { _loadout isEqualType [] } && { _loadout isNotEqualTo [] }) then
    {
        _serialized pushBack [_uid, +_loadout];
    };
} forEach (keys _cache);

profileNamespace setVariable ["DZ_savedPlayerLoadouts", _serialized];
saveProfileNamespace;

missionNamespace setVariable ["DZ_loadoutsDirty", false];

true
