/*
 * DZ_fnc_controlParams
 * Defines mission-wide constants, unit pools, spawn profiles, timings, and feature toggles.
 */

params [["_eps", 100]];

private _gridSize = 350;
private _zoneTemplate = [false, [[], []], -1, 0, false, -1, false, false, -1, -1];
private _enemyGroupRoot = configNull;

private _defaultEnemyUnitClass = "UK3CB_WEI_B_TL";

private _uavOperatorClasses   = [];
private _uavOperatorBackpacks = [];

private _respawnPoints =
[
    ["База", [8262.683, 3772.911, 76.472], east]
];

private _enemyAirSupportClasses = [];

private _urbanUnitPool =
[
    ["UK3CB_WEI_B_RIF_5",    1.00],
    ["UK3CB_WEI_B_AR",       0.70],
    ["UK3CB_WEI_B_LAT",      0.65],
    ["UK3CB_WEI_B_GL",       0.55],
    ["UK3CB_WEI_B_MD",       0.45],
    ["UK3CB_WEI_B_MG",       0.40],
    ["UK3CB_WEI_B_MG_ASST",  0.30],
    ["UK3CB_WEI_B_RIF_1",    0.35],
    ["UK3CB_WEI_B_AT",       0.30],
    ["UK3CB_WEI_B_AT_ASST",  0.22],
    ["UK3CB_WEI_B_ENG",      0.25],
    ["UK3CB_WEI_B_DEM",      0.20],
    ["UK3CB_WEI_B_MK",       0.25],
    ["UK3CB_WEI_B_SNI",      0.15]
];

private _openUnitPool =
[
    ["UK3CB_WEI_B_RIF_5",    1.00],
    ["UK3CB_WEI_B_AR",       0.65],
    ["UK3CB_WEI_B_LAT",      0.60],
    ["UK3CB_WEI_B_AT",       0.50],
    ["UK3CB_WEI_B_AT_ASST",  0.40],
    ["UK3CB_WEI_B_SNI",      0.45],
    ["UK3CB_WEI_B_SPOT",     0.35],
    ["UK3CB_WEI_B_MK",       0.40],
    ["UK3CB_WEI_B_GL",       0.45],
    ["UK3CB_WEI_B_MD",       0.40],
    ["UK3CB_WEI_B_AA",       0.30],
    ["UK3CB_WEI_B_AA_ASST",  0.25],
    ["UK3CB_WEI_B_RIF_10",   0.30]
];

private _counterUnitPool =
[
    ["UK3CB_WEI_B_RIF_5",    1.00],
    ["UK3CB_WEI_B_AR",       0.75],
    ["UK3CB_WEI_B_LAT",      0.65],
    ["UK3CB_WEI_B_AT",       0.55],
    ["UK3CB_WEI_B_AT_ASST",  0.40],
    ["UK3CB_WEI_B_GL",       0.55],
    ["UK3CB_WEI_B_MG",       0.45],
    ["UK3CB_WEI_B_MG_ASST",  0.35],
    ["UK3CB_WEI_B_MD",       0.40],
    ["UK3CB_WEI_B_MK",       0.30],
    ["UK3CB_WEI_B_RIF_1",    0.35],
    ["UK3CB_WEI_B_DEM",      0.15]
];

private _urbanFixedSquads =
[

    [["UK3CB_WEI_B_TL"],                                                                                                     0.35],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5"],                                                                                0.50],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AR"],                                                              1.00],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_LAT"],                                                             0.85],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_1", "UK3CB_WEI_B_AR"],                                                              0.95],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_GL",    "UK3CB_WEI_B_MD"],                                                              0.90],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_DEM",   "UK3CB_WEI_B_RIF_5"],                                                           0.55],

    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR",    "UK3CB_WEI_B_MG",    "UK3CB_WEI_B_MG_ASST"],                                    0.65],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AT",    "UK3CB_WEI_B_AT_ASST","UK3CB_WEI_B_RIF_5"],                                     0.70],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_ENG",   "UK3CB_WEI_B_DEM",    "UK3CB_WEI_B_RIF_5"],                                     0.40],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_GL",    "UK3CB_WEI_B_LAT",    "UK3CB_WEI_B_MD"],                                        0.65]
];

