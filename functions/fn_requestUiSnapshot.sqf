/*
 * DZ_fnc_requestUiSnapshot
 * Builds a compact authoritative snapshot for one player. The client
 * requests it once per second; no large global sector arrays are
 * broadcast to every machine.
 *
 * Snapshot layout:
 *   [serverTime, economy, mission, sector, campaign, logistics,
 *    fireSupport, missionCatalog]
 */

if (!isServer) exitWith {};

params [["_caller", objNull, [objNull]]];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};
private _nextAllowedSnapshot = _caller getVariable ["DZ_uiNextSnapshotAt", 0];
if (isRemoteExecuted && { time < _nextAllowedSnapshot }) exitWith {};
_caller setVariable ["DZ_uiNextSnapshotAt", time + 0.5];

private _replyTarget = owner _caller;
private _callerSide = side _caller;
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [east]];
if !(_callerSide in _playerSides) then
{
    private _actualSide = _callerSide;
    _callerSide = _playerSides param [0, east];

    if !(_caller getVariable ["DZ_uiSideFallbackLogged", false]) then
    {
        _caller setVariable ["DZ_uiSideFallbackLogged", true];
        diag_log format
        [
            "[DZ_UI] Player %1 has side %2; snapshot uses campaign side %3.",
            name _caller,
            _actualSide,
            _callerSide
        ];
    };
};

private _sideKey =
{
    params ["_side"];
    switch (true) do
    {
        case (_side isEqualTo east):       { "EAST" };
        case (_side isEqualTo west):       { "WEST" };
        case (_side isEqualTo resistance): { "GUER" };
        default                            { "UNKNOWN" };
    }
};

private _sideLabel =
{
    params ["_side"];
    switch (true) do
    {
        case (_side isEqualTo east):       { "ОКСВ" };
        case (_side isEqualTo west):       { "ХУНТА" };
        case (_side isEqualTo resistance): { "СОПРОТИВЛЕНИЕ" };
        default                            { "НЕИЗВЕСТНО" };
    }
};

private _funds = if (!isNil "DZ_fnc_squadFundsGetBalance") then
{
    [_callerSide] call DZ_fnc_squadFundsGetBalance
}
else
{
    missionNamespace getVariable ["DZ_squadFundsBalance_east", 0]
};

private _baseSupply = missionNamespace getVariable ["DZ_supplyStock_base", 0];
private _baseSupplyCap = missionNamespace getVariable ["DZ_supplyBaseCap", 1000];
private _reputation = if (!isNil "ALFA_fnc_repGet") then
{
    [_callerSide] call ALFA_fnc_repGet
}
else
{
    missionNamespace getVariable ["ALFA_civilianReputation", 50]
};

private _repLabel = switch (true) do
{
    case (_reputation >= 80): { "Союзники" };
    case (_reputation >= 65): { "Доверяют" };
    case (_reputation >= 40): { "Нейтральны" };
    case (_reputation >= 20): { "Насторожены" };
    default                   { "Враждебны" };
};

private _weatherRaw = missionNamespace getVariable ["DZ_weatherCurrentPreset", "unknown"];
private _weatherLabel = switch (toLower _weatherRaw) do
{
    case "clear":   { "Ясно" };
    case "cloudy":  { "Облачно" };
    case "windy":   { "Ветрено" };
    case "drizzle": { "Морось" };
    case "rain":    { "Дождь" };
    case "storm":   { "Шторм" };
    case "foggy":   { "Туман" };
    default         { "Нет данных" };
};

private _economy =
[
    round _funds,
    round _baseSupply,
    round _baseSupplyCap,
    _reputation,
    _repLabel,
    _weatherLabel
];

call DZ_fnc_initMissionSystem;

