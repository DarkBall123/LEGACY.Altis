params [["_unit", objNull]];

if (!hasInterface) exitWith { false };
if (isNull _unit) exitWith { false };

private _originalLoadout = missionNamespace getVariable ["DZ_originalLoadout", []];
if !(_originalLoadout isEqualType []) exitWith { false };
if (_originalLoadout isEqualTo []) exitWith { false };

[
    {
        params ["_args", "_handle"];
        _args params ["_target", "_loadout"];

        if (isNull _target) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (local _target && { alive _target }) then
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            _target setUnitLoadout _loadout;
        };
    },
    0.2,
    [_unit, +_originalLoadout]
] call CBA_fnc_addPerFrameHandler;

true