private _openFixedSquads =
[

    [["UK3CB_WEI_B_TL"],                                                                                                     0.45],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5"],                                                                                0.55],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_SNI",   "UK3CB_WEI_B_SPOT"],                                                            0.70],

    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                                                              0.90],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR",    "UK3CB_WEI_B_LAT"],                                                             0.85],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_MD",    "UK3CB_WEI_B_AT"],                                                              0.70],

    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AT",    "UK3CB_WEI_B_AT_ASST","UK3CB_WEI_B_RIF_5"],                                     0.65],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AA",    "UK3CB_WEI_B_AA_ASST","UK3CB_WEI_B_RIF_5"],                                     0.55],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_MK",    "UK3CB_WEI_B_SPOT",   "UK3CB_WEI_B_RIF_5"],                                     0.45],

    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AR",    "UK3CB_WEI_B_LAT",    "UK3CB_WEI_B_GL",    "UK3CB_WEI_B_MD"],                   0.50]
];

private _counterFixedSquads =
[

    [["UK3CB_WEI_B_SL"],                                                                                                     0.45],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                                                              0.65],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_SNI",   "UK3CB_WEI_B_AT"],                                                              0.55],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AR"],                                                              0.95],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AR",     "UK3CB_WEI_B_MG"],                                        0.70],
    [["UK3CB_WEI_B_TL", "UK3CB_WEI_B_MD",    "UK3CB_WEI_B_AT"],                                                              0.65],

    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AT",    "UK3CB_WEI_B_AT_ASST","UK3CB_WEI_B_AR",     "UK3CB_WEI_B_MD"],                  0.60],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_MG",    "UK3CB_WEI_B_MG_ASST","UK3CB_WEI_B_LAT",   "UK3CB_WEI_B_RIF_5"],                0.55],
    [["UK3CB_WEI_B_SL", "UK3CB_WEI_B_GL",    "UK3CB_WEI_B_AR",     "UK3CB_WEI_B_LAT",    "UK3CB_WEI_B_RIF_5"],               0.55]
];

private _urbanRandomSquads =
[
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5"]], ["pool", _urbanUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_SL"]],                       ["pool", _urbanUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR"]],     ["pool", _urbanUnitPool]], 0.40]
];

private _openRandomSquads =
[
    [createHashMapFromArray [["count", [2, 3]], ["required", ["UK3CB_WEI_B_TL"]],                       ["pool", _openUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AT"]],     ["pool", _openUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 3]], ["required", ["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AT"]],     ["pool", _openUnitPool]], 0.35]
];

private _counterRandomSquads =
[
    [createHashMapFromArray [["count", [4, 5]], ["required", ["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AR"]],     ["pool", _counterUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AT"]],     ["pool", _counterUnitPool]], 0.60],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_WEI_B_TL"]],                       ["pool", _counterUnitPool]], 0.35]
];

private _urbanSquads   = _urbanFixedSquads   + _urbanRandomSquads;
private _openSquads    = _openFixedSquads    + _openRandomSquads;
private _counterSquads = _counterFixedSquads + _counterRandomSquads;

private _urbanPackages =
[

    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_LR_Opentop_PKM"],  0.55],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_Hilux_DSHKM"],     0.55],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                       "UK3CB_WEI_B_Hilux_M2"],        0.45],

    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_MD"],                                         "UK3CB_WEI_B_Hilux_Civ_Open"],  0.30],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_GL"],                                         "UK3CB_WEI_B_S1203"],           0.30],

    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_MD"],     "UK3CB_WEI_B_LR_Softtop_Transport_Open"], 0.25]
];