private _missionState = [_callerSide] call DZ_fnc_missionStateOf;
private _missionActive = _missionState getOrDefault ["active", false];
private _missionId = _missionState getOrDefault ["id", ""];
private _missionTitle = _missionState getOrDefault ["title", ""];
private _missionSource = _missionState getOrDefault ["source", ""];
private _missionStart = _missionState getOrDefault ["startTime", 0];
private _missionDefinition = if (_missionId != "") then
{
    [_missionId] call DZ_fnc_getMissionDefinition
}
else
{
    createHashMap
};
private _missionDescription = _missionDefinition getOrDefault ["description", "Ожидайте приказа штаба."];
private _missionObjective = _missionDescription;
private _missionProgress = 0;
private _missionProgressMax = 1;
private _missionDeadline = 0;
private _missionLocation = "";

if (_missionActive) then
{
    switch (_missionId) do
    {
        case "interdiction":
        {
            private _vehicles = _missionState getOrDefault ["vehicles", []];
            private _total = count _vehicles;
            private _alive = { !isNull _x && { alive _x } } count _vehicles;
            _missionProgressMax = _total max 1;
            _missionProgress = _total - _alive;
            _missionObjective = format ["Уничтожьте конвой: %1 машин осталось.", _alive];
            if (getMarkerType "marker_convoy" != "") then { _missionLocation = mapGridPosition (markerPos "marker_convoy"); };
        };

        case "assassination":
        {
            private _target = missionNamespace getVariable ["DZ_assassinationTarget", objNull];
            private _intel = missionNamespace getVariable ["DZ_assassinationIntelTaken", false];
            _missionProgressMax = 2;
            _missionProgress = ([0, 1] select (isNull _target || { !alive _target })) + ([0, 1] select _intel);
            _missionObjective = if (!isNull _target && { alive _target }) then
            {
                "Ликвидируйте офицера Хунты."
            }
            else
            {
                "Заберите оперативные документы с тела офицера."
            };
            if (getMarkerType "marker_assassination" != "") then { _missionLocation = mapGridPosition (markerPos "marker_assassination"); };
        };

        case "downed_pilot":
        {
            private _pilot = missionNamespace getVariable ["DZ_pilotMissionTarget", objNull];
            private _rescued = missionNamespace getVariable ["DZ_pilotMissionRescued", false];
            private _guards = missionNamespace getVariable ["DZ_pilotMissionGuards", []];
            private _guardsAlive = { !isNull _x && { alive _x } } count _guards;
            _missionProgressMax = 2;
            _missionProgress = [0, 1] select _rescued;
            _missionObjective = if (!_rescued) then
            {
                format ["Освободите пилота. Охрана: %1.", _guardsAlive]
            }
            else
            {
                "Сопроводите пилота в зону эвакуации."
            };
            if (isNull _pilot || { !alive _pilot }) then { _missionObjective = "Связь с пилотом потеряна."; };
            if (getMarkerType "marker_pilot" != "") then { _missionLocation = mapGridPosition (markerPos "marker_pilot"); };
        };

        case "destroy_cache":
        {
            private _total = missionNamespace getVariable ["DZ_destroyCacheTotalCount", 1];
            private _destroyed = missionNamespace getVariable ["DZ_destroyCacheKilledCount", 0];
            _missionProgress = _destroyed;
            _missionProgressMax = _total max 1;
            _missionObjective = format ["Найдите и уничтожьте тайники: %1/%2.", _destroyed, _total];
            if (getMarkerType "marker_cache_area" != "") then { _missionLocation = mapGridPosition (markerPos "marker_cache_area"); };
        };

        case "artillery_hunt":
        {
            private _mortar = missionNamespace getVariable ["DZ_artyMortar", objNull];
            private _crew = missionNamespace getVariable ["DZ_artyCrew", []];
            private _crewAlive = { !isNull _x && { alive _x } } count _crew;
            private _firing = missionNamespace getVariable ["DZ_artyFiringStarted", false];
            private _victims = missionNamespace getVariable ["DZ_artyKilledCivilians", 0];
            _missionProgressMax = 1;
            _missionProgress = [0, 1] select (isNull _mortar || { !alive _mortar } || { _crewAlive == 0 });
            _missionDeadline = if (!_firing) then { _missionStart + 1200 } else { _missionStart + 4200 };
            _missionObjective = if (!_firing) then
            {
                format ["Найдите миномёт до открытия огня. Расчёт: %1.", _crewAlive]
            }
            else
            {
                format ["Миномёт ведёт огонь. Жертв среди мирных: %1.", _victims]
            };
            if (getMarkerType "marker_arty_search" != "") then { _missionLocation = mapGridPosition (markerPos "marker_arty_search"); };
        };

        case "humanitarian_aid":
        {
            private _delivered = missionNamespace getVariable ["DZ_aidDeliveredCount", 0];
            private _villages = missionNamespace getVariable ["DZ_aidVillages", []];
            private _total = (count _villages) max 3;
            _missionProgress = _delivered;
            _missionProgressMax = _total;
            _missionDeadline = _missionStart + 4800;
            _missionObjective = format ["Доставьте помощь в деревни: %1/%2.", _delivered, _total];
        };

        case "eod":
        {
            private _ieds = missionNamespace getVariable ["DZ_eodIeds", []];
            private _total = count _ieds;
            private _live = { !isNull _x && { alive _x } } count _ieds;
            _missionProgress = _total - _live;
            _missionProgressMax = _total max 1;
            _missionObjective = format ["Обнаружьте и обезвредьте СВУ: %1/%2.", _missionProgress, _total];
            if (getMarkerType "marker_eod_start" != "") then { _missionLocation = mapGridPosition (markerPos "marker_eod_start"); };
        };

        case "idap_repair":
        {
            private _vehicle = missionNamespace getVariable ["DZ_idapRepairVehicle", objNull];
            private _fuelLevel = if (isNull _vehicle) then { 0 } else { fuel _vehicle };
            _missionProgressMax = 100;
            _missionProgress = round (_fuelLevel * 100);
            _missionObjective = if (_fuelLevel > 0.3) then
            {
                "Транспорт заправлен. Обеспечьте безопасный отход."
            }
            else
            {
                format ["Заправьте транспорт Красного Креста: %1%%.", round (_fuelLevel * 100)]
            };
            if (getMarkerType "marker_idap_repair" != "") then { _missionLocation = mapGridPosition (markerPos "marker_idap_repair"); };
        };

        case "air_defense":
        {
            private _targets =
            [
                missionNamespace getVariable ["DZ_airDefenseRadar", objNull],
                missionNamespace getVariable ["DZ_airDefenseAAA", objNull],
                missionNamespace getVariable ["DZ_airDefenseSAM", objNull]
            ];
            private _destroyed = { isNull _x || { !alive _x } } count _targets;
            _missionProgress = _destroyed;
            _missionProgressMax = 3;
            _missionObjective = format ["Уничтожьте средства ПВО: %1/3.", _destroyed];
        };

        case "defend_informant":
        {
            private _phase = missionNamespace getVariable ["DZ_defendUiPhase", "Подготовка"];
            private _wave = missionNamespace getVariable ["DZ_defendUiWave", 0];
            private _waveCount = missionNamespace getVariable ["DZ_defendUiWaveCount", 5];
            _missionDeadline = missionNamespace getVariable ["DZ_defendUiDeadline", 0];
            _missionProgress = _wave;
            _missionProgressMax = _waveCount max 1;
            _missionObjective = switch (_phase) do
            {
                case "Оборона":   { format ["Отбейте атаку: волна %1/%2.", _wave, _waveCount] };
                case "Эвакуация": { "Доставьте перебежчика на главную базу." };
                default          { "Укрепите позицию и подготовьтесь к атаке." };
            };
            if (getMarkerType "marker_defend" != "") then { _missionLocation = mapGridPosition (markerPos "marker_defend"); };
        };

        case "heli_intercept":
        {
            private _heli = missionNamespace getVariable ["DZ_heliInterceptTarget", objNull];
            _missionProgressMax = 1;
            _missionProgress = [0, 1] select (isNull _heli || { !alive _heli });
            _missionObjective = "Найдите и уничтожьте ударный вертолёт.";
            if (getMarkerType "marker_heli" != "") then { _missionLocation = mapGridPosition (markerPos "marker_heli"); };
        };
    };
};

