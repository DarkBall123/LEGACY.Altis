/*
 * DZ_fnc_startHumanitarianAidMission
 *
 * Mission: deliver humanitarian aid to 3 friendly villages.
 *
 * Per design choices:
 *   - Players use ANY vehicle (no special truck spawn)
 *   - 3 villages, fixed count
 *   - High ambush chance (1 ambush per village, scripted along route)
 *   - Drop carryable supply crates at each village
 *   - Mission-scoped tracking only (no persistence)
 *
 * Bug fixes from previous version:
 *   - Village markers now placed at the BUILDING CLUSTER CENTER, not
 *     at the sector grid center. Previously the sector center could be
 *     up to ~250m off from the actual village.
 *   - Crate marker icon changed from "loc_RockArea" (invalid in some
 *     modsets) to "mil_dot" (always available).
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _currentMissionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
if ((missionNamespace getVariable ["DZ_missionActive", false]) && { _currentMissionId != "humanitarian_aid" }) exitWith { false };

if !(missionNamespace getVariable ["DZ_missionActive", false]) then
{
    private _definition = ["humanitarian_aid"] call DZ_fnc_getMissionDefinition;
    ["humanitarian_aid", "manual", _definition] call DZ_fnc_prepareMissionState;
};

private _cells     = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData  = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl   = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy",         resistance];
private _sidePlayers = missionNamespace getVariable ["CH_sidePlayers",     east];
private _captHash  = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];

if (_cells isEqualTo []) exitWith
{
    diag_log "[HUMANITARIAN] DZ_cells not initialized. Aborting.";
    ["failure"] call DZ_fnc_endMission;
    false
};

// ── Find candidate villages ──────────────────────────────
//
// For each sector with 3+ buildings within 200m, compute the actual
// building cluster center by averaging house positions. Use THAT as
// the village marker position, not the sector grid center.

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
{
    private _sectorPos = _x;
    private _nearBuildings = nearestObjects [_sectorPos, ["House"], 200];

    if (count _nearBuildings >= 3) then
    {
        // Proximity-band check
        private _minDist = 99999;
        {
            private _d = _sectorPos distance2D _x;
            if (_d < _minDist) then { _minDist = _d; };
        } forEach _playerHeldPositions;

        if (_playerHeldPositions isEqualTo [] ||
            { _minDist >= 1500 && _minDist <= 2500 }) then
        {
            // Compute actual village center as the average of building
            // positions. Use only the closest 8 buildings to the sector
            // center to avoid pulling toward stray outlier buildings.
            private _closeBuildings = _nearBuildings select [0, 8 min (count _nearBuildings)];
            private _sumX = 0;
            private _sumY = 0;
            {
                private _bp = getPosATL _x;
                _sumX = _sumX + (_bp # 0);
                _sumY = _sumY + (_bp # 1);
            } forEach _closeBuildings;

            private _avgX = _sumX / (count _closeBuildings);
            private _avgY = _sumY / (count _closeBuildings);
            private _villageCenter = [_avgX, _avgY, 0];

            _villageCandidates pushBack _villageCenter;
        };
    };
} forEach _cells;

if ((count _villageCandidates) < 3) exitWith
{
    diag_log format ["[HUMANITARIAN] Only %1 valid village candidates. Aborting.",
        count _villageCandidates];
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих деревень не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

// Pick 3 villages 800m+ apart
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
        if (_candidate distance2D _x < 800) exitWith { _tooClose = true; };
    } forEach _chosenVillages;

    if (!_tooClose) then
    {
        _chosenVillages pushBack _candidate;
    };
} forEach _shuffled;

if ((count _chosenVillages) < 3) exitWith
{
    diag_log format ["[HUMANITARIAN] Could not find 3 villages 800m+ apart (got %1). Aborting.",
        count _chosenVillages];
    ["failure"] call DZ_fnc_endMission;
    ["Подходящих деревень не найдено. Миссия отменена.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

diag_log format ["[HUMANITARIAN] Chosen villages: %1", _chosenVillages];

// ── Spawn supply crates at base ──────────────────────────
private _basePos = [1577.408, 8535.449, 0];
if ((markerType "respawn_east") != "") then
{
    _basePos = getMarkerPos "respawn_east";
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
    ["failure"] call DZ_fnc_endMission;
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
        "mil_dot",                              // changed from loc_RockArea
        format ["Груз %1", _i + 1]
    ] call DZ_fnc_missionUi;

    _crateMarkers pushBack _markerName;
};

diag_log format ["[HUMANITARIAN] Spawned %1 crates near base", count _crates];

// ── Village markers (placed at building cluster centers) ──
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
    []
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_aidCrates",            _crates];
missionNamespace setVariable ["DZ_aidVillages",          _chosenVillages];
missionNamespace setVariable ["DZ_aidVillageDelivered",  [false, false, false]];
missionNamespace setVariable ["DZ_aidDeliveredCount",    0];
missionNamespace setVariable ["DZ_aidAmbushTriggered",   [false, false, false]];

[
    "hint",
    "MISSION: ГУМАНИТАРНАЯ ПОМОЩЬ",
    "Три мирные деревни нуждаются в продовольствии и медикаментах. Возьмите 3 ящика с гуманитарной помощью на базе. Доставьте по одному в каждую отмеченную деревню. Сбросьте ящик в радиусе 30 м от центра деревни. ВНИМАНИЕ: разведка сообщает, что боевики готовят засады на пути следования. Будьте готовы к бою."
] call DZ_fnc_missionUi;

["Гуманитарная миссия активна. Возьмите ящики на базе и доставьте в деревни.", east]
    remoteExecCall ["DZ_fnc_sideMessage", 0];

// ── Ambush spawn helper ──────────────────────────────────
private _spawnAmbush = {
    params ["_anchorPos"];

    private _ambushGroup = createGroup [_sideEnemy, true];

    private _classes = [
        "LOP_AFR_Infantry_TL",
        "LOP_AFR_Infantry_AR",
        "LOP_AFR_Infantry_Rifleman",
        "LOP_AFR_Infantry_AT"
    ];

    {
        private _spawnPos = _anchorPos getPos [3 + (random 5), random 360];
        private _u = _ambushGroup createUnit [_x, _spawnPos, [], 0, "NONE"];
        if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_u] call DZ_fnc_prepareSpawnedUnit; };
    } forEach _classes;

    if (random 1 < 0.7) then
    {
        private _vehPos = _anchorPos getPos [10, random 360];
        private _vehClass = selectRandom ["LOP_AFR_Offroad_M2", "LOP_AFR_Nissan_PKM"];
        if (isClass (configFile >> "CfgVehicles" >> _vehClass)) then
        {
            private _veh = createVehicle [_vehClass, _vehPos, [], 0, "NONE"];
            _veh setDir (random 360);

            private _driver = _ambushGroup createUnit ["LOP_AFR_Infantry_Rifleman", _vehPos, [], 0, "NONE"];
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_driver] call DZ_fnc_prepareSpawnedUnit; };
            _driver moveInDriver _veh;

            private _gunner = _ambushGroup createUnit ["LOP_AFR_Infantry_AR", _vehPos, [], 0, "NONE"];
            if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_gunner] call DZ_fnc_prepareSpawnedUnit; };
            _gunner moveInGunner _veh;

            [[], [_veh], [], []] call DZ_fnc_addMissionAssets;
        };
    };

    _ambushGroup setBehaviour "AWARE";
    _ambushGroup setCombatMode "RED";
    _ambushGroup setSpeedMode "FULL";

    private _wp = _ambushGroup addWaypoint [_anchorPos, 30];
    _wp setWaypointType "SAD";
    _wp setWaypointBehaviour "AWARE";
    _wp setWaypointCombatMode "RED";

    [units _ambushGroup, [], [], []] call DZ_fnc_addMissionAssets;

    diag_log format ["[HUMANITARIAN] Ambush spawned at %1", _anchorPos];

    _ambushGroup
};

// ── Master state PFH ─────────────────────────────────────
private _stateHandle = [
    {
        params ["_args", "_handle"];
        _args params ["_crates", "_crateMarkers", "_villages", "_villageMarkers", "_startTime", "_spawnAmbushFn"];

        if !(missionNamespace getVariable ["DZ_missionActive", false]) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
        };

        if ((time - _startTime) > 4000) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            ["Время на доставку истекло.", east] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _delivered = missionNamespace getVariable ["DZ_aidVillageDelivered", [false, false, false]];
        private _deliveredCount = missionNamespace getVariable ["DZ_aidDeliveredCount", 0];
        private _ambushTriggered = missionNamespace getVariable ["DZ_aidAmbushTriggered", [false, false, false]];

        // Update crate markers
        {
            private _crate = _x;
            private _markerName = _crateMarkers param [_forEachIndex, ""];
            if (_markerName != "" && { !isNull _crate } && { alive _crate }) then
            {
                _markerName setMarkerPos (getPosATL _crate);
            };
        } forEach _crates;

        // Check each village for delivery
        {
            private _villagePos = _x;
            private _villageIdx = _forEachIndex;
            private _alreadyDelivered = _delivered # _villageIdx;

            if (!_alreadyDelivered) then
            {
                {
                    private _crate = _x;
                    if (!isNull _crate && { alive _crate }) then
                    {
                        private _onGround = isNull (objectParent _crate);
                        if (_onGround && { _crate distance2D _villagePos < 30 }) exitWith
                        {
                            _delivered set [_villageIdx, true];
                            _deliveredCount = _deliveredCount + 1;
                            missionNamespace setVariable ["DZ_aidVillageDelivered", _delivered];
                            missionNamespace setVariable ["DZ_aidDeliveredCount", _deliveredCount];

                            if !(isNil "ALFA_fnc_repAdjust") then
                            {
                                [1, format ["Humanitarian aid delivered to village %1.", _villageIdx + 1]] call ALFA_fnc_repAdjust;
                                diag_log format ["[HUMANITARIAN] Reputation reward +1 for delivery to village %1.", _villageIdx + 1];
                            }
                            else
                            {
                                diag_log "[HUMANITARIAN] Reputation reward skipped: ALFA_fnc_repAdjust is not initialized on server.";
                            };

                            private _vMarker = _villageMarkers param [_villageIdx, ""];
                            if (_vMarker != "") then
                            {
                                _vMarker setMarkerType "loc_Tourism";
                                _vMarker setMarkerColor "ColorGreen";
                                _vMarker setMarkerText format ["Деревня %1: ДОСТАВЛЕНО", _villageIdx + 1];
                            };

                            diag_log format ["[HUMANITARIAN] Delivery %1/%2 at village %3",
                                _deliveredCount, count _villages, _villageIdx + 1];

                            [
                                format ["Доставка %1/%2 завершена. Деревня %3 получила помощь.",
                                    _deliveredCount, count _villages, _villageIdx + 1],
                                east
                            ] remoteExecCall ["DZ_fnc_sideMessage", 0];
                        };
                    };
                } forEach _crates;
            };

            // Ambush trigger
            if (!(_ambushTriggered # _villageIdx) && !_alreadyDelivered) then
            {
                private _playerNearby = false;
                {
                    if (alive _x &&
                        { (side group _x) isEqualTo (missionNamespace getVariable ["CH_sidePlayers", east]) } &&
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
                            { (side group _x) isEqualTo (missionNamespace getVariable ["CH_sidePlayers", east]) } &&
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

                        [_ambushPos] call _spawnAmbushFn;

                        ["Засада! Боевики атакуют конвой!", east]
                            remoteExecCall ["DZ_fnc_sideMessage", 0];
                    };
                };
            };
        } forEach _villages;

        if (_deliveredCount >= count _villages) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["success"] call DZ_fnc_endMission;
            ["Гуманитарная помощь доставлена во все деревни. Отличная работа.", east]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        private _liveCrates = _crates select { !isNull _x && { alive _x } && { damage _x < 0.95 } };
        private _undeliveredVillages = ({!_x} count _delivered);

        if ((count _liveCrates) < _undeliveredVillages) exitWith
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            ["failure"] call DZ_fnc_endMission;
            [
                format ["Недостаточно ящиков для завершения миссии. Доставлено: %1/%2.",
                    _deliveredCount, count _villages],
                east
            ] remoteExecCall ["DZ_fnc_sideMessage", 0];
        };
    },
    3,
    [_crates, _crateMarkers, _chosenVillages, _villageMarkers, time, _spawnAmbush]
] call CBA_fnc_addPerFrameHandler;

[[], [], [], [_stateHandle]] call DZ_fnc_addMissionAssets;

true
