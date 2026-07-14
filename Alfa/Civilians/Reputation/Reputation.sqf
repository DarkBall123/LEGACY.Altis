/*
 * Alfa/Civilians/Reputation/Reputation.sqf
 * Per-side civilian reputation pools for ChudoYudo.
 *
 * Each player faction has its own standing with the civilian
 * population:
 *   - APD          (west)        → ALFA_civilianReputation_west
 *   - Free Altis   (resistance)  → ALFA_civilianReputation_resistance
 *
 * Persistence: profileNamespace under the same key names.
 *
 * Public API (all side-aware):
 *   [_amount, _reason, _side]         call ALFA_fnc_repAdjust       -> new rep for that side
 *   [_side]                           call ALFA_fnc_repGet           -> Number
 *   [_side]                           call ALFA_fnc_repKeyForSide   -> profile key
 *   [_side]                           call ALFA_fnc_repUpdateMarker (or no arg → all sides)
 *
 * Back-compat: the legacy global `ALFA_civilianReputation` is kept
 * in sync with the LOWEST per-side value, so older consumers
 * (setupCivilianReaction.sqf, etc.) see the worst-case standing —
 * civilians grow afraid of whichever faction is most hated.
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["ALFA_repInitialized", false]) exitWith {};
missionNamespace setVariable ["ALFA_repInitialized", true];

private _initialRep   = missionNamespace getVariable ["ALFA_repInitialValue", 50];
private _playerSides  = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

missionNamespace setVariable ["ALFA_repCivilianKilledPenalty", missionNamespace getVariable ["ALFA_repCivilianKilledPenalty", -0.5]];
missionNamespace setVariable ["ALFA_repWaterReward",           missionNamespace getVariable ["ALFA_repWaterReward",            0.1]];

if (isNil { missionNamespace getVariable "ALFA_repWaterItems" }) then {
    missionNamespace setVariable ["ALFA_repWaterItems", [
        "ACE_WaterBottle",
        "ACE_Canteen",
        "ACE_Can_Franta",
        "ACE_Can_RedGull",
        "ACE_Humanitarian_Ration"
    ]];
};

if (isNil { missionNamespace getVariable "ALFA_repRationItems" }) then {
    missionNamespace setVariable ["ALFA_repRationItems", ["ACE_MRE_BeefStew"]];
};

if (isNil { missionNamespace getVariable "ALFA_repMissionRewards" }) then {
    missionNamespace setVariable ["ALFA_repMissionRewards", createHashMapFromArray [
        ["artillery_hunt",   0.4],
        ["assassination",    0.3],
        ["idap_repair",      0.5],
        ["air_defense",      0.4],
        ["defend_informant", 0.5],
        ["heli_intercept",   0.3]
    ]];
};

ALFA_fnc_repKeyForSide = {
    params ["_side"];
    switch (true) do {
        case (_side isEqualTo west):       { "ALFA_civilianReputation_west" };
        case (_side isEqualTo resistance): { "ALFA_civilianReputation_resistance" };
        case (_side isEqualTo east):       { "ALFA_civilianReputation_east" };
        case (_side isEqualTo civilian):   { "ALFA_civilianReputation_civilian" };
        default { "" };
    }
};

ALFA_fnc_repSideLabel = {
    params ["_side"];
    switch (true) do {
        case (_side isEqualTo east):       { "ОКСВ" };
        default { str _side };
    }
};

ALFA_fnc_repGet = {
    params [["_side", sideUnknown]];
    private _key = [_side] call ALFA_fnc_repKeyForSide;
    if (_key == "") exitWith { 50 };
    missionNamespace getVariable [_key, 50]
};

ALFA_fnc_repRecomputeGlobal = {
    private _sides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _values = _sides apply { [_x] call ALFA_fnc_repGet };
    private _lowest = if (_values isEqualTo []) then { 50 } else { selectMin _values };

    missionNamespace setVariable ["ALFA_civilianReputation", _lowest, true];
    publicVariable "ALFA_civilianReputation";
    _lowest
};

{
    private _key   = [_x] call ALFA_fnc_repKeyForSide;
    private _saved = [_key, _initialRep] call DZ_fnc_storeGet;
    missionNamespace setVariable [_key, _saved, true];
} forEach _playerSides;

call ALFA_fnc_repRecomputeGlobal;

ALFA_fnc_repMarkerColor = {
    params [["_rep", 50, [0]]];
    switch (true) do {
        case (_rep >= 70): { "ColorGreen" };
        case (_rep >= 40): { "ColorYellow" };
        default { "ColorRed" };
    }
};

ALFA_fnc_repMarkerPos = {
    params [["_side", west]];
    private _key      = format ["ALFA_repMarkerPos_%1", str _side];
    private _override = missionNamespace getVariable [_key, []];
    if (_override isEqualType [] && { count _override >= 2 }) exitWith { _override };

    switch (true) do {
        case (_side isEqualTo east):       { [28000.033, 2998.383, 0] };
        default { [3726.053, 12915.728, 0] };
    }
};

ALFA_fnc_repUpdateMarker = {

    private _argSide       = if ((count _this) > 0) then { _this # 0 } else { sideUnknown };
    private _playerSides   = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _sidesToUpdate = if (_argSide isEqualTo sideUnknown) then { _playerSides } else { [_argSide] };

    {
        private _side    = _x;
        private _rep     = [_side] call ALFA_fnc_repGet;
        private _pos     = [_side] call ALFA_fnc_repMarkerPos;
        private _color   = [_rep]  call ALFA_fnc_repMarkerColor;
        private _faction = [_side] call ALFA_fnc_repSideLabel;
        private _label   = format ["%1 rep: %2", _faction, (_rep toFixed 1)];

        private _base    = format ["ALFA_civ_rep_%1", str _side];
        private _markers = [
            [_base + "_a", [0,  0, 0]],
            [_base + "_b", [2,  0, 0]],
            [_base + "_c", [0, -2, 0]]
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
            _marker setMarkerText  _label;
            _marker setMarkerAlpha 1;
        } forEach _markers;
    } forEach _sidesToUpdate;
};

ALFA_fnc_repAdjust = {
    params [
        ["_amount", 0,             [0]],
        ["_reason", "",            [""]],
        ["_side",   sideUnknown]
    ];

    private _key = [_side] call ALFA_fnc_repKeyForSide;
    if (_key == "") exitWith {
        diag_log format ["[ALFA_REP] Adjust called with non-player side %1 (reason=%2) — ignored.", _side, _reason];
        50
    };

    if (_amount == 0) exitWith { missionNamespace getVariable [_key, 50] };

    private _oldValue = missionNamespace getVariable [_key, 50];
    private _newValue = ((_oldValue + _amount) max 0) min 100;

    missionNamespace setVariable [_key, _newValue, true];
    [_key, _newValue] call DZ_fnc_storeSet;
    call DZ_fnc_storeFlush;

    diag_log format ["[ALFA_REP:%1] %2 -> %3 (%4, %5)",
        [_side] call ALFA_fnc_repSideLabel, _oldValue, _newValue, _amount, _reason];

    [_side] call ALFA_fnc_repUpdateMarker;
    call ALFA_fnc_repRecomputeGlobal;
    _newValue
};

ALFA_fnc_repTakeWaterItem = {
    params [["_player", objNull, [objNull]]];
    if (isNull _player) exitWith { false };

    private _waterItems = missionNamespace getVariable ["ALFA_repWaterItems", []];
    private _taken      = false;

    {
        if (_x in items _player) exitWith {
            _player removeItem _x;
            _taken = true;
        };
        if (_x in magazines _player) exitWith {
            _player removeMagazine _x;
            _taken = true;
        };
    } forEach _waterItems;

    _taken
};

ALFA_fnc_repTakeRationItem = {
    params [["_player", objNull, [objNull]]];
    if (isNull _player) exitWith { false };

    private _rationItems = missionNamespace getVariable ["ALFA_repRationItems", ["ACE_MRE_BeefStew"]];
    private _taken       = false;

    {
        if (_x in items _player) exitWith {
            _player removeItem _x;
            _taken = true;
        };
        if (_x in magazines _player) exitWith {
            _player removeMagazine _x;
            _taken = true;
        };
    } forEach _rationItems;

    _taken
};

ALFA_fnc_repPlayerSideOf = {

    params [["_unit", objNull, [objNull]]];
    if (isNull _unit) exitWith { sideUnknown };

    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _candidate   = side _unit;
    if (_candidate in _playerSides) exitWith { _candidate };
    sideUnknown
};

ALFA_fnc_repGiveRation = {
    params [
        ["_civilian", objNull, [objNull]],
        ["_player",   objNull, [objNull]]
    ];

    if (isNull _civilian || { isNull _player }) exitWith {};
    if (!alive _civilian || { !alive _player }) exitWith {};
    if !(_civilian getVariable ["ALFA_repTrackedCivilian", false]) exitWith {};
    if (_civilian getVariable ["ALFA_repWaterGiven", false]) exitWith {};
    if (_player distance2D _civilian > 4) exitWith {};

    private _side = [_player] call ALFA_fnc_repPlayerSideOf;
    if (_side isEqualTo sideUnknown) exitWith {};
    if !([_player] call ALFA_fnc_repTakeRationItem) exitWith {};

    _civilian setVariable ["ALFA_repWaterGiven", true, true];
    [
        missionNamespace getVariable ["ALFA_repWaterReward", 0.1],
        format ["%1 (%2) gave a ration to a civilian.", name _player, [_side] call ALFA_fnc_repSideLabel],
        _side
    ] call ALFA_fnc_repAdjust;
};

ALFA_fnc_repGiveWater = {
    params [
        ["_civilian", objNull, [objNull]],
        ["_player",   objNull, [objNull]]
    ];

    if (isNull _civilian || { isNull _player }) exitWith {};
    if (!alive _civilian || { !alive _player }) exitWith {};
    if !(_civilian getVariable ["ALFA_repTrackedCivilian", false]) exitWith {};
    if (_civilian getVariable ["ALFA_repWaterGiven", false]) exitWith {};
    if (_player distance2D _civilian > 4) exitWith {};

    private _side = [_player] call ALFA_fnc_repPlayerSideOf;
    if (_side isEqualTo sideUnknown) exitWith {};
    if !([_player] call ALFA_fnc_repTakeWaterItem) exitWith {};

    _civilian setVariable ["ALFA_repWaterGiven", true, true];
    [
        missionNamespace getVariable ["ALFA_repWaterReward", 0.1],
        format ["%1 (%2) helped a civilian.", name _player, [_side] call ALFA_fnc_repSideLabel],
        _side
    ] call ALFA_fnc_repAdjust;
};

ALFA_fnc_repPlayerCausedDeath = {
    params [
        ["_killer",     objNull, [objNull]],
        ["_instigator", objNull, [objNull]]
    ];

    private _source = if (!isNull _instigator) then { _instigator } else { _killer };
    if (isNull _source) exitWith { false };
    if (isPlayer _source) exitWith { true };

    private _vehicle = vehicle _source;
    if (!isNull _vehicle && { _vehicle != _source }) exitWith {
        ({ isPlayer _x } count crew _vehicle) > 0
    };

    if (_source isKindOf "LandVehicle" || { _source isKindOf "Air" } || { _source isKindOf "Ship" }) exitWith {
        ({ isPlayer _x } count crew _source) > 0
    };

    false
};

ALFA_fnc_repResolveDeathSide = {

    params [
        ["_killer",     objNull, [objNull]],
        ["_instigator", objNull, [objNull]]
    ];

    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

    {
        if (!isNull _x && { isPlayer _x } && { (side _x) in _playerSides }) exitWith { side _x };
        sideUnknown
    } forEach [_instigator, _killer];

    private _result = sideUnknown;
    {
        if (isNull _x) then { continue };
        if (isPlayer _x && { (side _x) in _playerSides }) exitWith {
            _result = side _x;
        };
        private _veh = vehicle _x;
        if (!isNull _veh && { _veh != _x }) then {
            private _playerCrew = (crew _veh) select { isPlayer _x && { (side _x) in _playerSides } };
            if (_playerCrew isNotEqualTo []) exitWith {
                _result = side (_playerCrew # 0);
            };
        };
    } forEach [_instigator, _killer];

    _result
};

ALFA_fnc_repRegisterCivilian = {
    params [["_civilian", objNull, [objNull]]];

    if (isNull _civilian) exitWith {};
    if (!alive _civilian) exitWith {};
    if !(side group _civilian isEqualTo civilian) exitWith {};
    if (_civilian getVariable ["ALFA_repTrackedCivilian", false]) exitWith {};

    _civilian setVariable ["ALFA_repTrackedCivilian", true, true];

    _civilian addMPEventHandler ["MPKilled", {
        params ["_unit", "_killer", "_instigator"];

        if (!isServer) exitWith {};
        if (_unit getVariable ["ALFA_repDeathHandled", false]) exitWith {};
        _unit setVariable ["ALFA_repDeathHandled", true, true];

        if !([_killer, _instigator] call ALFA_fnc_repPlayerCausedDeath) exitWith {};

        private _side = [_killer, _instigator] call ALFA_fnc_repResolveDeathSide;
        if (_side isEqualTo sideUnknown) exitWith {
            diag_log format ["[ALFA_REP] Civ %1 killed by player action but no player-side attributable.", name _unit];
        };

        [
            missionNamespace getVariable ["ALFA_repCivilianKilledPenalty", -0.5],
            format ["A civilian was killed by %1 actions.", [_side] call ALFA_fnc_repSideLabel],
            _side
        ] call ALFA_fnc_repAdjust;
    }];

    [
        _civilian,
        [
            "Give water",
            "[(_this select 0), (_this select 1)] remoteExecCall ['ALFA_fnc_repGiveWater', 2];",
            nil,
            1.5,
            true,
            true,
            "",
            "alive _target && {vehicle _target isEqualTo _target} && {!(_target getVariable ['ALFA_repWaterGiven', false])} && {_this distance _target < 3}",
            3,
            false,
            "",
            ""
        ]
    ] remoteExec ["addAction", 0, _civilian];

    [
        _civilian,
        [
            "Give ration",
            "[(_this select 0), (_this select 1)] remoteExecCall ['ALFA_fnc_repGiveRation', 2];",
            nil,
            1.5,
            true,
            true,
            "",
            "alive _target && {vehicle _target isEqualTo _target} && {!(_target getVariable ['ALFA_repWaterGiven', false])} && {_this distance _target < 3} && {('ACE_MRE_BeefStew' in items _this) || {'ACE_MRE_BeefStew' in magazines _this}}",
            3,
            false,
            "",
            ""
        ]
    ] remoteExec ["addAction", 0, _civilian];
};

call ALFA_fnc_repUpdateMarker;

[] spawn {
    while { true } do {
        call ALFA_fnc_repUpdateMarker;

        {
            [_x] call ALFA_fnc_repRegisterCivilian;
        } forEach (allUnits select {
            alive _x
            && { side group _x isEqualTo civilian }
            && { !(_x getVariable ["ALFA_repTrackedCivilian", false]) }
        });

        sleep 5;
    };
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

    private _rewards = missionNamespace getVariable ["ALFA_repMissionRewards", createHashMap];
    private _amount  = _rewards getOrDefault [_missionId, 0];
    if (_amount == 0) exitWith {};

    if (_source == "fob") then {
        private _mult = missionNamespace getVariable ["DZ_fobRewardMultiplier", 2];
        _amount = _amount * _mult;
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

    private _reason = switch (_missionId) do {
        case "artillery_hunt":   { "Mortar position destroyed." };
        case "assassination":    { "Field commander eliminated." };
        case "idap_repair":      { "Red Cross vehicle repaired and crew rescued." };
        case "air_defense":      { "Enemy air-defense network destroyed." };
        case "defend_informant": { "Informant defended and extracted." };
        case "heli_intercept":   { "Enemy helicopter intercepted." };
        default                  { format ["Mission completed: %1", _title] };
    };

    {
        [_amount, _reason, _x] call ALFA_fnc_repAdjust;
    } forEach _recipients;
}] call CBA_fnc_addEventHandler;

diag_log format ["[ALFA_REP] Per-side civilian reputation initialized. APD=%1 FreeAltis=%2",
    [west] call ALFA_fnc_repGet,
    [resistance] call ALFA_fnc_repGet];