private _moneyRewards = missionNamespace getVariable ["DZ_squadFundsMissionRewards", createHashMap];
private _supplyRewards = missionNamespace getVariable ["DZ_supplyMissionRewards", createHashMap];
private _missionRewardMoney = _moneyRewards getOrDefault [_missionId, 0];
private _missionRewardSupply = _supplyRewards getOrDefault [_missionId, 0];
if (_missionSource == "fob") then
{
    _missionRewardMoney = round (_missionRewardMoney * (missionNamespace getVariable ["DZ_fobRewardMultiplier", 2]));
};

private _mission =
[
    _missionActive,
    _missionId,
    _missionTitle,
    _missionDescription,
    _missionSource,
    (time - _missionStart) max 0,
    _missionObjective,
    _missionProgress,
    _missionProgressMax,
    _missionDeadline,
    _missionRewardMoney,
    _missionRewardSupply,
    _missionLocation
];

private _cells = missionNamespace getVariable ["DZ_cells", []];
private _zoneRadii = missionNamespace getVariable ["DZ_zoneRadii", []];
private _zoneNames = missionNamespace getVariable ["DZ_zoneNames", []];
private _sectorOwners = missionNamespace getVariable ["DZ_sectorOwner", []];
private _sectorDominance = missionNamespace getVariable ["DZ_sectorDominance", []];
private _sectorCounts = missionNamespace getVariable ["DZ_sectorCounts", []];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _adjacency = missionNamespace getVariable ["DZ_sectorAdjacency", []];
private _fallbackRadius = missionNamespace getVariable ["DZ_sectorInfluenceRadius", 315];
private _callerPos = getPosATL (vehicle _caller);
private _sectorId = -1;
private _sectorDistance = 1e12;

