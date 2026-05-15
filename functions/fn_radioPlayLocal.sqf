/*
 * DZ_fnc_radioPlayLocal
 * Plays or stops a managed local 3D radio track.
 */

if (!hasInterface) exitWith {};

params [
    ["_radio", objNull, [objNull]],
    ["_path", "", [""]],
    ["_title", "", [""]],
    ["_stopOnly", false, [false]]
];

if (isNull _radio) exitWith {};

private _oldSoundId = _radio getVariable ["radio_sound_id", -1];
if (_oldSoundId >= 0) then
{
    stopSound _oldSoundId;
    _radio setVariable ["radio_sound_id", -1, false];
};

if (_stopOnly || { _path isEqualTo "" }) exitWith {};

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

private _soundId = playSound3D [
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
_radio setVariable ["radio_sound_id", _soundId, false];

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
