/*
 * DZ_fnc_initSupplySystem
 * Phase 1 of the Reforger-style Снабжение (supply) layer.
 *
 * Supplies are a physical, haulable resource stored in "containers":
 *   - the fixed base stockpile (logical, keyed to logistics_point)
 *   - deployed КШМ vehicles (forward stockpiles)
 *   - ammo trucks (GAZ-66 Ammo / any "(ammo)" vehicle) — mobile,
 *     doubling as ACE Fortify build anchors.
 *
 * This file only builds the framework: the container model, the
 * DZ_fnc_supply* helper API, server-side registration/rescan/persistence,
 * a passive base trickle (recovery floor) and a Draw3D HUD readout.
 * The sinks (fortify / shop / spawn) and the haul loop are later phases.
 *
 * Called from BOTH initServer.sqf (server block) and initPlayerLocal.sqf
 * (client block); both halves are idempotent.
 *
 * Supplies interact with the existing systems, not replace them:
 *   ₽ (DZ_squadFunds*)  = strategic budget — buys vehicles/gear
 *   Снабжение (this)    = tactical stock   — builds / rearms / spawns
 *   Репутация (ALFA_*)  = multiplier on the loop (later phase)
 */

if (isNil "DZ_supplyBaseCap")          then { DZ_supplyBaseCap          = 6000; };
if (isNil "DZ_supplyBaseStart")        then { DZ_supplyBaseStart        = 3000; };
if (isNil "DZ_supplyKshmCap")          then { DZ_supplyKshmCap          = 1500; };
if (isNil "DZ_supplyKshmStart")        then { DZ_supplyKshmStart        =  750; };
if (isNil "DZ_supplyTruckCap")         then { DZ_supplyTruckCap         = 1500; };
if (isNil "DZ_supplyBaseRegen")        then { DZ_supplyBaseRegen        =   50; };
if (isNil "DZ_supplyBaseRegenInterval") then { DZ_supplyBaseRegenInterval = 300; };
if (isNil "DZ_supplyContainerRescanInterval") then { DZ_supplyContainerRescanInterval = 15; };
if (isNil "DZ_supplyHudRange")         then { DZ_supplyHudRange         =   60; };

DZ_fnc_supplyGet = {
    params [["_c", objNull]];
    if (_c isEqualType "") exitWith { missionNamespace getVariable ["DZ_supplyStock_base", 0] };
    if (isNull _c) exitWith { 0 };
    _c getVariable ["DZ_supplies", 0]
};

DZ_fnc_supplyMax = {
    params [["_c", objNull]];
    if (_c isEqualType "") exitWith { missionNamespace getVariable ["DZ_supplyBaseCap", 6000] };
    if (isNull _c) exitWith { 0 };
    _c getVariable ["DZ_suppliesMax", missionNamespace getVariable ["DZ_supplyTruckCap", 1500]]
};

DZ_fnc_supplyHasEnough = {
    params [["_c", objNull], ["_amt", 0]];
    ([_c] call DZ_fnc_supplyGet) >= _amt
};

DZ_fnc_supplyAdjust = {
    if (!isServer) exitWith { 0 };
    params [["_c", objNull], ["_delta", 0], ["_reason", ""]];

    private _isBase = _c isEqualType "";
    if (!_isBase && { isNull _c }) exitWith { 0 };

    private _cur = [_c] call DZ_fnc_supplyGet;
    private _max = [_c] call DZ_fnc_supplyMax;
    private _new = ((_cur + _delta) max 0) min _max;

    if (_isBase) then {
        missionNamespace setVariable ["DZ_supplyStock_base", _new, true];
        ["DZ_supplyStock_base", _new] call DZ_fnc_storeSet;
        call DZ_fnc_storeFlush;
    } else {
        _c setVariable ["DZ_supplies", _new, true];
        missionNamespace setVariable ["DZ_assetsDirty", true];
    };

    diag_log format ["[DZ_SUPPLY] %1: %2 -> %3 (%4)",
        (if (_isBase) then { "base" } else { typeOf _c }), _cur, _new, _reason];

    _new
};

DZ_fnc_supplyRegisterContainer = {
    params [["_obj", objNull], ["_max", 1500], ["_kind", "truck"], ["_startFill", -1]];
    if (isNull _obj) exitWith {};

    if (isNil { _obj getVariable "DZ_suppliesMax" }) then {
        _obj setVariable ["DZ_suppliesMax", _max, true];
        _obj setVariable ["DZ_supplyKind", _kind, true];
    };

    if (isNil { _obj getVariable "DZ_supplies" }) then {
        private _fill = if (_startFill < 0) then { _max } else { _startFill };
        _obj setVariable ["DZ_supplies", _fill, true];
    };
};

DZ_fnc_supplyIsContainer = {
    params [["_veh", objNull]];
    if (isNull _veh) exitWith { false };
    if (_veh isKindOf "rhsgref_cdf_b_ural") exitWith { true };
    if (_veh getVariable ["kshm_deployed", false]) exitWith { true };
    private _nm = toLower (getText (configOf _veh >> "displayName"));
    (_nm find "(ammo)") >= 0
};

DZ_fnc_supplyNearestContainer = {
    params [["_pos", [0,0,0]], ["_radius", 20], ["_minStock", 0]];
    private _best = objNull;
    private _bestDist = _radius + 1;
    {
        private _veh = _x;
        if (isNull _veh || { !alive _veh }) then { continue };
        if (([_veh] call DZ_fnc_supplyGet) < _minStock) then { continue };
        private _d = _pos distance (getPosATL _veh);
        if (_d <= _radius && { _d < _bestDist }) then {
            _bestDist = _d;
            _best = _veh;
        };
    } forEach (missionNamespace getVariable ["DZ_supplyContainers", []]);
    _best
};