{
    private _distance = _callerPos distance2D _x;
    private _radius = _zoneRadii param [_forEachIndex, _fallbackRadius];
    if (_distance <= _radius && { _distance < _sectorDistance }) then
    {
        _sectorId = _forEachIndex;
        _sectorDistance = _distance;
    };
} forEach _cells;

private _sector = [-1, "", "UNKNOWN", "", "ВНЕ СЕКТОРА", 0, 0, 0, false, false];
if (_sectorId >= 0) then
{
    private _owner = _sectorOwners param [_sectorId, west];
    private _dominance = _sectorDominance param [_sectorId, [sideUnknown, -1]];
    _dominance params [["_dominant", sideUnknown], ["_holdStart", -1]];
    private _counts = _sectorCounts param [_sectorId, [0, 0, 0]];
    _counts params [["_westCount", 0], ["_resistanceCount", 0], ["_eastCount", 0]];
    private _ourCount = switch (true) do
    {
        case (_callerSide isEqualTo east):       { _eastCount };
        case (_callerSide isEqualTo west):       { _westCount };
        case (_callerSide isEqualTo resistance): { _resistanceCount };
        default                                  { 0 };
    };
    private _enemyCount = (_westCount + _resistanceCount + _eastCount) - _ourCount;
    private _counter = (_zoneData param [_sectorId, []]) param [7, false];
    private _neighbors = _adjacency param [_sectorId, []];
    private _frontline = (_neighbors findIf
    {
        !((_sectorOwners param [_x, west]) isEqualTo _owner)
    }) >= 0;

    private _captureProgress = if (!(_dominant isEqualTo sideUnknown) && { _holdStart >= 0 }) then
    {
        (((time - _holdStart) / (missionNamespace getVariable ["DZ_captureHold", 60])) max 0) min 1
    }
    else
    {
        [0, 1] select (_owner isEqualTo _callerSide)
    };

    private _status = switch (true) do
    {
        case _counter: { "КОНТРАТАКА" };
        case (!(_dominant isEqualTo sideUnknown) && { !(_dominant isEqualTo _owner) }):
        {
            if (_dominant isEqualTo _callerSide) then { "ЗАХВАТ" } else { "ПЕРЕХВАТ ПРОТИВНИКОМ" }
        };
        case (_ourCount > 0 && { _enemyCount > 0 }): { "ОСПАРИВАЕТСЯ" };
        case (_owner isEqualTo _callerSide):         { "ПОД КОНТРОЛЕМ" };
        case (!_frontline):                          { "ВНЕ ЛИНИИ ФРОНТА" };
        default                                      { "ТЕРРИТОРИЯ ПРОТИВНИКА" };
    };

    private _sectorName = _zoneNames param [_sectorId, ""];
    if (_sectorName == "") then { _sectorName = format ["СЕКТОР %1", _sectorId + 1]; };

    _sector =
    [
        _sectorId,
        toUpper _sectorName,
        [_owner] call _sideKey,
        [_owner] call _sideLabel,
        _status,
        _captureProgress,
        _ourCount,
        _enemyCount,
        _frontline,
        _counter
    ];
};

