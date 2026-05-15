/*
 * scripts/missions/fn_missionShowHint.sqf
 * Legacy hint wrapper for mission notifications.
 */

if (!hasInterface) exitWith {};

params ["_title", "_body"];

hintSilent parseText format [
    "<t size='1.2' color='#ff7e2a'>%1</t><br/><br/><t size='1'>%2</t>",
    _title,
    _body
];