private _openPackages =
[

    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_Hilux_DSHKM"],     0.55],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_LR_Opentop_PKM"],  0.50],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                       "UK3CB_WEI_B_Hilux_M2"],        0.40],

    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_SNI"],                                        "UK3CB_WEI_B_Hilux_Civ_Closed"],0.30],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_MD"],                                         "UK3CB_WEI_B_Skoda"],           0.30],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_GL", "UK3CB_WEI_B_RIF_5"],                                         "UK3CB_WEI_B_LR_Softtop_Transport_Open"], 0.30],

    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_MD"],     "UK3CB_WEI_B_Ikarus"],          0.25]
];

private _counterPackages =
[

    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                       "UK3CB_WEI_B_Hilux_M2"],        0.50],
    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT"],                       "UK3CB_WEI_B_Hilux_DSHKM"],     0.50],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_LR_Opentop_PKM"],  0.45],
    [[["UK3CB_WEI_B_TL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_RIF_5"],                                        "UK3CB_WEI_B_Hilux_Civ_Open"],  0.45],

    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_AT", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_MD"],     "UK3CB_WEI_B_LR_Softtop_Transport_Open"], 0.50],
    [[["UK3CB_WEI_B_SL", "UK3CB_WEI_B_RIF_5", "UK3CB_WEI_B_GL", "UK3CB_WEI_B_AR", "UK3CB_WEI_B_MG"],     "UK3CB_WEI_B_Ikarus"],          0.40]
];

private _urbanVehiclePool =
[
    ["UK3CB_WEI_B_Hilux_M2",        0.65],
    ["UK3CB_WEI_B_Hilux_DSHKM",     0.70],
    ["UK3CB_WEI_B_LR_Opentop_PKM",  0.55],
    ["UK3CB_WEI_B_Hilux_Civ_Open",  0.35],
    ["UK3CB_WEI_B_S1203",           0.30],
    ["UK3CB_WEI_B_LR_Softtop_Transport_Open", 0.30]
];

private _openVehiclePool =
[
    ["UK3CB_WEI_B_Hilux_DSHKM",     0.65],
    ["UK3CB_WEI_B_LR_Opentop_PKM",  0.55],
    ["UK3CB_WEI_B_Hilux_M2",        0.45],
    ["UK3CB_WEI_B_Hilux_Civ_Open",  0.45],
    ["UK3CB_WEI_B_Hilux_Civ_Closed",0.40],
    ["UK3CB_WEI_B_Skoda",           0.50],
    ["UK3CB_WEI_B_S1203",           0.50],
    ["UK3CB_WEI_B_LR_Softtop_Transport_Open", 0.45],
    ["UK3CB_WEI_B_TT650",           0.30]
];

private _counterVehiclePool =
[
    ["UK3CB_WEI_B_Hilux_M2",        0.55],
    ["UK3CB_WEI_B_Hilux_DSHKM",     0.55],
    ["UK3CB_WEI_B_LR_Opentop_PKM",  0.50],
    ["UK3CB_WEI_B_LR_Softtop_Transport_Open", 0.40],
    ["UK3CB_WEI_B_Ikarus",          0.30]
];

private _vehicleMeta = createHashMapFromArray
[
    ["UK3CB_WEI_B_Hilux_M2",        ["technical"]],
    ["UK3CB_WEI_B_Hilux_DSHKM",     ["technical"]],
    ["UK3CB_WEI_B_LR_Opentop_PKM",  ["technical"]],
    ["UK3CB_WEI_B_LR_Softtop_Transport_Open", ["truck"]],
    ["UK3CB_WEI_B_Ikarus",          ["truck"]],
    ["UK3CB_WEI_B_LR_Opentop_Reammo",["truck"]],
    ["UK3CB_WEI_B_LR_Opentop_Refuel",["truck"]],
    ["UK3CB_WEI_B_LR_Opentop_Repair",["truck"]],
    ["UK3CB_WEI_B_Hilux_Civ_Open",  ["utility"]],
    ["UK3CB_WEI_B_Hilux_Civ_Closed",["utility"]],
    ["UK3CB_WEI_B_S1203",           ["utility"]],
    ["UK3CB_WEI_B_Skoda",           ["utility"]],
    ["UK3CB_WEI_B_TT650",           ["utility"]]
];

