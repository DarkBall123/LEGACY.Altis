params
[
    ["_unit", objNull],
    ["_loadout", []]
];

if (!hasInterface) exitWith { false };
if (isNull _unit || { !(_loadout isEqualType []) } || { _loadout isEqualTo [] }) exitWith { false };

[
    {
        params ["_args", "_handle"];
        _args params ["_target", "_savedLoadout"];

        if (isNull _target) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (local _target) then
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            _target setUnitLoadout _savedLoadout;
            [_target, _savedLoadout, true] call DZ_fnc_storeOriginalLoadout;
        };
    },
    0.2,
    [_unit, +_loadout]
] call CBA_fnc_addPerFrameHandler;

true
