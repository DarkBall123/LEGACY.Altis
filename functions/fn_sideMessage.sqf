params [
    ["_message", "", [""]],
    ["_side", sideUnknown, [sideUnknown]]
];

if (!hasInterface) exitWith {};
if (_message isEqualTo "") exitWith {};
if (_side != sideUnknown && {side player != _side}) exitWith {};

systemChat _message;