private _vehicleCategoryCaps = createHashMapFromArray
[
    ["technical", 4],
    ["truck",     2],
    ["utility",   2]
];

private _vehicleCategoryLocalCaps = createHashMapFromArray
[
    ["technical", 2],
    ["truck",     1],
    ["utility",   1]
];

private _spawnTaskConfigs = createHashMapFromArray
[
    ["urban_dense",      createHashMapFromArray [["groups", [[1, 2], _urbanSquads]], ["packages", [[0, 1], _urbanPackages]], ["vehicles", [[0, 1], _urbanVehiclePool]]]],
    ["urban_sparse",     createHashMapFromArray [["groups", [[1, 1], _urbanSquads]], ["packages", [[0, 1], _urbanPackages]], ["vehicles", [[0, 1], _urbanVehiclePool]]]],
    ["checkpoint_builtup", createHashMapFromArray [["groups", [[1, 1], _urbanSquads]], ["packages", [[0, 1], _urbanPackages]], ["vehicles", [[0, 1], _urbanVehiclePool]]]],
    ["checkpoint_open",  createHashMapFromArray [["groups", [[1, 1], _openSquads]], ["packages", [[0, 1], _openPackages]], ["vehicles", [[0, 1], _openVehiclePool]]]],
    ["counterattack_urban", createHashMapFromArray [["groups", [[1, 2], _counterSquads]], ["packages", [[0, 1], _urbanPackages]], ["vehicles", [[0, 1], _urbanVehiclePool]]]],
    ["counterattack_open", createHashMapFromArray [["groups", [[1, 1], _counterSquads]], ["packages", [[0, 1], _counterPackages]], ["vehicles", [[0, 1], _counterVehiclePool]]]]
];

missionNamespace setVariable ["DZ_gridSize", _gridSize];
missionNamespace setVariable ["DZ_alpha", 0.35];
missionNamespace setVariable ["DZ_eps", _gridSize * 0.9];
missionNamespace setVariable ["DZ_sectorInfluenceRadius", _gridSize * 0.9];
missionNamespace setVariable ["DZ_preSpawnFactor", 1.5];
missionNamespace setVariable ["DZ_updateInterval", 1];
missionNamespace setVariable ["DZ_corpseCleanupInterval", 2400];
missionNamespace setVariable ["DZ_enableCorpseCleanup", true];

missionNamespace setVariable ["DZ_corpseCleanupPlayerProximity", 50];
missionNamespace setVariable ["DZ_loadoutSaveInterval", 60];
missionNamespace setVariable ["DZ_sectorSaveInterval", 60];

missionNamespace setVariable ["DZ_invPersistEnabled", true];

missionNamespace setVariable ["DZ_persistMaxAssets", 400];

missionNamespace setVariable ["DZ_baseContainerRadius", 300];

missionNamespace setVariable ["DZ_fortifyAnchorRadius", 20];
missionNamespace setVariable ["DZ_fortifyAnchorRescanInterval", 15];
missionNamespace setVariable ["DZ_respawnPoints", _respawnPoints];
missionNamespace setVariable ["DZ_scriptRespawnMarkersEnabled", false];

missionNamespace setVariable ["DZ_cpChance", 0.0003];

missionNamespace setVariable ["CH_sideEnemy",   west];
missionNamespace setVariable ["DZ_enemySides",  [west, resistance]];
missionNamespace setVariable ["DZ_playerSides", [east]];
missionNamespace setVariable ["CH_sidePlayers", east];

missionNamespace setVariable ["DZ_captureHold", 60];
missionNamespace setVariable ["DZ_frontierCaptureOnly", true];
missionNamespace setVariable ["DZ_frontierSeedBaseSectors", true];
missionNamespace setVariable ["DZ_frontierBaseRadius", _gridSize * 1.25];

