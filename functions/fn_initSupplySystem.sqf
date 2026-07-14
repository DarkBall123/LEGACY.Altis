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
 * Provides the container model, the DZ_fnc_supply* helper API,
 * server-side registration/rescan/persistence, a passive base trickle
 * (recovery floor), node supply pools + ACE logistics transfer actions
 * (collect from node / offload to base / load from base), the spawn sink
 * (respawn costs supplies; a stockpile at zero blocks its respawn point),
 * and a Draw3D HUD. The fortify and shop sinks live in their own files.
 *
 * Called from BOTH initServer.sqf (server block) and initPlayerLocal.sqf
 * (client block); both halves are idempotent.
 *
 * Supplies interact with the existing systems, not replace them:
 *   ₽ (DZ_squadFunds*)  = strategic budget — buys vehicles/gear
 *   Снабжение (this)    = tactical stock   — builds / rearms / spawns
 *   Репутация (ALFA_*)  = multiplier on the loop (later phase)
 */

if (isNil "DZ_supplyBaseCap")          then { DZ_supplyBaseCap          = 1000; };
if (isNil "DZ_supplyBaseStart")        then { DZ_supplyBaseStart        =  500; };
if (isNil "DZ_supplyKshmCap")          then { DZ_supplyKshmCap          =  500; };
if (isNil "DZ_supplyKshmStart")        then { DZ_supplyKshmStart        =  250; };
if (isNil "DZ_supplyTruckCap")         then { DZ_supplyTruckCap         =  500; };
if (isNil "DZ_supplyBaseRegen")        then { DZ_supplyBaseRegen        =   50; };
if (isNil "DZ_supplyBaseRegenInterval") then { DZ_supplyBaseRegenInterval = 300; };
if (isNil "DZ_supplyContainerRescanInterval") then { DZ_supplyContainerRescanInterval = 15; };
if (isNil "DZ_supplyHudRange")         then { DZ_supplyHudRange         =   60; };
if (isNil "DZ_supplyNodePoolCap")      then { DZ_supplyNodePoolCap      =  600; };
if (isNil "DZ_supplyNodePerTick")      then { DZ_supplyNodePerTick      =  200; };
if (isNil "DZ_supplyNodeAccrualInterval") then { DZ_supplyNodeAccrualInterval = 300; };
if (isNil "DZ_supplyTransferRadius")   then { DZ_supplyTransferRadius   =   25; };
if (isNil "DZ_supplySpawnCost")        then { DZ_supplySpawnCost        =   20; };
if (isNil "DZ_supplySpawnBlockInterval") then { DZ_supplySpawnBlockInterval = 20; };

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

DZ_fnc_supplyNodeGet = {
    params [["_nodeId", ""]];
    private _hm = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
    _hm getOrDefault [_nodeId, 0]
};

DZ_fnc_supplyNodeSave = {
    if (!isServer) exitWith {};
    private _hm = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
    private _arr = [];
    { _arr pushBack [_x, _hm getOrDefault [_x, 0]]; } forEach (keys _hm);
    ["DZ_nodeSupplies", _arr] call DZ_fnc_storeSet;
    call DZ_fnc_storeFlush;
};

DZ_fnc_supplyNearestNode = {
    params [["_pos", [0,0,0]], ["_radius", 25]];
    private _best = "";
    private _bestDist = _radius + 1;
    {
        _x params [["_nid", ""], ["_nname", ""], ["_npos", [0,0,0]]];
        if (_npos isEqualType [] && { (count _npos) >= 2 }) then {
            private _d = _pos distance2D _npos;
            if (_d <= _radius && { _d < _bestDist }) then { _bestDist = _d; _best = _nid; };
        };
    } forEach (missionNamespace getVariable ["DZ_resourceNodes", []]);
    _best
};

DZ_fnc_supplyPlayerContainer = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith { objNull };
    private _veh = vehicle _unit;
    if (_veh != _unit && { !isNil { _veh getVariable "DZ_suppliesMax" } }) exitWith { _veh };
    [getPosATL _unit, missionNamespace getVariable ["DZ_supplyTransferRadius", 25], 0] call DZ_fnc_supplyNearestContainer
};

