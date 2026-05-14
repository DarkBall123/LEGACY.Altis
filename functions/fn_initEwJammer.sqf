/*
 * DZ_fnc_initEwJammer
 * Adds ACE interaction for deploying or folding an EW jammer object.
 */

params
[
    ["_jammer", objNull, [objNull]],
    ["_jamRadius", 250, [0]],
    ["_checkDelay", 2, [0]]
];

if (isNull _jammer) exitWith { false };

if (isServer) then
{
    _jammer setVariable ["DZ_ewActive", true, true];
    _jammer setVariable ["DZ_ewRadius", _jamRadius, true];

    if !(_jammer getVariable ["DZ_ewKilledEh", false]) then
    {
        _jammer setVariable ["DZ_ewKilledEh", true, true];
        _jammer addEventHandler
        [
            "Killed",
            {
                params ["_jammer"];

                _jammer setVariable ["DZ_ewActive", false, true];
                ["Комплекс РЭБ уничтожен. Радио восстановлено.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
            }
        ];
    };
};

if (!hasInterface) exitWith { true };

private _jammers = missionNamespace getVariable ["DZ_ewJammers", []];
_jammers pushBackUnique _jammer;
missionNamespace setVariable ["DZ_ewJammers", _jammers];

if !(missionNamespace getVariable ["DZ_ewMonitorStarted", false]) then
{
    missionNamespace setVariable ["DZ_ewMonitorStarted", true];
    missionNamespace setVariable ["DZ_ewWasJammed", false];

    private _handle = [
        DZ_fnc_updateEwJammers,
        _checkDelay,
        []
    ] call CBA_fnc_addPerFrameHandler;

    missionNamespace setVariable ["DZ_ewMonitorHandle", _handle];
};

true