missionNamespace setVariable ["DZ_frontierPruneDisconnectedSaves", false];
missionNamespace setVariable ["DZ_frontierAllowDisconnectedLandings", true];
missionNamespace setVariable ["DZ_recaptureSpawnCooldown", 360];
missionNamespace setVariable ["DZ_spawnRetryCooldown", 60];
missionNamespace setVariable ["DZ_counterRepeatCooldown", 1800];
missionNamespace setVariable ["DZ_counterGlobalCooldown", 1200];
missionNamespace setVariable ["DZ_counterFirstChance", 0.05];
missionNamespace setVariable ["DZ_counterRepeatChance", 0.05];
missionNamespace setVariable ["DZ_counterMaxActive", 2];
missionNamespace setVariable ["DZ_counterAttacksEnabled", true];
missionNamespace setVariable ["DZ_frontMinEnemyNeighbors", 2];
missionNamespace setVariable ["DZ_counterSpawnRadius", _gridSize * 0.35];

missionNamespace setVariable ["DZ_enemyAirSupportEnabled", true];
missionNamespace setVariable ["DZ_enemyAirSupportCheckInterval", 240];
missionNamespace setVariable ["DZ_enemyAirSupportChance", 0.08];
missionNamespace setVariable ["DZ_enemyAirSupportCooldown", 1800];
missionNamespace setVariable ["DZ_enemyAirSupportMaxActive", 1];
missionNamespace setVariable ["DZ_enemyAirSupportLifetime", 900];
missionNamespace setVariable ["DZ_enemyAirSupportClasses", _enemyAirSupportClasses];
missionNamespace setVariable ["DZ_enemyAirSupportBaseExclusionRadius", 900];
missionNamespace setVariable ["DZ_enemyAirSupportPatrolRadius", 900];
missionNamespace setVariable ["DZ_enemyAirSupportHeliSpawnDistance", 2500];
missionNamespace setVariable ["DZ_enemyAirSupportPlaneSpawnDistance", 4500];
missionNamespace setVariable ["DZ_enemyAirSupportSafeMarkers", ["base_safe_zone"]];

missionNamespace setVariable ["DZ_weatherSystemEnabled", true];
missionNamespace setVariable ["DZ_weatherPresets",
[
    ["clear",    0.08, 0.00, 0.02, 2400, 4],
    ["cloudy",   0.35, 0.00, 0.04, 2100, 5],
    ["windy",    0.45, 0.00, 0.03, 1800, 3],
    ["drizzle",  0.55, 0.18, 0.06, 1500, 3],
    ["rain",     0.75, 0.65, 0.08, 1500, 2],
    ["storm",    0.95, 1.00, 0.16, 1200, 1],
    ["foggy",    0.22, 0.00, 0.30, 1800, 2]
]];

missionNamespace setVariable ["DZ_zoneRadiiOverride",     createHashMap];
missionNamespace setVariable ["DZ_adjacencyBuffer",       800];
missionNamespace setVariable ["DZ_adjacencyMaxNeighbours", 8];

missionNamespace setVariable ["DZ_resourceTickInterval", 1800];
missionNamespace setVariable ["DZ_resourceMarkerRefreshInterval", 15];

missionNamespace setVariable ["DZ_resourceNodes",
[

    ["buchtov_fuel",       "Fuel Depot Buchtov",           [974.232,  11142.87, 0],  "oil",           300],
    ["belin_ltd",          "Belin Ltd.",                   [1589.325, 4813.543, 0],  "manufacturing", 160],
    ["jantina_depot",      "Jantina Depot",                [4046.559, 9614.416, 0],  "manufacturing", 160],
    ["kostrulya_nuclear",  "Nuclear Power Plant Kostrulya",[6973.962, 5082.875, 0],  "manufacturing", 300]
]];

missionNamespace setVariable ["DZ_resourceNodeMarkerType", createHashMapFromArray
[
    ["oil",           "loc_Fuelstation"],
    ["air_fuel",      "loc_Heliport"],
    ["quarry",        "loc_Quarry"],
    ["intel",         "loc_Transmitter"],
    ["manufacturing", "loc_Power"]
]];

