/*
 * DZ_fnc_radioPlayLocal
 * Plays a resolved mission radio track locally at the radio object position.
 */

if (!hasInterface) exitWith {};
if (!isNil "remoteExecutedOwner" && { remoteExecutedOwner != 2 }) exitWith {};

params [
    ["_radio", objNull, [objNull]],
    ["_path",  "",      [""]],
    ["_title", "",      [""]]
];

if (isNull _radio) exitWith {};
if (_path isEqualTo "") exitWith {};

private _isEnginePath = ((_path select [0, 1]) == "\") ||
    { (_path find ":") >= 0 } ||
    { (_path select [0, 3]) == "A3\" };

private _soundPath = if (_isEnginePath) then
{
    _path
}
else
{
    getMissionPath _path
};

if (_soundPath isEqualTo "") exitWith
{
    diag_log format ["[RADIO] Could not resolve mission sound path: %1", _path];
};

playSound3D [
    _soundPath,
    _radio,
    false,
    getPosASL _radio,
    1.0,
    1.0,
    30,
    0,
    true
];


if (_title != "" && { player distance _radio < 30 }) then
{
    private _msg = format ["📻 %1", _title];
    if (!isNil "DZ_fnc_showHint") then
    {
        ["Радио", _msg] call DZ_fnc_showHint;
    } else {
        hintSilent _msg;
    };
};
