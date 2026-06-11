/*
 * DZ_fnc_playCrowdSound3DLocal
 * Plays a crowd CfgSounds class locally through playSound3D.
 */

if (!hasInterface) exitWith {};

params [
    ["_speaker", objNull, [objNull]],
    ["_soundPool", [], [[]]]
];

if (isNull _speaker) exitWith {};
if (_soundPool isEqualTo []) exitWith {};

private _localSoundPool = _soundPool select {
    isClass (configFile >> "CfgSounds" >> _x)
};
if (_localSoundPool isEqualTo []) exitWith {};

private _soundClass = selectRandom _localSoundPool;
private _soundDef = getArray (configFile >> "CfgSounds" >> _soundClass >> "sound");
private _soundPath = _soundDef param [0, "", [""]];
if (_soundPath isEqualTo "") exitWith {
    diag_log format ["[ALFA_CIV] Crowd sound class has no sound path: %1", _soundClass];
};

private _volume = _soundDef param [1, 1, [0]];
private _pitch = _soundDef param [2, 1, [0]];
private _distance = _soundDef param [3, 50, [0]];
_distance = _distance max 50;

playSound3D [
    _soundPath,
    _speaker,
    false,
    getPosASL _speaker,
    _volume,
    _pitch,
    _distance,
    0,
    true
];