params [
    ["_title", "", [""]],
    ["_body", "", [""]]
];

if (!hasInterface) exitWith {};

if (_body isEqualTo "") then {
    hintSilent _title;
} else {
    hintSilent format ["%1\n\n%2", _title, _body];
};