private _ownedSectors = { (_x isEqualTo _callerSide) } count _sectorOwners;
private _totalSectors = count _sectorOwners;

private _nodeIds = missionNamespace getVariable ["DZ_resourceNodeIds", []];
private _nodeNames = missionNamespace getVariable ["DZ_resourceNodeNames", []];
private _nodeTypes = missionNamespace getVariable ["DZ_resourceNodeTypes", []];
private _nodeIncome = missionNamespace getVariable ["DZ_resourceNodeIncomeList", []];
private _nodeSectorIds = missionNamespace getVariable ["DZ_resourceNodeSectorIds", []];
private _nodePools = missionNamespace getVariable ["DZ_nodeSupplies", createHashMap];
private _nodePoolCap = missionNamespace getVariable ["DZ_supplyNodePoolCap", 600];
private _incomePerTick = 0;
private _nodeSummaries = [];

{
    private _idx = _forEachIndex;
    private _nodeSector = _nodeSectorIds param [_idx, -1];
    private _owner = _sectorOwners param [_nodeSector, sideUnknown];
    private _income = _nodeIncome param [_idx, 0];
    if (_owner isEqualTo _callerSide) then { _incomePerTick = _incomePerTick + _income; };

    _nodeSummaries pushBack
    [
        _x,
        _nodeNames param [_idx, _x],
        _nodeTypes param [_idx, ""],
        _income,
        [_owner] call _sideKey,
        [_owner] call _sideLabel,
        round (_nodePools getOrDefault [_x, 0]),
        _nodePoolCap
    ];
} forEach _nodeIds;

private _tickInterval = missionNamespace getVariable ["DZ_resourceTickInterval", 1800];
private _lastTick = missionNamespace getVariable ["DZ_resourceLastTick", time];
private _nextIncome = (_tickInterval - (time - _lastTick)) max 0;
private _campaign = [_ownedSectors, _totalSectors, _incomePerTick, _nextIncome, _nodeSummaries];

private _containers = [];
{
    if (isNull _x || { !alive _x }) then { continue };
    private _distance = _caller distance2D _x;
    private _kind = _x getVariable ["DZ_supplyKind", "truck"];
    private _label = if (_kind == "kshm") then { "КШМ" } else { getText (configOf _x >> "displayName") };
    _containers pushBack
    [
        round _distance,
        _label,
        _kind,
        round (_x getVariable ["DZ_supplies", 0]),
        round (_x getVariable ["DZ_suppliesMax", 0]),
        _x getVariable ["kshm_deployed", false]
    ];
} forEach (missionNamespace getVariable ["DZ_supplyContainers", []]);
_containers sort true;
if ((count _containers) > 10) then { _containers resize 10; };

