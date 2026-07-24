/*
 * DZ_fnc_showHint
 * Shows a local formatted hint with title and message text.
 */

params [
    ["_title", "", [""]],
    ["_body", "", [""]]
];

if (!hasInterface) exitWith {};

if (!isNil "DZ_fnc_uiNotify" && { missionNamespace getVariable ["DZ_uiInitialized", false] }) exitWith
{
    private _combined = toLower (_title + " " + _body);
    private _kind = switch (true) do
    {
        case (_combined find "ошиб" >= 0):       { "error" };
        case (_combined find "провал" >= 0):     { "error" };
        case (_combined find "недостаточно" >= 0): { "warning" };
        case (_combined find "уничтож" >= 0):    { "success" };
        case (_combined find "готов" >= 0):      { "success" };
        default                                  { "info" };
    };
    [_title, _body, _kind, 7] call DZ_fnc_uiNotify;
};

if (_body isEqualTo "") then
{
    hintSilent parseText format ["<t size='1.15' color='#ff7e2a'>%1</t>", _title];
}
else
{
    hintSilent parseText format
    [
        "<t size='1.15' color='#ff7e2a'>%1</t><br/><br/><t size='1'>%2</t>",
        _title,
        _body
    ];
};
