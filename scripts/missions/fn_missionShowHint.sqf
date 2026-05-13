/*
 * DZ_fnc_missionShowHint
 *
 * Renders a styled hint for the local player. Called via remoteExec from
 * DZ_fnc_missionUI's "hint" branch.
 */

if (!hasInterface) exitWith {};

params ["_title", "_body"];

hintSilent parseText format [
    "<t size='1.2' color='#ff7e2a'>%1</t><br/><br/><t size='1'>%2</t>",
    _title,
    _body
];