private _spawnCost = missionNamespace getVariable ["DZ_supplySpawnCost", 20];
private _baseRespawnReady = _baseSupply >= _spawnCost;
private _logistics = [round _baseSupply, round _baseSupplyCap, _spawnCost, _baseRespawnReady, _containers];

private _isForwardObserver = if (!isNil "DZ_fnc_fireSupportIsFO") then
{
    [_caller] call DZ_fnc_fireSupportIsFO
}
else
{
    false
};
private _supportOptions =
[
    [
        "smoke",
        "Дымовая завеса",
        missionNamespace getVariable ["DZ_fireSupportSmokeMoney", 100],
        missionNamespace getVariable ["DZ_fireSupportSmokeSupply", 20],
        ((missionNamespace getVariable ["DZ_fireSupportCdSmoke", 0]) - time) max 0
    ],
    [
        "illum",
        "Осветительные боеприпасы",
        missionNamespace getVariable ["DZ_fireSupportIllumMoney", 100],
        missionNamespace getVariable ["DZ_fireSupportIllumSupply", 20],
        ((missionNamespace getVariable ["DZ_fireSupportCdIllum", 0]) - time) max 0
    ]
];
private _fireSupport =
[
    _isForwardObserver,
    missionNamespace getVariable ["DZ_fireSupportMaxRange", 2500],
    missionNamespace getVariable ["DZ_fireSupportDelay", 15],
    _supportOptions
];

private _definitionIds =
[
    "interdiction",
    "assassination",
    "destroy_cache",
    "artillery_hunt",
    "downed_pilot",
    "humanitarian_aid",
    "eod",
    "idap_repair",
    "air_defense",
    "defend_informant",
    "heli_intercept"
];
private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
private _missionCatalog = [];

{
    private _definition = [_x] call DZ_fnc_getMissionDefinition;
    if ((count _definition) == 0) then { continue };
    private _cooldownUntil = _cooldowns getOrDefault [_x, 0];
    _missionCatalog pushBack
    [
        _x,
        _definition getOrDefault ["title", _x],
        _definition getOrDefault ["description", ""],
        _moneyRewards getOrDefault [_x, 0],
        _supplyRewards getOrDefault [_x, 0],
        (_cooldownUntil - time) max 0,
        _definition getOrDefault ["manualEnabled", false]
    ];
} forEach _definitionIds;

private _snapshot =
[
    time,
    _economy,
    _mission,
    _sector,
    _campaign,
    _logistics,
    _fireSupport,
    _missionCatalog
];

/*
 * A listen-server host owns its player locally (owner ID 2). Sending
 * a client-only RemoteExec response back to ID 2 can be treated as a
 * server target, so deliver the snapshot directly on that machine.
 */
if (local _caller && { hasInterface }) then
{
    [_snapshot] call DZ_fnc_uiReceiveSnapshot;

    if !(_caller getVariable ["DZ_uiSnapshotDeliveryLogged", false]) then
    {
        _caller setVariable ["DZ_uiSnapshotDeliveryLogged", true];
        diag_log format ["[DZ_UI] Snapshot delivered locally to listen-server host %1.", name _caller];
    };
}
else
{
    [_snapshot] remoteExecCall ["DZ_fnc_uiReceiveSnapshot", _replyTarget];

    if !(_caller getVariable ["DZ_uiSnapshotDeliveryLogged", false]) then
    {
        _caller setVariable ["DZ_uiSnapshotDeliveryLogged", true];
        diag_log format ["[DZ_UI] Snapshot sent to network owner %1 for %2.", _replyTarget, name _caller];
    };
};
