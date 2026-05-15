/*
 * DZ_fnc_showHint
 * Shows a local formatted hint with title and message text.
 */

params [
    ["_title", "", [""]],
    ["_body", "", [""]]
];

if (!hasInterface) exitWith {};
if (!isNil "remoteExecutedOwner" && { remoteExecutedOwner != 2 }) exitWith {};

if (_body isEqualTo "") then {
    hintSilent _title;
} else {
    hintSilent format ["%1\n\n%2", _title, _body];
};
