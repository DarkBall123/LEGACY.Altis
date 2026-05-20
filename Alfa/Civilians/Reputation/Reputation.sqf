/*
 * Alfa/Civilians/Reputation/Reputation.sqf
 * Maintains persistent civilian reputation state and map markers.
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["ALFA_repInitialized", false]) exitWith {};
missionNamespace setVariable ["ALFA_repInitialized", true];

private _savedRep = profileNamespace getVariable ["ALFA_civilianReputation", 50];
missionNamespace setVariable ["ALFA_civilianReputation", _savedRep, true];
missionNamespace setVariable ["ALFA_repCivilianKilledPenalty", missionNamespace getVariable ["ALFA_repCivilianKilledPenalty", -0.5]];
missionNamespace setVariable ["ALFA_repWaterReward", missionNamespace getVariable ["ALFA_repWaterReward", 0.1]];

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
    missionNamespace setVariable ["ALFA_repRationItems", [
        "ACE_MRE_BeefStew"
    ]];
};

if (isNil { missionNamespace getVariable "ALFA_repMissionRewards" }) then {
    missionNamespace setVariable ["ALFA_repMissionRewards", createHashMapFromArray [
        ["artillery_hunt", 0.4],
        ["assassination",  0.3],
        ["idap_repair",    0.5]
    ]];
};

ALFA_fnc_repMarkerColor = {
    params [["_rep", 50, [0]]];
    switch (true) do {
        case (_rep >= 70): { "ColorGreen" };
        case (_rep >= 40): { "ColorYellow" };
        default { "ColorRed" };
    }
};

ALFA_fnc_repMarkerPos = {
    private _pos = missionNamespace getVariable ["ALFA_repMarkerPos", []];
    if (_pos isEqualType [] && { count _pos >= 2 }) exitWith { _pos };

    [10400, -100, 0]
};

ALFA_fnc_repUpdateMarker = {
    private _rep = missionNamespace getVariable ["ALFA_civilianReputation", 50];
    private _pos = call ALFA_fnc_repMarkerPos;
    private _color = [_rep] call ALFA_fnc_repMarkerColor;
    private _label = format ["Civilian reputation: %1", (_rep toFixed 1)];
    private _markers = [
        ["ALFA_civilian_reputation_marker", [0, 0, 0]],
        ["ALFA_civilian_reputation_marker_bold_1", [2, 0, 0]],
        ["ALFA_civilian_reputation_marker_bold_2", [0, -2, 0]]
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

    publicVariable "ALFA_civilianReputation";
};

ALFA_fnc_repAdjust = {
    params [
        ["_amount", 0, [0]],
        ["_reason", "", [""]]
    ];

    if (_amount == 0) exitWith { missionNamespace getVariable ["ALFA_civilianReputation", 50] };

    private _oldValue = missionNamespace getVariable ["ALFA_civilianReputation", 50];
    private _newValue = ((_oldValue + _amount) max 0) min 100;

    missionNamespace setVariable ["ALFA_civilianReputation", _newValue, true];
    profileNamespace setVariable ["ALFA_civilianReputation", _newValue];
    saveProfileNamespace;

    diag_log format ["[ALFA_REP] %1 -> %2 (%3, %4)", _oldValue, _newValue, _amount, _reason];
    call ALFA_fnc_repUpdateMarker;
    _newValue
};

ALFA_fnc_repTakeWaterItem = {
    params [["_player", objNull, [objNull]]];

    if (isNull _player) exitWith { false };

    private _waterItems = missionNamespace getVariable ["ALFA_repWaterItems", []];
    private _taken = false;

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
    private _taken = false;

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

ALFA_fnc_repGiveRation = {
    params [
        ["_civilian", objNull, [objNull]],
        ["_player", objNull, [objNull]]
    ];

    if (isNull _civilian || { isNull _player }) exitWith {};
    if (!alive _civilian || { !alive _player }) exitWith {};
    if !(_civilian getVariable ["ALFA_repTrackedCivilian", false]) exitWith {};
    if (_civilian getVariable ["ALFA_repWaterGiven", false]) exitWith {};
    if (_player distance2D _civilian > 4) exitWith {};
    if !([_player] call ALFA_fnc_repTakeRationItem) exitWith {};

    _civilian setVariable ["ALFA_repWaterGiven", true, true];
    [missionNamespace getVariable ["ALFA_repWaterReward", 0.1], format ["%1 gave a ration to a civilian.", name _player]] call ALFA_fnc_repAdjust;
};

ALFA_fnc_repGiveWater = {
    params [
        ["_civilian", objNull, [objNull]],
        ["_player", objNull, [objNull]]
    ];

    if (isNull _civilian || { isNull _player }) exitWith {};
    if (!alive _civilian || { !alive _player }) exitWith {};
    if !(_civilian getVariable ["ALFA_repTrackedCivilian", false]) exitWith {};
    if (_civilian getVariable ["ALFA_repWaterGiven", false]) exitWith {};
    if (_player distance2D _civilian > 4) exitWith {};
    if !([_player] call ALFA_fnc_repTakeWaterItem) exitWith {};

    _civilian setVariable ["ALFA_repWaterGiven", true, true];
    [missionNamespace getVariable ["ALFA_repWaterReward", 0.1], format ["%1 helped a civilian.", name _player]] call ALFA_fnc_repAdjust;
};

ALFA_fnc_repPlayerCausedDeath = {
    params [
        ["_killer", objNull, [objNull]],
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

        if ([_killer, _instigator] call ALFA_fnc_repPlayerCausedDeath) then {
            [missionNamespace getVariable ["ALFA_repCivilianKilledPenalty", -0.5], "A civilian was killed by player actions."] call ALFA_fnc_repAdjust;
        };
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
        ["_result", "", [""]],
        ["_source", "", [""]],
        ["_title", "", [""]]
    ];

    if (_result != "success") exitWith {};

    private _rewards = missionNamespace getVariable ["ALFA_repMissionRewards", createHashMap];
    private _amount = _rewards getOrDefault [_missionId, 0];
    if (_amount == 0) exitWith {};

    // FOB contracts pay a multiplied reputation reward.
    if (_source == "fob") then {
        private _mult = missionNamespace getVariable ["DZ_fobRewardMultiplier", 2];
        _amount = _amount * _mult;
    };

    private _reason = switch (_missionId) do {
        case "artillery_hunt": { "Mortar position destroyed." };
        case "assassination":  { "Field commander eliminated." };
        case "idap_repair":    { "IDAP vehicle repaired and crew rescued." };
        default { format ["Mission completed: %1", _title] };
    };

    [_amount, _reason] call ALFA_fnc_repAdjust;
}] call CBA_fnc_addEventHandler;

diag_log format ["[ALFA_REP] Civilian reputation system initialized. Reputation=%1", _savedRep];
