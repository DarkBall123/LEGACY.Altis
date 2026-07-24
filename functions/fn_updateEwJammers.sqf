/*
 * DZ_fnc_updateEwJammers
 * Updates deployed EW jammer effects against nearby hostile radios and vehicles.
 */

if (!hasInterface) exitWith {};
if (isNull player) exitWith {};

private _knownJammers = missionNamespace getVariable ["DZ_ewJammers", []];
private _activeJammers = _knownJammers select
{
    !isNull _x && { alive _x }
};

missionNamespace setVariable ["DZ_ewJammers", _activeJammers];

private _jamStrength = 0;

{
    private _jamRadius = _x getVariable ["DZ_ewRadius", 250];
    private _distance = player distance2D _x;

    if ((_x getVariable ["DZ_ewActive", false]) && { _jamRadius > 0 } && { _distance < _jamRadius }) then
    {
        private _strength = 1 - (_distance / _jamRadius);
        if (_strength > _jamStrength) then
        {
            _jamStrength = _strength;
        };
    };
} forEach _activeJammers;

private _wasJammed = missionNamespace getVariable ["DZ_ewWasJammed", false];

if (_jamStrength > 0) exitWith
{
    private _bars = "";
    private _filled = round (_jamStrength * 5);

    for "_i" from 1 to 5 do
    {
        if (_i <= _filled) then
        {
            _bars = _bars + "X";
        }
        else
        {
            _bars = _bars + "-";
        };
    };

    private _status = switch (true) do
    {
        case (_jamStrength > 0.8): { "Радио не работает" };
        case (_jamStrength > 0.5): { "Сильные помехи" };
        case (_jamStrength > 0.2): { "Слабые помехи" };
        default { "Минимальные помехи" };
    };

    player setVariable ["tf_unable_to_use_radio", true];
    missionNamespace setVariable ["DZ_ewWasJammed", true];

    uiNamespace setVariable ["DZ_uiEwState", [_jamStrength, _status]];
};

if (_wasJammed) then
{
    player setVariable ["tf_unable_to_use_radio", false];
    missionNamespace setVariable ["DZ_ewWasJammed", false];
    uiNamespace setVariable ["DZ_uiEwState", [0, ""]];
    if (!isNil "DZ_fnc_uiNotify") then
    {
        ["РЭБ", "Радиоканал восстановлен.", "success", 4] call DZ_fnc_uiNotify;
    };
};
