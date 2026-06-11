/*
 * DZ_fnc_initWeatherSystem
 * Cycles mission weather through weighted presets on the server.
 */

if (!isServer) exitWith { false };
if (missionNamespace getVariable ["DZ_weatherSystemInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_weatherSystemInitialized", true];

if !(missionNamespace getVariable ["DZ_weatherSystemEnabled", true]) exitWith
{
    diag_log "[DZ_WEATHER] System disabled.";
    false
};

private _presets = missionNamespace getVariable ["DZ_weatherPresets", []];
if (_presets isEqualTo []) exitWith
{
    diag_log "[DZ_WEATHER] No presets configured. System disabled.";
    false
};

private _buildPresetPool =
{
    params ["_sourcePresets"];

    private _validPresets = [];
    {
        _x params
        [
            ["_name", "", [""]],
            ["_overcast", 0, [0]],
            ["_rain", 0, [0]],
            ["_fog", 0, [0]],
            ["_duration", 1800, [0]],
            ["_weight", 1, [0]]
        ];

        if (_name == "" || { _weight <= 0 }) then
        {
            continue;
        };

        _validPresets pushBack [_name, _overcast, _rain, _fog, _duration, _weight];
    } forEach _sourcePresets;

    _validPresets
};

private _selectPreset =
{
    params ["_pool"];

    private _totalWeight = 0;
    {
        _totalWeight = _totalWeight + (_x # 5);
    } forEach _pool;

    if (_totalWeight <= 0) exitWith { _pool # 0 };

    private _pick = random _totalWeight;
    private _accumulated = 0;

    {
        _accumulated = _accumulated + (_x # 5);
        if (_pick <= _accumulated) exitWith { _x };
    } forEach _pool;

    _pool # 0
};

private _applyPreset =
{
    params ["_preset"];
    _preset params ["_name", "_overcast", "_rain", "_fog", "_duration", "_weight"];

    private _transition = 120 min (_duration * 0.25);

    _transition setOvercast _overcast;
    _transition setRain _rain;
    _transition setFog _fog;

    missionNamespace setVariable ["DZ_weatherCurrentPreset", _name];

    diag_log format
    [
        "[DZ_WEATHER] Applied preset %1: overcast=%2 rain=%3 fog=%4 duration=%5s",
        _name,
        _overcast,
        _rain,
        _fog,
        _duration
    ];
};

private _pool = [_presets] call _buildPresetPool;
if (_pool isEqualTo []) exitWith
{
    diag_log "[DZ_WEATHER] No valid presets available. System disabled.";
    false
};

private _initialPreset = [_pool] call _selectPreset;
[_initialPreset] call _applyPreset;

[[_buildPresetPool, _selectPreset, _applyPreset, (_initialPreset # 4) max 60]] spawn
{
    params ["_args"];
    _args params ["_buildPresetPool", "_selectPreset", "_applyPreset", "_initialDelay"];

    sleep _initialDelay;

    while { true } do
    {
        private _presets = missionNamespace getVariable ["DZ_weatherPresets", []];
        private _pool = [_presets] call _buildPresetPool;

        if (_pool isEqualTo []) exitWith
        {
            diag_log "[DZ_WEATHER] Weather loop stopped because no valid presets remain.";
        };

        private _preset = [_pool] call _selectPreset;
        [_preset] call _applyPreset;

        sleep ((_preset # 4) max 60);
    };
};

true

