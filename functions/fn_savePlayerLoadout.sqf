params
[
    ["_unit", objNull],
    ["_forceFlush", false],
    ["_uidOverride", ""]
];

if (!isServer) exitWith { false };
if (isNull _unit) exitWith { false };
if (!_forceFlush && { !(isPlayer _unit) || { !(alive _unit) } }) exitWith { false };

private _uid = _uidOverride;
if (_uid isEqualTo "") then
{
    _uid = getPlayerUID _unit;
};

if (_uid isEqualTo "") exitWith { false };

private _cache = missionNamespace getVariable ["DZ_savedLoadoutsCache", createHashMap];
if !(_cache isEqualType createHashMap) then
{
    _cache = createHashMap;

    {
        private _entry = _x;
        private _entryUid = _entry param [0, ""];
        private _entryLoadout = _entry param [1, []];

        if (_entryUid != "" && { _entryLoadout isEqualType [] } && { _entryLoadout isNotEqualTo [] }) then
        {
            _cache set [_entryUid, _entryLoadout];
        };
    } forEach (profileNamespace getVariable ["DZ_savedPlayerLoadouts", []]);

    missionNamespace setVariable ["DZ_savedLoadoutsCache", _cache];
};

private _loadout = getUnitLoadout _unit;
if !(_loadout isEqualType []) exitWith { false };

private _existing = _cache getOrDefault [_uid, []];
if (_existing isEqualTo _loadout && { !_forceFlush }) exitWith { false };

_cache set [_uid, +_loadout];
missionNamespace setVariable ["DZ_savedLoadoutsCache", _cache];
missionNamespace setVariable ["DZ_loadoutsDirty", true];

if (_forceFlush) then
{
    call DZ_fnc_flushSavedLoadouts;
};

true