DZ_fnc_supplyCollectFromNode = {
    if (!isServer) exitWith {};
    params [["_unit", objNull], ["_container", objNull]];
    private _reply = [owner _unit, 0] select (isNull _unit);
    if (isNull _container) then { _container = [_unit] call DZ_fnc_supplyPlayerContainer; };
    if (isNull _container) exitWith {
        ["Логистика", "Нет транспорта-контейнера рядом (грузовик боеприпасов / КШМ)."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _nodeId = [getPosATL _container, missionNamespace getVariable ["DZ_supplyTransferRadius", 25]] call DZ_fnc_supplyNearestNode;
    if (_nodeId isEqualTo "") exitWith {
        ["Логистика", "Рядом нет ресурсной точки."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _pool = [_nodeId] call DZ_fnc_supplyNodeGet;
    private _free = ([_container] call DZ_fnc_supplyMax) - ([_container] call DZ_fnc_supplyGet);
    private _move = _pool min _free;
    if (_move <= 0) exitWith {
        ["Логистика", format ["Грузить нечего (на точке: %1, свободно в транспорте: %2).", round _pool, round _free]] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _hm = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
    _hm set [_nodeId, _pool - _move];
    missionNamespace setVariable ["DZ_nodeSupplies", _hm, true];
    publicVariable "DZ_nodeSupplies";
    call DZ_fnc_supplyNodeSave;

    [_container, _move, format ["collect from node %1", _nodeId]] call DZ_fnc_supplyAdjust;
    ["Логистика", format ["Загружено %1 снабжения. В транспорте: %2.", round _move, round ([_container] call DZ_fnc_supplyGet)]] remoteExecCall ["DZ_fnc_showHint", _reply];
};

DZ_fnc_supplyOffloadToBase = {
    if (!isServer) exitWith {};
    params [["_unit", objNull], ["_container", objNull]];
    private _reply = [owner _unit, 0] select (isNull _unit);
    if (isNull _container) then { _container = [_unit] call DZ_fnc_supplyPlayerContainer; };
    if (isNull _container) exitWith {
        ["Логистика", "Нет транспорта-контейнера рядом."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _basePos = missionNamespace getVariable ["DZ_supplyBasePos", []];
    private _radius = missionNamespace getVariable ["DZ_supplyTransferRadius", 25];
    if !(_basePos isEqualType [] && { (count _basePos) >= 2 } && { (getPosATL _container) distance2D _basePos < _radius }) exitWith {
        ["Логистика", "Подъедьте к складу базы, чтобы разгрузить."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _have = [_container] call DZ_fnc_supplyGet;
    private _free = ([("base")] call DZ_fnc_supplyMax) - ([("base")] call DZ_fnc_supplyGet);
    private _move = _have min _free;
    if (_move <= 0) exitWith {
        ["Логистика", "Разгружать нечего или склад базы полон."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    [_container, 0 - _move, "offload to base"] call DZ_fnc_supplyAdjust;
    ["base", _move, "offload to base"] call DZ_fnc_supplyAdjust;
    ["Логистика", format ["Разгружено %1 на склад базы. На складе: %2.", round _move, round ([("base")] call DZ_fnc_supplyGet)]] remoteExecCall ["DZ_fnc_showHint", _reply];
};

DZ_fnc_supplyLoadFromBase = {
    if (!isServer) exitWith {};
    params [["_unit", objNull], ["_container", objNull]];
    private _reply = [owner _unit, 0] select (isNull _unit);
    if (isNull _container) then { _container = [_unit] call DZ_fnc_supplyPlayerContainer; };
    if (isNull _container) exitWith {
        ["Логистика", "Нет транспорта-контейнера рядом."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _basePos = missionNamespace getVariable ["DZ_supplyBasePos", []];
    private _radius = missionNamespace getVariable ["DZ_supplyTransferRadius", 25];
    if !(_basePos isEqualType [] && { (count _basePos) >= 2 } && { (getPosATL _container) distance2D _basePos < _radius }) exitWith {
        ["Логистика", "Подъедьте к складу базы, чтобы загрузить."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _avail = [("base")] call DZ_fnc_supplyGet;
    private _free = ([_container] call DZ_fnc_supplyMax) - ([_container] call DZ_fnc_supplyGet);
    private _move = _avail min _free;
    if (_move <= 0) exitWith {
        ["Логистика", "Склад базы пуст или транспорт полон."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    ["base", 0 - _move, "load to truck"] call DZ_fnc_supplyAdjust;
    [_container, _move, "load from base"] call DZ_fnc_supplyAdjust;
    ["Логистика", format ["Загружено %1 в транспорт. В транспорте: %2.", round _move, round ([_container] call DZ_fnc_supplyGet)]] remoteExecCall ["DZ_fnc_showHint", _reply];
};

DZ_fnc_supplyChargeSpawn = {
    if (!isServer) exitWith {};
    params [["_unit", objNull], ["_pos", [0,0,0]]];
    if (isNull _unit) exitWith {};

    private _cost = missionNamespace getVariable ["DZ_supplySpawnCost", 20];
    if (_cost <= 0) exitWith {};

    private _c = [_pos, missionNamespace getVariable ["DZ_supplyTransferRadius", 25], 0] call DZ_fnc_supplyNearestContainer;
    if (!isNull _c && { (_c getVariable ["DZ_supplyKind", ""]) isEqualTo "kshm" }) then {
        [_c, 0 - _cost, "spawn (КШМ)"] call DZ_fnc_supplyAdjust;
    } else {
        ["base", 0 - _cost, "spawn (база)"] call DZ_fnc_supplyAdjust;
    };
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

        private _savedNodes = ["DZ_nodeSupplies", []] call DZ_fnc_storeGet;
        private _nodeHm = createHashMap;
        if (_savedNodes isEqualType []) then {
            {
                if (_x isEqualType [] && { (count _x) >= 2 }) then { _nodeHm set [_x # 0, _x # 1]; };
            } forEach _savedNodes;
        };
        missionNamespace setVariable ["DZ_nodeSupplies", _nodeHm, true];
        publicVariable "DZ_nodeSupplies";

        private _spawnMarker = "respawn_east";
        private _spawnMarkerPos = markerPos _spawnMarker;
        private _spawnMarkerData = [];
        if ((markerType _spawnMarker) != "" && { !(_spawnMarkerPos isEqualTo [0,0,0]) }) then {
            _spawnMarkerData = [
                markerType _spawnMarker,
                getMarkerColor _spawnMarker,
                markerText _spawnMarker,
                markerShape _spawnMarker,
                getMarkerSize _spawnMarker,
                markerDir _spawnMarker
            ];
        };
        missionNamespace setVariable ["DZ_supplySpawnBaseMarker", _spawnMarker, true];
        missionNamespace setVariable ["DZ_supplySpawnBaseMarkerPos",
            (if (_spawnMarkerPos isEqualTo [0,0,0]) then { [] } else { _spawnMarkerPos }), true];
        missionNamespace setVariable ["DZ_supplySpawnBaseMarkerData", _spawnMarkerData, true];

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

        [] spawn {
            while { true } do {
                sleep (missionNamespace getVariable ["DZ_supplyNodeAccrualInterval", 300]);

                private _nodeIds       = missionNamespace getVariable ["DZ_resourceNodeIds", []];
                private _nodeSectorIds = missionNamespace getVariable ["DZ_resourceNodeSectorIds", []];
                private _sectorOwner   = missionNamespace getVariable ["DZ_sectorOwner", []];
                private _playerSides   = missionNamespace getVariable ["DZ_playerSides", [east]];
                private _perTick       = missionNamespace getVariable ["DZ_supplyNodePerTick", 200];
                private _cap           = missionNamespace getVariable ["DZ_supplyNodePoolCap", 600];
                private _hm            = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
                private _changed       = false;

                {
                    private _idx      = _forEachIndex;
                    private _sectorId = _nodeSectorIds param [_idx, -1];
                    if (_sectorId < 0) then { continue };
                    private _owner = _sectorOwner param [_sectorId, sideUnknown];
                    if !(_owner in _playerSides) then { continue };

                    private _cur = _hm getOrDefault [_x, 0];
                    if (_cur < _cap) then {
                        _hm set [_x, (_cur + _perTick) min _cap];
                        _changed = true;
                    };
                } forEach _nodeIds;

                if (_changed) then {
                    missionNamespace setVariable ["DZ_nodeSupplies", _hm, true];
                    publicVariable "DZ_nodeSupplies";
                    call DZ_fnc_supplyNodeSave;
                };
            };
        };

        [] spawn {
            while { true } do {
                sleep (missionNamespace getVariable ["DZ_supplySpawnBlockInterval", 20]);
                private _cost = missionNamespace getVariable ["DZ_supplySpawnCost", 20];
                if (_cost <= 0) then { continue };

                private _mk    = missionNamespace getVariable ["DZ_supplySpawnBaseMarker", "respawn_east"];
                private _mkPos = missionNamespace getVariable ["DZ_supplySpawnBaseMarkerPos", []];
                if (_mkPos isEqualType [] && { (count _mkPos) >= 2 }) then {
                    private _exists   = (markerType _mk) != "";
                    private _baseSupp = [("base")] call DZ_fnc_supplyGet;
                    if (_baseSupp < _cost && _exists) then {
                        deleteMarker _mk;
                        ["Склад базы пуст — возрождение на базе приостановлено.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                    if (_baseSupp >= _cost && { !_exists }) then {
                        createMarker [_mk, _mkPos];
                        private _d = missionNamespace getVariable ["DZ_supplySpawnBaseMarkerData", []];
                        if (_d isEqualType [] && { (count _d) >= 6 }) then {
                            _mk setMarkerShape (_d # 3);
                            _mk setMarkerType  (_d # 0);
                            _mk setMarkerColor (_d # 1);
                            _mk setMarkerText  (_d # 2);
                            _mk setMarkerSize  (_d # 4);
                            _mk setMarkerDir   (_d # 5);
                        } else {
                            _mk setMarkerShape "ICON";
                            _mk setMarkerType  "Empty";
                            _mk setMarkerAlpha 0;
                        };
                        ["Склад базы пополнен — возрождение на базе восстановлено.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                };

                {
                    private _v = _x;
                    if (isNull _v || { !alive _v }) then { continue };
                    if !((_v getVariable ["DZ_supplyKind", ""]) isEqualTo "kshm") then { continue };
                    if !(_v getVariable ["kshm_deployed", false]) then { continue };

                    private _supp = [_v] call DZ_fnc_supplyGet;
                    private _rid  = _v getVariable ["respawn_id", []];

                    if (_supp < _cost && { _rid isNotEqualTo [] }) then {
                        _rid call BIS_fnc_removeRespawnPosition;
                        _v setVariable ["respawn_id", [], true];
                        ["КШМ без снабжения — точка возрождения приостановлена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                    if (_supp >= _cost && { _rid isEqualTo [] }) then {
                        private _newRid = [east, _v, "Мобильный штаб ОКСВ"] call BIS_fnc_addRespawnPosition;
                        _v setVariable ["respawn_id", _newRid, true];
                        ["КШМ снабжена — точка возрождения восстановлена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                } forEach (missionNamespace getVariable ["DZ_supplyContainers", []]);
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

    addMissionEventHandler ["EntityRespawned", {
        params ["_newEntity", "_oldEntity"];
        if (_newEntity isEqualTo player) then {
            [player, getPosATL player] remoteExecCall ["DZ_fnc_supplyChargeSpawn", 2];
        };
    }];

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

        private _nodeHm = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
        {
            _x params [["_nid", ""], ["_nname", ""], ["_npos", [0,0,0]]];
            if (_npos isEqualType [] && { (count _npos) >= 2 } && { (_camPos distance _npos) < _range }) then {
                private _np = _nodeHm getOrDefault [_nid, 0];
                drawIcon3D [
                    "",
                    [0.6, 1, 0.6, 1],
                    [_npos # 0, _npos # 1, (_npos # 2) + 2],
                    0, 0, 0,
                    format ["Точка: %1 снаб.", round _np],
                    1, 0.03, "PuristaMedium"
                ];
            };
        } forEach (missionNamespace getVariable ["DZ_resourceNodes", []]);
    }];

    DZ_fnc_supplyAddSelfActions = {
        params [["_unit", objNull]];
        if (isNull _unit) exitWith {};
        if (_unit getVariable ["DZ_supplyActionsAdded", false]) exitWith {};
        _unit setVariable ["DZ_supplyActionsAdded", true];

        private _submenu = [
            "DZ_SupplyLogi", "Снабжение (логистика)", "",
            {}, { alive player }, {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions"], _submenu] call ace_interact_menu_fnc_addActionToObject;

        private _aCollect = [
            "DZ_SupplyCollect", "Собрать снабжение с точки", "",
            { private _c = [player] call DZ_fnc_supplyPlayerContainer; [player, _c] remoteExecCall ["DZ_fnc_supplyCollectFromNode", 2]; },
            {
                private _c = [player] call DZ_fnc_supplyPlayerContainer;
                !isNull _c && { ([getPosATL _c, missionNamespace getVariable ["DZ_supplyTransferRadius", 25]] call DZ_fnc_supplyNearestNode) != "" }
            },
            {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions", "DZ_SupplyLogi"], _aCollect] call ace_interact_menu_fnc_addActionToObject;

        private _aOffload = [
            "DZ_SupplyOffload", "Разгрузить снабжение на склад базы", "",
            { private _c = [player] call DZ_fnc_supplyPlayerContainer; [player, _c] remoteExecCall ["DZ_fnc_supplyOffloadToBase", 2]; },
            {
                private _c = [player] call DZ_fnc_supplyPlayerContainer;
                private _bp = missionNamespace getVariable ["DZ_supplyBasePos", []];
                !isNull _c && { _bp isEqualType [] } && { (count _bp) >= 2 } && { (getPosATL _c) distance2D _bp < (missionNamespace getVariable ["DZ_supplyTransferRadius", 25]) } && { ([_c] call DZ_fnc_supplyGet) > 0 }
            },
            {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions", "DZ_SupplyLogi"], _aOffload] call ace_interact_menu_fnc_addActionToObject;

        private _aLoad = [
            "DZ_SupplyLoad", "Загрузить снабжение со склада базы", "",
            { private _c = [player] call DZ_fnc_supplyPlayerContainer; [player, _c] remoteExecCall ["DZ_fnc_supplyLoadFromBase", 2]; },
            {
                private _c = [player] call DZ_fnc_supplyPlayerContainer;
                private _bp = missionNamespace getVariable ["DZ_supplyBasePos", []];
                !isNull _c && { _bp isEqualType [] } && { (count _bp) >= 2 } && { (getPosATL _c) distance2D _bp < (missionNamespace getVariable ["DZ_supplyTransferRadius", 25]) } && { ([_c] call DZ_fnc_supplyGet) < ([_c] call DZ_fnc_supplyMax) }
            },
            {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions", "DZ_SupplyLogi"], _aLoad] call ace_interact_menu_fnc_addActionToObject;
    };

    [
        { !isNil "ace_interact_menu_fnc_createAction" && { !isNil "DZ_fnc_supplyPlayerContainer" } && { !isNull player } },
        {
            [player] call DZ_fnc_supplyAddSelfActions;
            ["unit", { params ["_unit"]; [_unit] call DZ_fnc_supplyAddSelfActions; }] call CBA_fnc_addPlayerEventHandler;
        },
        []
    ] call CBA_fnc_waitUntilAndExecute;
};

true
