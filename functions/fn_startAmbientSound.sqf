if (!hasInterface) exitWith { false };

if (missionNamespace getVariable ["DZ_ambientSoundStarted", false]) exitWith { true };
missionNamespace setVariable ["DZ_ambientSoundStarted", true];

missionNamespace setVariable ["DZ_ambientSoundNextAt", 0];

private _handle = [
    {
        params ["_args", "_handle"];

        if (!hasInterface) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if (time <= 0) exitWith {};

        private _nextAt = missionNamespace getVariable ["DZ_ambientSoundNextAt", 0];
        if (time < _nextAt) exitWith {};

        private _soundSource = playSound "DZ_SoundAmbience";
        private _delay = if (_soundSource isEqualType objNull) then { 260 } else { 255 };

        missionNamespace setVariable ["DZ_ambientSoundNextAt", time + _delay];
    },
    1,
    []
] call CBA_fnc_addPerFrameHandler;

missionNamespace setVariable ["DZ_ambientSoundPfh", _handle];

true
