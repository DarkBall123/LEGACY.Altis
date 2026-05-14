/*
 * DZ_fnc_initSquadFunds
 * Initializes persistent squad funds, reward hooks, and balance markers.
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["DZ_squadFundsInitialized", false]) exitWith {};
missionNamespace setVariable ["DZ_squadFundsInitialized", true];


private _savedBalance = profileNamespace getVariable ["DZ_squadFundsBalance", 500];
missionNamespace setVariable ["DZ_squadFundsBalance", _savedBalance, true];


missionNamespace setVariable ["DZ_squadFundsMissionRewards", createHashMapFromArray [
    ["interdiction",     200],
    ["destroy_cache",    250],
    ["assassination",    350],
    ["downed_pilot",     400],
    ["artillery_hunt",   400],
    ["humanitarian_aid", 500],
    ["eod",              450]
]];


DZ_fnc_squadFundsMarkerPos = {
    private _pos = missionNamespace getVariable ["DZ_squadFundsMarkerPos", []];
    if (_pos isEqualType [] && { count _pos >= 2 }) exitWith { _pos };
    [10400, -160, 0]
};

DZ_fnc_squadFundsMarkerColor = {
    params [["_balance", 0, [0]]];
    switch (true) do {
        case (_balance >= 2000): { "ColorGreen" };
        case (_balance >= 500):  { "ColorYellow" };
        default { "ColorRed" };
    }
};

DZ_fnc_squadFundsUpdateMarker = {
    private _balance = missionNamespace getVariable ["DZ_squadFundsBalance", 0];
    private _pos = call DZ_fnc_squadFundsMarkerPos;
    private _color = [_balance] call DZ_fnc_squadFundsMarkerColor;
    private _label = format ["Squad funds: %1₽", _balance];

    private _markers = [
        ["DZ_squad_funds_marker",          [0,  0, 0]],
        ["DZ_squad_funds_marker_bold_1",   [2,  0, 0]],
        ["DZ_squad_funds_marker_bold_2",   [0, -2, 0]]
    ];

    {
        _x params ["_marker", "_offset"];
        private _markerPos = [
            (_pos select 0) + (_offset select 0),
            (_pos select 1) + (_offset select 1),
            0
        ];

        if (getMarkerType _marker == "") then {
            createMarker [_marker, _markerPos];
            _marker setMarkerType "mil_dot";
            _marker setMarkerSize [0.55, 0.55];
        } else {
            _marker setMarkerPos _markerPos;
        };

        _marker setMarkerColor _color;
        _marker setMarkerText _label;
        _marker setMarkerAlpha 1;
    } forEach _markers;
};


DZ_fnc_squadFundsAdjust = {
    params [
        ["_amount", 0, [0]],
        ["_reason", "", [""]]
    ];

    if (_amount == 0) exitWith { missionNamespace getVariable ["DZ_squadFundsBalance", 0] };

    private _oldValue = missionNamespace getVariable ["DZ_squadFundsBalance", 0];
    private _newValue = (_oldValue + _amount) max 0;

    missionNamespace setVariable ["DZ_squadFundsBalance", _newValue, true];
    profileNamespace setVariable ["DZ_squadFundsBalance", _newValue];
    saveProfileNamespace;

    diag_log format ["[DZ_FUNDS] %1 -> %2 (%3, %4)", _oldValue, _newValue, _amount, _reason];
    call DZ_fnc_squadFundsUpdateMarker;
    _newValue
};


DZ_fnc_squadFundsHasEnough = {
    params [["_amount", 0, [0]]];
    (missionNamespace getVariable ["DZ_squadFundsBalance", 0]) >= _amount
};


["DZ_missionEnded", {
    params [
        ["_missionId", "", [""]],
        ["_result", "", [""]],
        ["_source", "", [""]],
        ["_title", "", [""]]
    ];

    if (_result != "success") exitWith {};

    private _rewards = missionNamespace getVariable ["DZ_squadFundsMissionRewards", createHashMap];
    private _reward = _rewards getOrDefault [_missionId, 0];

    if (_reward <= 0) exitWith {
        diag_log format ["[DZ_FUNDS] No reward for mission %1", _missionId];
    };

    [_reward, format ["Mission reward: %1", _title]] call DZ_fnc_squadFundsAdjust;

    [
        format ["Награда за миссию: +%1₽. Баланс: %2₽.",
            _reward, missionNamespace getVariable ["DZ_squadFundsBalance", 0]],
        east
    ] remoteExecCall ["DZ_fnc_sideMessage", 0];
}] call CBA_fnc_addEventHandler;


call DZ_fnc_squadFundsUpdateMarker;

diag_log format ["[DZ_FUNDS] Squad funds system initialized. Balance=%1₽", _savedBalance];
