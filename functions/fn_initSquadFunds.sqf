/*
 * DZ_fnc_initSquadFunds
 * Initializes per-side persistent squad funds for LEGACY.Altis.
 *
 * Each player faction has its own wallet:
 *   - APD          (west)        → DZ_squadFundsBalance_west
 *   - Free Altis   (resistance)  → DZ_squadFundsBalance_resistance
 *
 * Persistence: profileNamespace keys with the same names as above.
 * Map markers are intentionally not rendered for wallet balances.
 *
 * Public API (all side-aware):
 *   [_amount, _reason, _side]                call DZ_fnc_squadFundsAdjust    -> new balance
 *   [_amount, _side]                         call DZ_fnc_squadFundsHasEnough -> bool
 *   [_side]                                  call DZ_fnc_squadFundsGetBalance -> Number
 *   [_side]                                  call DZ_fnc_squadFundsKeyForSide -> namespace key
 *   [_side]                                  call DZ_fnc_squadFundsUpdateMarker (cleanup hook)
 *
 * Reward routing:
 *   - DZ_missionEnded's side argument routes per-faction missions exactly
 *   - source fallback keeps old/manual callers compatible
 *   - source "auto" still pays every player side when no side is known
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["DZ_squadFundsInitialized", false]) exitWith {};
missionNamespace setVariable ["DZ_squadFundsInitialized", true];

private _initialBalance = missionNamespace getVariable ["DZ_squadFundsInitialBalance", 500];
private _playerSides    = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

DZ_fnc_squadFundsKeyForSide = {
    params ["_side"];
    switch (true) do {
        case (_side isEqualTo west):       { "DZ_squadFundsBalance_west" };
        case (_side isEqualTo resistance): { "DZ_squadFundsBalance_resistance" };
        case (_side isEqualTo east):       { "DZ_squadFundsBalance_east" };
        case (_side isEqualTo civilian):   { "DZ_squadFundsBalance_civilian" };
        default { "" };
    }
};

DZ_fnc_squadFundsGetBalance = {
    params [["_side", sideUnknown]];
    private _key = [_side] call DZ_fnc_squadFundsKeyForSide;
    if (_key == "") exitWith { 0 };
    missionNamespace getVariable [_key, 0]
};

{
    private _key   = [_x] call DZ_fnc_squadFundsKeyForSide;
    private _saved = [_key, _initialBalance] call DZ_fnc_storeGet;
    missionNamespace setVariable [_key, _saved, true];
} forEach _playerSides;

missionNamespace setVariable ["DZ_squadFundsMissionRewards", createHashMapFromArray [
    ["interdiction",     200],
    ["destroy_cache",    250],
    ["assassination",    350],
    ["downed_pilot",     400],
    ["artillery_hunt",   400],
    ["humanitarian_aid", 500],
    ["eod",              450],
    ["idap_repair",      250],
    ["air_defense",      900],
    ["defend_informant", 650],
    ["heli_intercept",   200]
]];

DZ_fnc_squadFundsMarkerPos = {
    params [["_side", west]];
    private _key      = format ["DZ_squadFundsMarkerPos_%1", str _side];
    private _override = missionNamespace getVariable [_key, []];
    if (_override isEqualType [] && { count _override >= 2 }) exitWith { _override };

    switch (true) do {
        case (_side isEqualTo east):       { [12295.449, 8772.090,  0] };
        default { [worldSize * 0.5, worldSize * 0.5, 0] };
    }
};

DZ_fnc_squadFundsMarkerColor = {
    params [["_balance", 0, [0]]];
    switch (true) do {
        case (_balance >= 2000): { "ColorGreen" };
        case (_balance >= 500):  { "ColorYellow" };
        default { "ColorRed" };
    }
};

DZ_fnc_squadFundsSideLabel = {
    params ["_side"];
    switch (true) do {
        case (_side isEqualTo east):       { "ОКСВ" };
        default { str _side };
    }
};

DZ_fnc_squadFundsUpdateMarker = {

    private _argSide = if ((count _this) > 0) then { _this # 0 } else { sideUnknown };
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _sidesToUpdate = if (_argSide isEqualTo sideUnknown) then { _playerSides } else { [_argSide] };

    {
        private _side    = _x;
        private _base    = format ["DZ_funds_%1", str _side];
        private _markers = [
            _base + "_a",
            _base + "_b",
            _base + "_c"
        ];

        {
            if (getMarkerType _x != "") then {
                deleteMarker _x;
            };
        } forEach _markers;
    } forEach _sidesToUpdate;
};

DZ_fnc_squadFundsAdjust = {
    params [
        ["_amount", 0, [0]],
        ["_reason", "", [""]],
        ["_side",   sideUnknown]
    ];

    private _key = [_side] call DZ_fnc_squadFundsKeyForSide;
    if (_key == "") exitWith {
        diag_log format ["[DZ_FUNDS] Adjust called with non-wallet side %1 (reason=%2) — ignored.", _side, _reason];
        0
    };

    if (_amount == 0) exitWith { missionNamespace getVariable [_key, 0] };

    private _oldValue = missionNamespace getVariable [_key, 0];
    private _newValue = (_oldValue + _amount) max 0;

    missionNamespace setVariable [_key, _newValue, true];
    [_key, _newValue] call DZ_fnc_storeSet;
    call DZ_fnc_storeFlush;

    diag_log format ["[DZ_FUNDS:%1] %2 -> %3 (%4, %5)",
        [_side] call DZ_fnc_squadFundsSideLabel, _oldValue, _newValue, _amount, _reason];
    [_side] call DZ_fnc_squadFundsUpdateMarker;
    _newValue
};

DZ_fnc_squadFundsHasEnough = {
    params [
        ["_amount", 0, [0]],
        ["_side",   sideUnknown]
    ];
    ([_side] call DZ_fnc_squadFundsGetBalance) >= _amount
};

["DZ_missionEnded", {
    params [
        ["_missionId", "", [""]],
        ["_result",    "", [""]],
        ["_source",    "", [""]],
        ["_title",     "", [""]],
        ["_endedSide", sideUnknown]
    ];

    if (_result != "success") exitWith {};

    private _rewards = missionNamespace getVariable ["DZ_squadFundsMissionRewards", createHashMap];
    private _reward  = _rewards getOrDefault [_missionId, 0];

    if (_reward <= 0) exitWith {
        diag_log format ["[DZ_FUNDS] No reward for mission %1", _missionId];
    };

    if (_source == "fob") then {
        private _mult = missionNamespace getVariable ["DZ_fobRewardMultiplier", 2];
        _reward = round (_reward * _mult);
    };

    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _rewardSide = if (_endedSide in _playerSides) then { _endedSide } else {
        switch (_source) do {
            case "manual": { east };
            case "fob":    { east };
            default        { sideUnknown };
        }
    };

    private _recipients  = if (_rewardSide isEqualTo sideUnknown) then { _playerSides } else { [_rewardSide] };

    {
        private _side = _x;
        [_reward, format ["Mission reward: %1 (%2)", _title, _source], _side] call DZ_fnc_squadFundsAdjust;
        [
            format ["Награда за миссию: +%1₽. Баланс: %2₽.",
                _reward, [_side] call DZ_fnc_squadFundsGetBalance],
            _side
        ] remoteExecCall ["DZ_fnc_sideMessage", 0];
    } forEach _recipients;
}] call CBA_fnc_addEventHandler;

call DZ_fnc_squadFundsUpdateMarker;

diag_log format ["[DZ_FUNDS] Squad funds initialized. APD=%1", [east] call DZ_fnc_squadFundsGetBalance];
