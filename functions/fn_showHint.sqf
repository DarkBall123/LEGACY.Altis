/*
 * DZ_fnc_showHint
 * Shows a local formatted hint with title and message text.
 */

params [
    ["_title", "", [""]],
    ["_body", "", [""]]
];

if (!hasInterface) exitWith {};

if (_body isEqualTo "") then {
    hintSilent parseText format ["<t size='1.15' color='#ff7e2a'>%1</t>", _title];
} else {
    hintSilent parseText format [
        "<t size='1.15' color='#ff7e2a'>%1</t><br/><br/><t size='1'>%2</t>",
        _title,
        _body
    ];
};
