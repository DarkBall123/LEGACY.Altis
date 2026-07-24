/*
 * DZ_fnc_sideMessage
 * Broadcasts a side-chat style message to players on the selected side.
 */

params [
    ["_message", "", [""]],
    ["_side", sideUnknown, [sideUnknown]]
];

if (!hasInterface) exitWith {};
if (_message isEqualTo "") exitWith {};
if (_side != sideUnknown && {side player != _side}) exitWith {};

systemChat _message;

if (!isNil "DZ_fnc_uiNotify" && { missionNamespace getVariable ["DZ_uiInitialized", false] }) then
{
    private _lower = toLower _message;
    private _kind = switch (true) do
    {
        case (_lower find "провал" >= 0):      { "error" };
        case (_lower find "погиб" >= 0):       { "error" };
        case (_lower find "засад" >= 0):       { "warning" };
        case (_lower find "контратак" >= 0):   { "warning" };
        case (_lower find "заверш" >= 0):      { "success" };
        case (_lower find "доставлен" >= 0):   { "success" };
        case (_lower find "уничтожен" >= 0):   { "success" };
        default                                { "info" };
    };
    ["ПОЛЕВАЯ СЕТЬ", _message, _kind, 6] call DZ_fnc_uiNotify;
};
