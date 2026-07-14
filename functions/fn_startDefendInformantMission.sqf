/*
 * DZ_fnc_startDefendInformantMission
 * Defend an informant at a player-held sector against escalating
 * counterattack waves, then extract the informant to the main base.
 *
 * Flow:
 *   1. An informant (civilian, captive) spawns at a random player-held
 *      sector (prefers a frontline sector bordering enemy ground).
 *   2. A preparation period (DZ_defendPrepTime, default 1200s / 20 min)
 *      lets players fortify before the first attack.
 *   3. DZ_defendWaveCount escalating AFR waves assault the position
 *      (spawned via DZ_fnc_spawnCounterattackForce; later waves bring
 *      armor through the counter vehicle pool).
 *   4. After all waves are repelled, the informant must be escorted to
 *      the main-base evacuation point (same point as the downed-pilot
 *      mission).
 *
 * Lose conditions: the informant dies, or the mission times out is NOT
 * used — the pacing is wave-driven. Only informant death fails it.
 *
 * Manual-only: it requires held territory and is a long commitment, so
 * it is not offered by the scheduler or the FOB random contract.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _missionSide = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
if !(_missionSide in _playerSides) then { _missionSide = _playerSides param [0, west] };

private _sideState = [_missionSide] call DZ_fnc_missionStateOf;
if ((_sideState get "active") && { (_sideState get "id") != "defend_informant" }) exitWith { false };

if !((_sideState get "active")) then
{
    private _definition = ["defend_informant"] call DZ_fnc_getMissionDefinition;
    ["defend_informant", "manual", _definition, _missionSide] call DZ_fnc_prepareMissionState;
};

private _cells       = missionNamespace getVariable ["DZ_cells",             []];
private _zoneData    = missionNamespace getVariable ["DZ_zoneData",          []];
private _zoneTpl     = missionNamespace getVariable ["DZ_zoneStateTemplate", [false, [[], []], -1, 0, false, -1, false, false, -1, -1]];
private _captHash    = missionNamespace getVariable ["DZ_capturedHash",      createHashMap];
private _adjacency   = missionNamespace getVariable ["DZ_sectorAdjacency",   []];

if (_cells isEqualTo []) exitWith
{
    diag_log "[DEFEND] DZ_cells not initialized. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    false
};

private _fnc_isHeld =
{
    params ["_idx"];
    private _st = _zoneData param [_idx, _zoneTpl];
    ((_st param [4, false]) isEqualTo true) || { _idx in _captHash }
};

private _heldSectors = [];
{
    if ([_forEachIndex] call _fnc_isHeld) then
    {
        _heldSectors pushBack [_forEachIndex, _x];
    };
} forEach _cells;

if (_heldSectors isEqualTo []) exitWith
{
    diag_log "[DEFEND] No player-held sectors. Aborting.";
    ["failure", _missionSide] call DZ_fnc_endMission;
    ["Нет захваченных секторов для обороны. Сначала захватите территорию.", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    false
};

private _frontline = _heldSectors select {
    private _idx = _x # 0;
    private _neighbors = _adjacency param [_idx, []];
    (_neighbors findIf { !([_x] call _fnc_isHeld) }) >= 0
};

private _chosen = if (_frontline isNotEqualTo []) then { selectRandom _frontline } else { selectRandom _heldSectors };
_chosen params ["_sectorIdx", "_defendPos"];

diag_log format ["[DEFEND] Defend sector idx=%1 at %2 (frontline=%3)", _sectorIdx, _defendPos, _frontline isNotEqualTo []];

private _extractMarker = missionNamespace getVariable ["DZ_pilotExtractionMarker", ""];
private _extractPos    = missionNamespace getVariable ["DZ_pilotExtractionPos",    []];
if (_extractMarker != "" && { getMarkerType _extractMarker != "" }) then
{
    _extractPos = getMarkerPos _extractMarker;
};
if (_extractPos isEqualTo []) then
{
    {
        if (getMarkerType _x != "") exitWith { _extractPos = getMarkerPos _x; };
    } forEach ["respawn_east"];
};
if (_extractPos isEqualTo [] || { _extractPos isEqualTo [0, 0, 0] }) then
{
    _extractPos = [1577.408, 8535.449, 0];
};

private _informantGroup = createGroup [civilian, true];
private _informantClass = "";
private _informantCandidates = ["C_man_1", "C_Man_casual_1_F", "C_man_polo_1_F", "C_Man_casual_4_F"];
{
    if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _informantClass = _x; };
} forEach _informantCandidates;
if (_informantClass == "") then { _informantClass = "C_man_1"; };

private _informant = _informantGroup createUnit [_informantClass, _defendPos, [], 0, "NONE"];
_informant setName "Перебежчик";
_informant setCaptive true;
_informant disableAI "MOVE";
_informant disableAI "AUTOTARGET";
_informant disableAI "TARGET";
_informant disableAI "FSM";
_informant setBehaviour "CARELESS";
_informant setUnitPos "DOWN";
removeAllWeapons _informant;
_informant setPosATL _defendPos;
if (!isNil "DZ_fnc_prepareSpawnedUnit") then { [_informant] call DZ_fnc_prepareSpawnedUnit; };

diag_log format ["[DEFEND] Informant spawned: %1 at %2", _informant, getPosATL _informant];

["create", "marker_defend", _defendPos, "loc_Bunker", "Перебежчик: оборона"] call DZ_fnc_missionUi;

[
    [_informant],
    [],
    ["marker_defend"],
    [],
    _missionSide
] call DZ_fnc_addMissionAssets;

missionNamespace setVariable ["DZ_defendInformant", _informant];
missionNamespace setVariable ["DZ_defendPos",       _defendPos];

private _prepTime  = missionNamespace getVariable ["DZ_defendPrepTime",   1200];
private _waveCount = missionNamespace getVariable ["DZ_defendWaveCount",  5];

[
    "hint",
    "MISSION: ПРИКРЫТИЕ ПЕРЕБЕЖЧИКА",
    format [
        "В захваченном секторе укрылся перебежчик из штаба Хунты с критически важной информацией. Захватчики уже выдвигают контратаку, чтобы зачистить сектор и ликвидировать его.\n\nВаши задачи:\n1) Укрепите позицию (есть ~%1 мин до первой атаки).\n2) Отбейте %2 волн Хунты. Перебежчик НЕ должен погибнуть.\n3) После отражения всех волн доставьте перебежчика на главную базу.\n\nВНИМАНИЕ: поздние волны усилены бронетехникой.",
        round (_prepTime / 60),
        _waveCount
    ]
] call DZ_fnc_missionUi;

[
    format ["Перебежчик закреплён в секторе. До первой атаки ~%1 мин. Укрепляйте позицию.", round (_prepTime / 60)],
    _missionSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];

[_informant, _defendPos, _extractPos, _waveCount, _prepTime, _missionSide] spawn
{
    params ["_inf", "_defendPos", "_extractPos", "_waveCount", "_prepTime", "_missionSide"];

    private _lull        = missionNamespace getVariable ["DZ_defendLull",        75];
    private _maxWaveTime = missionNamespace getVariable ["DZ_defendMaxWaveTime", 600];

    private _fnc_wait =
    {
        params ["_dur", "_unit"];
        private _end = time + _dur;
        private _status = "ok";
        while { time < _end } do
        {
            if (isNull _unit || { !alive _unit }) exitWith { _status = "dead" };
            if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith { _status = "ended" };
            sleep 2;
        };
        _status
    };

    private _fnc_fail =
    {
        params ["_msg"];
        ["failure", _missionSide] call DZ_fnc_endMission;
        [_msg, _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];
    };

    private _prepRemaining = _prepTime;
    {
        private _announceAt = _x;
        if (_prepRemaining > _announceAt) then
        {
            private _waitFor = _prepRemaining - _announceAt;
            private _st = [_waitFor, _inf] call _fnc_wait;
            if (_st == "dead") exitWith { ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
            if (_st == "ended") exitWith {};
            _prepRemaining = _announceAt;
            if (_announceAt > 0) then
            {
                [format ["Противник атакует через %1 мин. Готовьтесь к обороне!", round (_announceAt / 60)], _missionSide]
                    remoteExecCall ["DZ_fnc_sideMessage", 0];
            };
        };
    } forEach [600, 300, 60, 0];

    if (isNull _inf || { !alive _inf }) exitWith {};
    if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith {};

    ["Контратака началась! Защищайте перебежчика!", _missionSide] remoteExecCall ["DZ_fnc_sideMessage", 0];

    private _waveAborted = false;

    for "_wave" from 1 to _waveCount do
    {
        if (isNull _inf || { !alive _inf }) exitWith { _waveAborted = true; ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith { _waveAborted = true; };

        private _forces = 1 + floor (_wave / 2);

        [format ["Волна %1/%2 приближается!", _wave, _waveCount], _missionSide]
            remoteExecCall ["DZ_fnc_sideMessage", 0];

        private _waveUnits = [];
        private _waveVehs  = [];

        for "_f" from 1 to _forces do
        {
            private _dir  = random 360;
            private _dist = 320 + (random 130);
            private _spawnCenter = _defendPos getPos [_dist, _dir];

            private _res = [_defendPos, "counterattack_open", _spawnCenter] call DZ_fnc_spawnCounterattackForce;
            _res params [["_grps", []], ["_vs", []], ["_tot", 0]];

            { _waveUnits append (units _x); } forEach _grps;
            _waveVehs append _vs;
        };

        [_waveUnits, _waveVehs, [], [], _missionSide] call DZ_fnc_addMissionAssets;

        private _waveSize = count _waveUnits;
        private _clearThreshold = ceil (_waveSize * 0.15);
        private _waveStart = time;

        diag_log format ["[DEFEND] Wave %1/%2 spawned: forces=%3 units=%4 veh=%5",
            _wave, _waveCount, _forces, _waveSize, count _waveVehs];

        private _waveStatus = "cleared";
        while { true } do
        {
            if (isNull _inf || { !alive _inf }) exitWith { _waveStatus = "dead" };
            if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith { _waveStatus = "ended" };

            private _aliveCount = { alive _x } count _waveUnits;
            if (_aliveCount <= _clearThreshold) exitWith { _waveStatus = "cleared" };
            if ((time - _waveStart) > _maxWaveTime) exitWith { _waveStatus = "timeout" };

            sleep 3;
        };

        if (_waveStatus == "dead") exitWith { _waveAborted = true; ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
        if (_waveStatus == "ended") exitWith { _waveAborted = true; };

        if (_waveStatus == "timeout") then
        {

            { if (alive _x) then { deleteVehicle _x; }; } forEach _waveUnits;
            diag_log format ["[DEFEND] Wave %1 force-advanced (timeout).", _wave];
        };

        if (_wave < _waveCount) then
        {
            [format ["Волна %1/%2 отбита. Перегруппировка противника...", _wave, _waveCount], _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
            private _st = [_lull, _inf] call _fnc_wait;
            if (_st == "dead") exitWith { _waveAborted = true; ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
            if (_st == "ended") exitWith { _waveAborted = true; };
        };
    };

    if (_waveAborted) exitWith {};
    if (isNull _inf || { !alive _inf }) exitWith {};
    if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith {};

    ["Все волны отбиты! Эвакуируйте перебежчика на главную базу.", _missionSide]
        remoteExecCall ["DZ_fnc_sideMessage", 0];

    "marker_defend" setMarkerType "mil_pickup";
    "marker_defend" setMarkerText "Эвакуируйте перебежчика";

    ["create", "marker_defend_evac", _extractPos, "mil_end", "Эвакуация"] call DZ_fnc_missionUi;
    [[], [], ["marker_defend_evac"], [], _missionSide] call DZ_fnc_addMissionAssets;

    private _attached = false;
    while { !_attached } do
    {
        if (isNull _inf || { !alive _inf }) exitWith { ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith {};

        private _rescuer = objNull;
        {
            if (alive _x && { (side group _x) isEqualTo _missionSide } && { _x distance _inf < 50 }) exitWith
            {
                _rescuer = _x;
            };
        } forEach allPlayers;

        if (!isNull _rescuer) then
        {
            _inf enableAI "MOVE";
            _inf enableAI "AUTOTARGET";
            _inf enableAI "TARGET";
            _inf setCaptive false;
            _inf setUnitPos "AUTO";
            [_inf] joinSilent (group _rescuer);
            _inf doFollow (leader (group _rescuer));
            _attached = true;

            ["Перебежчик следует за вами. Доставьте его в зону эвакуации.", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        }
        else
        {
            sleep 2;
        };
    };

    if (isNull _inf || { !alive _inf }) exitWith {};
    if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith {};

    while { true } do
    {
        if (isNull _inf || { !alive _inf }) exitWith { ["Перебежчик погиб. Миссия провалена."] call _fnc_fail; };
        if !([_missionSide] call DZ_fnc_missionActiveForSide) exitWith {};

        "marker_defend" setMarkerPos (getPosATL _inf);

        private _atExtract = (_inf distance2D _extractPos < 50);
        if (!_atExtract) then
        {
            {
                if (alive _x && { _x distance2D _extractPos < 50 }) exitWith { _atExtract = true; };
            } forEach (units group _inf);
        };

        if (_atExtract && { _inf distance2D _extractPos < 200 }) exitWith
        {
            diag_log "[DEFEND] SUCCESS: informant extracted.";
            ["success", _missionSide] call DZ_fnc_endMission;
            ["Перебежчик доставлен на базу. Отличная работа!", _missionSide]
                remoteExecCall ["DZ_fnc_sideMessage", 0];
        };

        sleep 2;
    };
};

true
