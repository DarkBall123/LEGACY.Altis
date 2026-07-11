/*
 * DZ_fnc_startHumanitarianAidMission
 * Starts the humanitarian aid delivery mission and tracks village deliveries.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "humanitarian_aid" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["humanitarian_aid"] call DZ_fnc_getMissionDefinition;
    ["humanitarian_aid", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[HUMANITARIAN] DZ_cells not initialized. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

private _playerHeldPositions = [];
{
    private _state = _zoneData param [_forEachIndex, _zoneTpl];
    private _captured = _state param [4, false];
    if (_captured || { _forEachIndex in _captHash }) then
    {
        _playerHeldPositions pushBack _x;
    };
} forEach _cells;

private _villageCandidates = [];
private _allVillages = nearestLocations [
    [worldSize * 0.5, worldSize * 0.5, 0],
    ["NameVillage", "NameCity", "NameCityCapital", "NameLocal"],
    worldSize
];

{
    private _loc        = _x;
    private _villagePos = locationPosition _loc;

    private _minDist = 99999;
    {
        private _d = _villagePos distance2D _x;
        if (_d < _minDist) then { _minDist = _d; };
    } forEach _playerHeldPositions;

    if (_playerHeldPositions isEqualTo [] ||
        { _minDist >= 1500 && _minDist <= 4000 }) then
    {
        _villageCandidates pushBack [_villagePos # 0, _villagePos # 1, 0];
    };
} forEach _allVillages;

diag_log format ["[HUMANITARIAN] %1 named locations on map, %2 in the 1500-4000m band from player territory",
    count _allVillages, count _villageCandidates];

if ((count _villageCandidates) < 3) exitWith
{
    diag_log format ["[HUMANITARIAN] Only %1 valid village candidates. Aborting.",
        count _villageCandidates];
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Подходящих деревень не найдено. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _chosenVillages = [];
private _shuffled = +_villageCandidates;

for "_i" from (count _shuffled - 1) to 1 step -1 do
{
    private _j = floor (random (_i + 1));
    private _tmp = _shuffled # _i;
    _shuffled set [_i, _shuffled # _j];
    _shuffled set [_j, _tmp];
};

{
    if ((count _chosenVillages) >= 3) exitWith {};

    private _candidate = _x;
    private _tooClose = false;
    {
        if (_candidate distance2D _x < 1500) exitWith { _tooClose = true; };
    } forEach _chosenVillages;

    if (!_tooClose) then
    {
        _chosenVillages pushBack _candidate;
    };
} forEach _shuffled;

if ((count _chosenVillages) < 3) exitWith
{
    diag_log format ["[HUMANITARIAN] Could not find 3 villages 1500m+ apart (got %1). Aborting.",
        count _chosenVillages];
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Деревни слишком близко друг к другу. Миссия отменена.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

diag_log format ["[HUMANITARIAN] Chosen villages: %1", _chosenVillages];
{
    diag_log format ["[HUMANITARIAN] Village %1: %2", _forEachIndex + 1, _x];
} forEach _chosenVillages;

private _basePos = [];
private _pad = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
if (!isNull _pad) then
{
    _basePos = getPosATL _pad;
}
else
{
    diag_log "[HUMANITARIAN] vehicle_delivery_pad not found — falling back to APD respawn.";
    if ((markerType "respawn_east") != "") then
    {
        _basePos = getMarkerPos "respawn_east";
    }
    else
    {
        _basePos = [worldSize * 0.5, worldSize * 0.5, 0];
    };
};

private _crateClass = "";
private _crateCandidates = [
    "Land_PaperBox_01_small_closed_brown_food_F"
];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _crateClass = _x; };
} forEach _crateCandidates;

if (_crateClass == "") exitWith
{
    diag_log "[HUMANITARIAN] No crate class found. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

diag_log format ["[HUMANITARIAN] Using crate class: %1", _crateClass];

private _crates = [];
private _crateMarkers = [];

for "_i" from 0 to 2 do
{
    private _angle = 90 + (_i * 30);
    private _dist = 8 + (_i * 1.5);
    private _cratePos = _basePos getPos [_dist, _angle];

    private _crate = createVehicle [_crateClass, _cratePos, [], 0, "NONE"];
    _crate setPosATL _cratePos;
    _crate setDamage 0;

    _crate setVariable ["ace_dragging_canDrag", true, true];
    _crate setVariable ["ace_dragging_canCarry", true, true];

    _crate setVariable ["DZ_isAidCrate", true, true];
    _crate setVariable ["DZ_aidCrateIndex", _i, true];
    _crate setVariable ["DZ_aidCrateDeliveredTo", -1, true];

    clearWeaponCargoGlobal _crate;
    clearMagazineCargoGlobal _crate;
    clearItemCargoGlobal _crate;
    clearBackpackCargoGlobal _crate;

    _crates pushBack _crate;

    private _markerName = format ["marker_aid_crate_%1", _i + 1];
    [
        "create",
        _markerName,
        _cratePos,
        "mil_dot",
        format ["Груз %1", _i + 1]
    ] call DZ_fnc_missionUi;

    _crateMarkers pushBack _markerName;
};

diag_log format ["[HUMANITARIAN] Spawned %1 crates near base", count _crates];

private _villageMarkers = [];
{
    private _markerName = format ["marker_aid_village_%1", _forEachIndex + 1];
    [
        "create",
        _markerName,
        _x,
        "loc_Hospital",
        format ["Деревня %1", _forEachIndex + 1]
    ] call DZ_fnc_missionUi;
    _villageMarkers pushBack _markerName;
} forEach _chosenVillages;

[
    [],
    _crates,
    _crateMarkers + _villageMarkers,
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_aidCrates",            _crates];
missionNamespace setVariable ["DZ_aidVillages",          _chosenVillages];
missionNamespace setVariable ["DZ_aidVillageDelivered",  [false, false, false]];
missionNamespace setVariable ["DZ_aidDeliveredCount",    0];
missionNamespace setVariable ["DZ_aidAmbushTriggered",   [false, false, false]];

[
    "hint",
    "MISSION: ГУМАНИТАРНАЯ ПОМОЩЬ",
    "Три мирные деревни нуждаются в продовольствии и медикаментах. Возьмите 3 ящика с гуманитарной помощью на базе. Доставьте по одному в каждую отмеченную деревню. ВЫГРУЗИТЕ ящик из машины в радиусе 30 м от центра деревни. ВАЖНО: ящик должен быть на земле (не в машине) и в радиусе 30 м от деревни. ВНИМАНИЕ: разведка сообщает, что захватчики готовят засады на пути следования. Будьте готовы к бою."
] call DZ_fnc_missionUi;

["Гуманитарная миссия активна. Возьмите ящики на базе и доставьте в деревни.", _missionSide]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

private _fnc_crateOnGround = {
    params ["_crate"];

    if (!isNull (objectParent _crate)) exitWith { false };
    if (!isNull (attachedTo _crate)) exitWith { false };

    private _onGround = true;
    {
        if (alive _x &&
            { _x isKindOf "AllVehicles" } &&
            { !(_x isKindOf "Man") } &&
            { (count (crew _x)) > 0 } &&
            { _crate distance _x < 5 }) exitWith
        {
            _onGround = false;
        };
    } forEach (_crate nearObjects 8);

    _onGround
};

private _spawnAmbush = {
    params ["_anchorPos", "_missionSide"];

    private _ambushGroup = createGroup [_sideEnemy, true];

    private _classes = [
        "UK3CB_WEI_B_TL",
        "UK3CB_WEI_B_AR",
        "UK3CB_WEI_B_RIF_5",
        "UK3CB_WEI_B_AT"
    ];

    {
        private _spawnPos = _anchorPos getPos [3 + (random 5), random 360];
        private _u = _ambushGroup createUnit [_x, _spawnPos, [], 0, "NONE"];
        if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
    } forEach _classes;

    if (random 1 < 0.7) then
    {
        private _vehPos = _anchorPos getPos [10, random 360];
        private _vehClass = selectRandom ["UK3CB_WEI_B_Hilux_DSHKM", "UK3CB_WEI_B_LR_Opentop_PKM"];
        if (isClass (configFile >> "CfgVehicles" >> _vehClass)) then
        {
            private _veh = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
            _veh setDir (random 360);

            private _driver = _ambushGroup createUnit ["UK3CB_WEI_B_RIF_5", _vehPos, [], 0, "NONE"];
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_driver] call DZ_fnc_prepareSpawnedUnit; };
            _driver moveInDriver _veh;

            private _gunner = _ambushGroup createUnit ["UK3CB_WEI_B_AR", _vehPos, [], 0, "NONE"];
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_gunner] call DZ_fnc_prepareSpawnedUnit; };
            _gunner moveInGunner _veh;

            [[], [_veh], [], [], _missionSide] call DZ_fnc_addMissionAssets;
        };
    };

    _ambushGroup setBehaviour "AWARE";
    _ambushGroup setCombatMode "RED";
    _ambushGroup setSpeedMode "FULL";

    private _wp = _ambushGroup addWaypoint [_anchorPos, 30];
    _wp setWaypointType "SAD";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";

    [units _ambushGroup, [], [], [], _missionSide] call DZ_fnc_addMissionAssets;

    diag_log format ["[HUMANITARIAN] Ambush spawned at %1", _anchorPos];

    _ambushGroup
};

private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_missionSide", "_crates", "_crateMarkers", "_villages", "_villageMarkers", "_startTime", "_spawnAmbushFn", "_fnc_crateOnGround"];

        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if ((time - _startTime) > 4800) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            ["Время на доставку истекло.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _delivered = missionNamespace getVariable ["DZ_aidVillageDelivered", [false, false, false]];
        private _deliveredCount = missionNamespace getVariable ["DZ_aidDeliveredCount", 0];
        private _ambushTriggered = missionNamespace getVariable ["DZ_aidAmbushTriggered", [false, false, false]];

        {
            private _crate = _x;
            private _markerName = _crateMarkers param [_forEachIndex, ""];
            if (_markerName != "" && { !isNull _crate } && { alive _crate }) then
            {
                _markerName setMarkerPos (getPosATL _crate);
            };
        } forEach _crates;

        {
            private _crate = _x;
            if (!isNull _crate && { alive _crate }) then
            {
                private _crateAlreadyDelivered = (_crate getVariable ["DZ_aidCrateDeliveredTo", -1]) >= 0;

                if (!_crateAlreadyDelivered) then
                {

                    private _onGround = [_crate] call _fnc_crateOnGround;

                    if (_onGround) then
                    {

                        {
                            private _villagePos = _x;
                            private _villageIdx = _forEachIndex;
                            private _villageDelivered = _delivered # _villageIdx;

                            if (!_villageDelivered && { _crate distance2D _villagePos < 30 }) exitWith
                            {

                                _crate setVariable ["DZ_aidCrateDeliveredTo", _villageIdx, true];
                                _delivered set [_villageIdx, true];
                                _deliveredCount = _deliveredCount + 1;
                                missionNamespace setVariable ["DZ_aidVillageDelivered", _delivered];
                                missionNamespace setVariable ["DZ_aidDeliveredCount", _deliveredCount];

                                private _vMarker = _villageMarkers param [_villageIdx, ""];
                                if (_vMarker != "") then
                                {
                                    _vMarker setMarkerType "loc_Tourism";
                                    _vMarker setMarkerColor "ColorGreen";
                                    _vMarker setMarkerText format ["Деревня %1: ДОСТАВЛЕНО", _villageIdx + 1];
                                };

                                diag_log format ["[HUMANITARIAN] Delivery %1/%2: crate %3 delivered to village %4 at %5",
                                    _deliveredCount, count _villages,
                                    _crate getVariable ["DZ_aidCrateIndex", -1],
                                    _villageIdx + 1,
                                    getPosATL _crate];

                                [
                                    format ["Доставка %1/%2 завершена. Деревня %3 получила помощь.",
                                        _deliveredCount, count _villages, _villageIdx + 1],
                                    _missionSide
                                ] remoteExecCall ["DZ_fnc_sideMessage", 0];
                            };
                        } forEach _villages;
                    };
                };
            };
        } forEach _crates;

        {
            private _villagePos = _x;
            private _villageIdx = _forEachIndex;
            private _alreadyDelivered = _delivered # _villageIdx;

            if (!(_ambushTriggered # _villageIdx) && !_alreadyDelivered) then
            {
                private _playerNearby = false;
                {
                    if (alive _x &&
                        { (side group _x) in (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]) } &&
                        { _x distance2D _villagePos < 600 }) exitWith
                    {
                        _playerNearby = true;
                    };
                } forEach allPlayers;

                if (_playerNearby) then
                {
                    _ambushTriggered set [_villageIdx, true];
                    missionNamespace setVariable ["DZ_aidAmbushTriggered", _ambushTriggered];

                    private _nearestPlayer = objNull;
                    private _minDist = 99999;
                    {
                        if (alive _x &&
                            { (side group _x) in (missionNamespace getVariable ["DZ_playerSides", [west, resistance]]) } &&
                            { _x distance2D _villagePos < _minDist }) then
                        {
                            _minDist = _x distance2D _villagePos;
                            _nearestPlayer = _x;
                        };
                    } forEach allPlayers;

                    if (!isNull _nearestPlayer) then
                    {
                        private _approachDir = _villagePos getDir _nearestPlayer;
                        private _ambushPos = _villagePos getPos [350, _approachDir];

                        [_ambushPos, _missionSide] call _spawnAmbushFn;

                        ["Засада! Боевики атакуют конвой!", _missionSide]
                            remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                };
            };
        } forEach _villages;

        if (_deliveredCount >= count _villages) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success", _missionSide] call DZ_fnc_endMission;
            ["Гуманитарная помощь доставлена во все деревни. Отличная работа.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _useableCrates = _crates select {
            !isNull _x &&
            { alive _x } &&
            { damage _x < 0.95 } &&
            { (_x getVariable ["DZ_aidCrateDeliveredTo", -1]) < 0 }
        };
        private _undeliveredVillages = ({!_x} count _delivered);

        if ((count _useableCrates) < _undeliveredVillages) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure", _missionSide] call DZ_fnc_endMission;
            [
                format ["Недостаточно ящиков для завершения миссии. Доставлено: %1/%2.",
                    _deliveredCount, count _villages],
                _missionSide
            ] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    3,
    [_missionSide, _crates, _crateMarkers, _chosenVillages, _villageMarkers, time, _spawnAmbush, _fnc_crateOnGround]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle], _missionSide] call DZ_fnc_addMissionAssets;

true
