params [["_unit", objNull]];

if (!isServer) exitWith { false };
if (isNull _unit || { !isPlayer _unit }) exitWith { false };

if (!isNil "remoteExecutedOwner" && { owner _unit != remoteExecutedOwner }) exitWith
{
    false
};

private _uid = getPlayerUID _unit;
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

private _savedLoadout = _cache getOrDefault [_uid, []];
if !(_savedLoadout isEqualType []) exitWith { false };
if (_savedLoadout isEqualTo []) exitWith { true };

[_unit, +_savedLoadout] remoteExecCall ["DZ_fnc_applySavedLoadout", _unit];

true