if (isServer) then {
    private _serverSetup = {
        if (missionNamespace getVariable ["DZ_supplyServerStarted", false]) exitWith {};
        missionNamespace setVariable ["DZ_supplyServerStarted", true];

        private _saved = ["DZ_supplyStock_base", DZ_supplyBaseStart] call DZ_fnc_storeGet;
        if !(_saved isEqualType 0) then { _saved = DZ_supplyBaseStart };
        missionNamespace setVariable ["DZ_supplyStock_base", (_saved max 0) min DZ_supplyBaseCap, true];

        private _baseObj = missionNamespace getVariable ["logistics_point", objNull];
        private _basePos = if (!isNull _baseObj) then { getPosATL _baseObj } else { [8262.683, 3772.911, 76.472] };
        missionNamespace setVariable ["DZ_supplyBasePos", _basePos, true];

        DZ_fnc_supplyRebuildContainers = {
            private _list = [];
            {
                private _veh = _x;
                if (isNull _veh || { !alive _veh }) then { continue };

                private _isKshm = _veh getVariable ["kshm_deployed", false];
                private _isTruck = false;
                if (!_isKshm) then {
                    _isTruck = _veh isKindOf "rhsgref_cdf_b_ural";
                    if (!_isTruck) then {
                        private _nm = toLower (getText (configOf _veh >> "displayName"));
                        _isTruck = (_nm find "(ammo)") >= 0;
                    };
                };

                if (_isKshm) then {
                    [_veh, DZ_supplyKshmCap, "kshm", DZ_supplyKshmStart] call DZ_fnc_supplyRegisterContainer;
                    _list pushBack _veh;
                };
                if (_isTruck) then {
                    [_veh, DZ_supplyTruckCap, "truck", -1] call DZ_fnc_supplyRegisterContainer;
                    _list pushBack _veh;
                };
            } forEach vehicles;

            if (isNil "DZ_supplyContainers" || { !(_list isEqualTo DZ_supplyContainers) }) then {
                DZ_supplyContainers = _list;
                publicVariable "DZ_supplyContainers";
            };
        };

        call DZ_fnc_supplyRebuildContainers;

        [] spawn {
            while { true } do {
                sleep (missionNamespace getVariable ["DZ_supplyContainerRescanInterval", 15]);
                call DZ_fnc_supplyRebuildContainers;
            };
        };

        [] spawn {
            while { true } do {
                sleep (missionNamespace getVariable ["DZ_supplyBaseRegenInterval", 300]);
                private _regen = missionNamespace getVariable ["DZ_supplyBaseRegen", 50];
                if (_regen > 0 && { ([("base")] call DZ_fnc_supplyGet) < DZ_supplyBaseCap }) then {
                    ["base", _regen, "passive base regen"] call DZ_fnc_supplyAdjust;
                };
            };
        };

        diag_log format ["[DZ_SUPPLY] Server framework online. Base stock %1/%2 at %3.",
            missionNamespace getVariable ["DZ_supplyStock_base", 0], DZ_supplyBaseCap, _basePos];
    };

    [
        { !isNil "DZ_fnc_storeGet" && !isNil "DZ_fnc_storeSet" && time > 2 },
        _serverSetup,
        []
    ] call CBA_fnc_waitUntilAndExecute;
};

if (hasInterface) then {
    if (missionNamespace getVariable ["DZ_supplyHudAdded", false]) exitWith {};
    missionNamespace setVariable ["DZ_supplyHudAdded", true];

    addMissionEventHandler ["Draw3D", {
        private _camPos = positionCameraToWorld [0, 0, 0];
        private _range  = missionNamespace getVariable ["DZ_supplyHudRange", 60];

        {
            private _veh = _x;
            if (isNull _veh || { !alive _veh }) then { continue };
            private _pos = getPosATL _veh;
            if ((_camPos distance _pos) > _range) then { continue };

            private _cur  = _veh getVariable ["DZ_supplies", 0];
            private _max  = _veh getVariable ["DZ_suppliesMax", 0];
            private _kind = _veh getVariable ["DZ_supplyKind", "truck"];
            private _tag  = if (_kind isEqualTo "kshm") then { "КШМ" } else { "Снабжение" };

            drawIcon3D [
                "",
                [1, 0.85, 0.3, 1],
                _pos vectorAdd [0, 0, 2.2],
                0, 0, 0,
                format ["%1: %2/%3", _tag, round _cur, round _max],
                1, 0.03, "PuristaMedium"
            ];
        } forEach (missionNamespace getVariable ["DZ_supplyContainers", []]);

        private _bp = missionNamespace getVariable ["DZ_supplyBasePos", []];
        if (_bp isEqualType [] && { (count _bp) >= 2 } && { (_camPos distance _bp) < 90 }) then {
            private _bc = missionNamespace getVariable ["DZ_supplyStock_base", 0];
            private _bm = missionNamespace getVariable ["DZ_supplyBaseCap", 6000];
            drawIcon3D [
                "",
                [0.5, 0.85, 1, 1],
                [_bp # 0, _bp # 1, (_bp # 2) + 2.5],
                0, 0, 0,
                format ["Склад базы: %1/%2", round _bc, round _bm],
                1, 0.035, "PuristaMedium"
            ];
        };
    }];
};

true
