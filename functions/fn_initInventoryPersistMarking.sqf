/*
 * DZ_fnc_initInventoryPersistMarking
 * Client-side: marks any container/vehicle whose inventory the local
 * player opens as a persistence candidate (sent to the server once per
 * container per session via DZ_fnc_requestPersistMark).
 *
 * Uses CBA's "unit" player event so the InventoryOpened EH survives
 * respawn and team switch. Gated by DZ_invPersistEnabled.
 */

if (!hasInterface) exitWith { false };
if (!(missionNamespace getVariable ["DZ_invPersistEnabled", true])) exitWith { false };

if (missionNamespace getVariable ["DZ_invPersistMarkingInited", false]) exitWith { true };
missionNamespace setVariable ["DZ_invPersistMarkingInited", true];

DZ_fnc_invPersistOnInventoryOpened =
{
    params ["_unit", "_container1", "_container2"];

    {
        private _container = _x;

        private _skip =
            isNull _container ||
            { _container isKindOf "CAManBase" } ||
            { !alive _container } ||

            { (typeOf _container) in ["GroundWeaponHolder", "GroundWeaponHolder_Scripted", "WeaponHolder", "WeaponHolderSimulated", "WeaponHolderSimulated_Scripted", "Weapon_Empty"] } ||
            { _container getVariable ["DZ_persist", false] } ||

            { _container getVariable ["DZ_invMarkSent", false] };

        if (!_skip) then
        {
            _container setVariable ["DZ_invMarkSent", true];
            [_container] remoteExecCall ["DZ_fnc_requestPersistMark", 2];
        };
    } forEach [_container1, _container2];

    false
};

[
    "unit",
    {
        params ["_newUnit", "_oldUnit"];

        if (!isNull _oldUnit) then
        {
            private _ehId = _oldUnit getVariable ["DZ_invPersistEhId", -1];
            if (_ehId >= 0) then
            {
                _oldUnit removeEventHandler ["InventoryOpened", _ehId];
                _oldUnit setVariable ["DZ_invPersistEhId", -1];
            };
        };

        if (!isNull _newUnit) then
        {
            private _ehId = _newUnit addEventHandler ["InventoryOpened", { _this call DZ_fnc_invPersistOnInventoryOpened }];
            _newUnit setVariable ["DZ_invPersistEhId", _ehId];
        };
    },
    true
] call CBA_fnc_addPlayerEventHandler;

true
