/*
 * DZ_fnc_radioPlayLocal
 *
 * Plays a radio track for the local player at the radio's position.
 * Called via remoteExec from DZ_fnc_radioControl on every client.
 *
 *     [_radio, _path, _title] remoteExec ["DZ_fnc_radioPlayLocal", 0, _radio];
 *
 * Why playSound3D and not say3D:
 *   - say3D requires a CfgSounds entry per track (config-bound).
 *   - playSound3D takes a direct file path, so we can add tracks by
 *     just dropping .ogg files into sound\ and updating DZ_RadioTracks.
 *
 * Range / falloff:
 *   - Args 6/7 of playSound3D are distance and pitch. distance=30 means
 *     the sound is fully audible up to 30m, fading naturally beyond.
 */

if (!hasInterface) exitWith {};

params [
    ["_radio", objNull, [objNull]],
    ["_path",  "",      [""]],
    ["_title", "",      [""]]
];

if (isNull _radio) exitWith {};
if (_path isEqualTo "") exitWith {};

playSound3D [
    _path,
    _radio,         // attach to radio object so it tracks its position
    false,          // not playing on the player (= world position)
    getPosASL _radio,
    1.0,            // volume (1.0 = full)
    1.0,            // pitch
    30              // distance — this is the "fully audible" radius
];

// Subtle on-screen marker for the local player so they know what's playing.
// Falls back gracefully if showHint isn't loaded yet.
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