missionNamespace setVariable ["DZ_aiBaseSkill", 0.55];
missionNamespace setVariable ["DZ_aiSkillByClass", createHashMapFromArray
[
    ["UK3CB_WEI_B_SL",       0.70],
    ["UK3CB_WEI_B_COM",      0.70],
    ["UK3CB_WEI_B_SNI",      0.70],
    ["UK3CB_WEI_B_MK",       0.65],
    ["UK3CB_WEI_B_TL",       0.65],
    ["UK3CB_WEI_B_OFF",      0.65],
    ["UK3CB_WEI_B_AR",       0.60],
    ["UK3CB_WEI_B_MG",       0.60],
    ["UK3CB_WEI_B_LMG",      0.60],
    ["UK3CB_WEI_B_AT",       0.60],
    ["UK3CB_WEI_B_AA",       0.60],
    ["UK3CB_WEI_B_SPOT",     0.60],
    ["UK3CB_WEI_B_LAT",      0.55],
    ["UK3CB_WEI_B_GL",       0.55],
    ["UK3CB_WEI_B_ENG",      0.55],
    ["UK3CB_WEI_B_DEM",      0.55],
    ["UK3CB_WEI_B_CREW",     0.55],
    ["UK3CB_WEI_B_MG_ASST",  0.50],
    ["UK3CB_WEI_B_AT_ASST",  0.50],
    ["UK3CB_WEI_B_AA_ASST",  0.50],
    ["UK3CB_WEI_B_MD",       0.50],
    ["UK3CB_WEI_B_RIF_5",    0.50],
    ["UK3CB_WEI_B_RIF_1",    0.50],
    ["UK3CB_WEI_B_RIF_10",   0.50],
    ["UK3CB_WEI_B_RIF_8",    0.50],
    ["UK3CB_WEI_B_RIF_4",    0.50]
]];

missionNamespace setVariable ["DZ_styleWestOwned", 0];
missionNamespace setVariable ["DZ_styleEastOwned", 1];
missionNamespace setVariable ["DZ_styleResistanceOwned", 2];
missionNamespace setVariable ["DZ_styleEnemyDormant", 0];
missionNamespace setVariable ["DZ_styleEnemyActive", 0];
missionNamespace setVariable ["DZ_stylePlayerOwned", 1];
missionNamespace setVariable ["DZ_styleContested", 3];

missionNamespace setVariable ["DZ_zoneStateTemplate", _zoneTemplate];
missionNamespace setVariable ["DZ_enemyGroupRoot", _enemyGroupRoot];
missionNamespace setVariable ["DZ_defaultEnemyUnitClass", _defaultEnemyUnitClass];
missionNamespace setVariable ["DZ_uavOperatorClasses", _uavOperatorClasses];
missionNamespace setVariable ["DZ_uavOperatorBackpacks", _uavOperatorBackpacks];
missionNamespace setVariable ["DZ_spawnTaskConfigs", _spawnTaskConfigs];
missionNamespace setVariable ["DZ_vehicleMeta", _vehicleMeta];
missionNamespace setVariable ["DZ_vehicleCategoryCaps", _vehicleCategoryCaps];
missionNamespace setVariable ["DZ_vehicleCategoryLocalCaps", _vehicleCategoryLocalCaps];
missionNamespace setVariable ["DZ_vehicleCategoryLocalRadius", _gridSize * 2.25];

missionNamespace setVariable ["DZ_enableLiveDespawn",        true];
missionNamespace setVariable ["DZ_cleanupDelay",             1200];
missionNamespace setVariable ["DZ_missionCleanupDelay",      1200];
missionNamespace setVariable ["DZ_abandonedVehicleEnabled",  true];
missionNamespace setVariable ["DZ_abandonedVehicleTimeout",  1800];
missionNamespace setVariable ["DZ_abandonedVehicleCheckInterval", 180];

missionNamespace setVariable ["DZ_trophyVehicleStoragePadNames",
    ["vehicle_delivery_pad", "logistics_point", "police_trophy"], true];

