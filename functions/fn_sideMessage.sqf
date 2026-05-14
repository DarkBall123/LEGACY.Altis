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
