/*
 * DZ_fnc_initFortifyEconomy
 * Connects ACE Fortify to the mission squad funds system.
 */

private _fortifyObjects = [
    ["CamoNet_INDP_open_F",      150],
    ["Land_BagFence_Round_F",    75],
    ["Land_BagFence_Long_F",     90],
    ["Land_BagFence_Short_F",    50],
    ["Campfire_burning_F",       25],
    ["Land_BagBunker_Small_F",  450],
    ["Land_BagBunker_Tower_F",  900]
];

private _fortifySides = [west, east, resistance];

missionNamespace setVariable ["DZ_fortifyBuildCosts", createHashMapFromArray _fortifyObjects];

DZ_fnc_fortifyGetCost = {
    params [["_className", "", [""]]];
    private _costs = missionNamespace getVariable ["DZ_fortifyBuildCosts", createHashMap];
    _costs getOrDefault [_className, 0]
};

if (isServer) then {
    private _serverSetup = {
        params ["_fortifyObjects", "_fortifySides"];

        {
            private _key = [_x] call DZ_fnc_squadFundsKeyForSide;
            if (_key != "" && { isNil { missionNamespace getVariable _key } }) then {
                private _initialBalance = missionNamespace getVariable ["DZ_squadFundsInitialBalance", 500];
                private _saved = [_key, _initialBalance] call DZ_fnc_storeGet;
                missionNamespace setVariable [_key, _saved, true];
            };

            [_x, -1, _fortifyObjects] call ace_fortify_fnc_registerObjects;
        } forEach _fortifySides;

        // Build anchors: fortifications can be built near the fortify Ural
        // and near ANY vehicle whose display name contains "(Ammo)". A
        // periodic rescan keeps the list current as such vehicles spawn or
        // despawn (the old one-shot scan missed anything bought later).
        DZ_fnc_fortifyRebuildAnchors = {
            private _radius = missionNamespace getVariable ["DZ_fortifyAnchorRadius", 20];
            private _locations = [];

            {
                private _veh = _x;
                if (isNull _veh || { !alive _veh }) then { continue };

                private _isAnchor = _veh isKindOf "rhsgref_cdf_b_ural";
                if (!_isAnchor) then {
                    private _name = toLower (getText (configOf _veh >> "displayName"));
                    _isAnchor = (_name find "(ammo)") >= 0;
                };

                if (_isAnchor) then {
                    _locations pushBack [_veh, _radius, _radius, 0, false];
                };
            } forEach vehicles;

            ace_fortify_locations = _locations;
            publicVariable "ace_fortify_locations";
        };

        call DZ_fnc_fortifyRebuildAnchors;

        if !(missionNamespace getVariable ["DZ_fortifyAnchorRescanStarted", false]) then {
            missionNamespace setVariable ["DZ_fortifyAnchorRescanStarted", true];
            [] spawn {
                while { true } do {
                    sleep (missionNamespace getVariable ["DZ_fortifyAnchorRescanInterval", 15]);
                    call DZ_fnc_fortifyRebuildAnchors;
                };
            };
        };

        if !(missionNamespace getVariable ["DZ_fortifyEconomyServerEventsAdded", false]) then {
            missionNamespace setVariable ["DZ_fortifyEconomyServerEventsAdded", true];

            ["acex_fortify_objectPlaced", {
                params ["_builder", "_side", "_object"];

                private _className = typeOf _object;
                private _cost = [_className] call DZ_fnc_fortifyGetCost;
                if (_cost <= 0) exitWith {};

                private _builderSide = if (isNull _builder) then { _side } else { side group _builder };
                private _replyTarget = [owner _builder, 0] select (isNull _builder);
                private _label = [_builderSide] call DZ_fnc_squadFundsSideLabel;

                if !([_cost, _builderSide] call DZ_fnc_squadFundsHasEnough) exitWith {
                    private _balance = [_builderSide] call DZ_fnc_squadFundsGetBalance;
                    deleteVehicle _object;
                    [
                        "Строительство",
                        format ["Недостаточно финансирования у %1. Цена: %2.", _label, _cost]
                    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
                };

                private _newBalance = [
                    0 - _cost,
                    format ["Fortify build: %1 by %2", _className, name _builder],
                    _builderSide
                ] call DZ_fnc_squadFundsAdjust;

                _object setVariable ["DZ_noCleanup", true, true];
                _object setVariable ["DZ_fortifyBuilt", true, true];
                _object setVariable ["DZ_fortifyCost", _cost, true];
                [_object] call DZ_fnc_markPersistent;
                [true] call DZ_fnc_saveAssets;

            }] call CBA_fnc_addEventHandler;
        };
    };

    [
        { !isNil "ace_fortify_fnc_registerObjects" && !isNil "DZ_fnc_squadFundsHasEnough" && time > 2 },
        _serverSetup,
        [_fortifyObjects, _fortifySides]
    ] call CBA_fnc_waitUntilAndExecute;
};

if (hasInterface) then {
    private _clientSetup = {
        if (missionNamespace getVariable ["DZ_fortifyEconomyClientHandlerAdded", false]) exitWith {};
        missionNamespace setVariable ["DZ_fortifyEconomyClientHandlerAdded", true];

        [{
            params ["_unit", "_object", "_aceCost"];

            private _className = typeOf _object;
            private _cost = [_className] call DZ_fnc_fortifyGetCost;
            private _unitSide = side group _unit;
            private _key = switch (true) do {
                case (_unitSide isEqualTo west): { "DZ_squadFundsBalance_west" };
                case (_unitSide isEqualTo resistance): { "DZ_squadFundsBalance_resistance" };
                case (_unitSide isEqualTo east): { "DZ_squadFundsBalance_east" };
                case (_unitSide isEqualTo civilian): { "DZ_squadFundsBalance_civilian" };
                default { "" };
            };
            private _balance = missionNamespace getVariable [_key, 0];
            private _objectName = getText (configFile >> "CfgVehicles" >> _className >> "displayName");
            if (_objectName isEqualTo "") then { _objectName = _className };

            if (_cost > 0 && {_balance >= _cost}) exitWith {
                [
                    "Строительство",
                    format ["Объект: %1<br/>Цена: %2", _objectName, _cost]
                ] call DZ_fnc_showHint;

                true
            };

            if (_cost <= 0) exitWith { true };

            [
                "Строительство",
                format ["Объект: %1<br/>Недостаточно финансирования.<br/>Нужно: %2", _objectName, _cost]
            ] call DZ_fnc_showHint;

            false
        }] call ace_fortify_fnc_addDeployHandler;
    };

    [
        { !isNil "ace_fortify_fnc_addDeployHandler" && !isNil "DZ_fnc_showHint" },
        _clientSetup,
        []
    ] call CBA_fnc_waitUntilAndExecute;
};
