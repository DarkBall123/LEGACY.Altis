params [["_eps", 100]];

private _gridSize = 350;
private _zoneTemplate = [false, [[], []], -1, 0, false, -1, false, false, -1, -1];
private _enemyGroupRoot = configNull;

private _defaultEnemyUnitClass = "LOP_AFR_Infantry_TL";

private _uavOperatorClasses = ["LOP_AFR_Infantry_SL"];
private _uavOperatorBackpacks = ["B_Crocus_AP_Bag", "B_Crocus_AT_Bag"];

private _respawnPoints =
[
    ["База", [1577.408, 8535.449, 0]]
];

// ─────────────────────────────────────────────────────────
// UNIT POOLS
// ─────────────────────────────────────────────────────────

private _urbanUnitPool =
[
    ["LOP_AFR_Infantry_Rifleman",   1.00],
    ["LOP_AFR_Infantry_Rifleman_2", 0.85],
    ["LOP_AFR_Infantry_Rifleman_3", 0.85],
    ["LOP_AFR_Infantry_Rifleman_4", 0.85],
    ["LOP_AFR_Infantry_GL",         0.55],
    ["LOP_AFR_Infantry_AR",         0.55],
    ["LOP_AFR_Infantry_AR_2",       0.45],
    ["LOP_AFR_Infantry_AT",         0.30],
    ["LOP_AFR_Infantry_AT_Asst",    0.20],
    ["LOP_AFR_Infantry_Marksman",   0.25],
    ["LOP_AFR_Infantry_Corpsman",   0.20],

    ["LOP_AFRCiv_Soldier",          0.80],
    ["LOP_AFRCiv_Soldier_GL",       0.40],
    ["LOP_AFRCiv_Soldier_AR",       0.35],
    ["LOP_AFRCiv_Soldier_AT",       0.25],
    ["LOP_AFRCiv_Soldier_Marksman", 0.20],
    ["LOP_AFRCiv_Soldier_Medic",    0.18],
    ["LOP_AFRCiv_Soldier_IED",      0.10]
];

private _openUnitPool =
[
    ["LOP_AFR_Infantry_Rifleman",   1.00],
    ["LOP_AFR_Infantry_Rifleman_2", 0.75],
    ["LOP_AFR_Infantry_Rifleman_3", 0.75],
    ["LOP_AFR_Infantry_Rifleman_5", 0.65],
    ["LOP_AFR_Infantry_Rifleman_6", 0.65],
    ["LOP_AFR_Infantry_GL",         0.50],
    ["LOP_AFR_Infantry_AR",         0.55],
    ["LOP_AFR_Infantry_AR_2",       0.45],
    ["LOP_AFR_Infantry_AR_Asst",    0.30],
    ["LOP_AFR_Infantry_AT",         0.45],
    ["LOP_AFR_Infantry_AT_Asst",    0.25],
    ["LOP_AFR_Infantry_Marksman",   0.35],
    ["LOP_AFR_Infantry_Corpsman",   0.18]
];

private _counterUnitPool =
[
    ["LOP_AFR_Infantry_Rifleman",   0.95],
    ["LOP_AFR_Infantry_Rifleman_2", 0.85],
    ["LOP_AFR_Infantry_Rifleman_4", 0.75],
    ["LOP_AFR_Infantry_Rifleman_7", 0.65],
    ["LOP_AFR_Infantry_GL",         0.55],
    ["LOP_AFR_Infantry_AR",         0.60],
    ["LOP_AFR_Infantry_AR_2",       0.50],
    ["LOP_AFR_Infantry_AR_Asst",    0.30],
    ["LOP_AFR_Infantry_AT",         0.50],
    ["LOP_AFR_Infantry_AT_Asst",    0.30],
    ["LOP_AFR_Infantry_Marksman",   0.30],
    ["LOP_AFR_Infantry_Corpsman",   0.18]
];

private _urbanFixedSquads =
[
    [["LOP_AFR_Infantry_TL"], 0.35],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman"], 0.50],
    [["LOP_AFR_Infantry_TL", "LOP_AFRCiv_Soldier", "LOP_AFRCiv_Soldier_AR"], 1.00],
    [["LOP_AFRCiv_Soldier_SL", "LOP_AFRCiv_Soldier", "LOP_AFRCiv_Soldier_AT"], 0.85],
    [["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AR"], 0.95],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman_2", "LOP_AFR_Infantry_GL"], 0.90],
    [["LOP_AFRCiv_Soldier_SL", "LOP_AFRCiv_Soldier_IED", "LOP_AFRCiv_Soldier"], 0.55]
];

private _openFixedSquads =
[
    [["LOP_AFR_Infantry_TL"], 0.45],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman"], 0.55],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Marksman", "LOP_AFR_Infantry_AT"], 0.70],
    [["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], 0.90],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman_2", "LOP_AFR_Infantry_AR_2"], 0.85],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Corpsman", "LOP_AFR_Infantry_AT"], 0.70]
];

private _counterFixedSquads =
[
    [["LOP_AFR_Infantry_SL"], 0.55],
    [["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], 0.65],
    [["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_Marksman", "LOP_AFR_Infantry_AT"], 0.55],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AR"], 0.95],
    [["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AR"], 0.90],
    [["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Corpsman", "LOP_AFR_Infantry_AT"], 0.65]
];

private _urbanRandomSquads =
[
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman"]], ["pool", _urbanUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFR_Infantry_SL"]], ["pool", _urbanUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFRCiv_Soldier_SL"]], ["pool", _urbanUnitPool]], 0.40]
];

private _openRandomSquads =
[
    [createHashMapFromArray [["count", [2, 3]], ["required", ["LOP_AFR_Infantry_TL"]], ["pool", _openUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_AT"]], ["pool", _openUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 3]], ["required", ["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AT"]], ["pool", _openUnitPool]], 0.35]
];

private _counterRandomSquads =
[
    [createHashMapFromArray [["count", [4, 5]], ["required", ["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_AR"]], ["pool", _counterUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_AT"]], ["pool", _counterUnitPool]], 0.60],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["LOP_AFR_Infantry_TL"]], ["pool", _counterUnitPool]], 0.35]
];

private _urbanSquads = _urbanFixedSquads + _urbanRandomSquads;
private _openSquads = _openFixedSquads + _openRandomSquads;
private _counterSquads = _counterFixedSquads + _counterRandomSquads;

private _urbanPackages =
[
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman"], "LOP_AFR_Offroad"], 0.80],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Corpsman"], "LOP_AFR_Truck"], 0.20],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_M113_W"], 0.10],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_BTR60"], 0.08]
];

private _openPackages =
[
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman"], "LOP_AFR_Offroad"], 0.60],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Corpsman"], "LOP_AFR_Truck"], 0.35],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_M113_W"], 0.16],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_BTR60"], 0.12]
];

private _counterPackages =
[
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman"], "LOP_AFR_Offroad"], 0.55],
    [[["LOP_AFR_Infantry_TL", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Corpsman"], "LOP_AFR_Truck"], 0.32],
    [[["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_M113_W"], 0.18],
    [[["LOP_AFR_Infantry_SL", "LOP_AFR_Infantry_AR", "LOP_AFR_Infantry_Rifleman", "LOP_AFR_Infantry_AT"], "LOP_AFR_BTR60"], 0.14]
];

private _urbanVehiclePool =
[
    ["LOP_AFR_Offroad_M2",        1.00],
    ["LOP_AFR_Nissan_PKM",        0.85],
    ["LOP_AFR_Offroad_AT",        0.20],
    ["LOP_AFR_Landrover_M2",      0.30],
    ["LOP_AFR_Landrover_SPG9",    0.25]
];

private _openVehiclePool =
[
    ["LOP_AFR_Offroad_M2",        0.85],
    ["LOP_AFR_Nissan_PKM",        0.72],
    ["LOP_AFR_Offroad_AT",        0.28],
    ["LOP_AFR_Landrover_M2",      0.26],
    ["LOP_AFR_Landrover_SPG9",    0.32],
    ["LOP_AFR_BTR60",             0.10],
    ["LOP_AFR_M113_W",            0.08],
    ["LOP_AFR_Landrover",         0.06]
];

private _counterVehiclePool =
[
    ["LOP_AFR_Offroad_M2",        0.60],
    ["LOP_AFR_Nissan_PKM",        0.50],
    ["LOP_AFR_Offroad_AT",        0.24],
    ["LOP_AFR_Landrover_M2",      0.24],
    ["LOP_AFR_Landrover_SPG9",    0.28],
    ["LOP_AFR_BTR60",             0.20],
    ["LOP_AFR_M113_W",            0.16],
    ["LOP_AFR_T55",               0.04],
    ["LOP_AFR_T72BA",             0.02],
    ["LOP_AFR_T72BB",             0.01],
    ["LOP_AFR_T34",               0.02]
];

private _vehicleMeta = createHashMapFromArray
[
    ["LOP_AFR_BTR60",          ["apc"]],
    ["LOP_AFR_M113_W",         ["apc"]],
    ["LOP_AFR_T55",            ["tank"]],
    ["LOP_AFR_T72BA",          ["tank"]],
    ["LOP_AFR_T72BB",          ["tank"]],
    ["LOP_AFR_T34",            ["tank"]],
    ["LOP_AFR_Offroad_M2",     ["technical"]],
    ["LOP_AFR_Offroad_AT",     ["technical"]],
    ["LOP_AFR_Nissan_PKM",     ["technical"]],
    ["LOP_AFR_Landrover_M2",   ["technical"]],
    ["LOP_AFR_Landrover_SPG9", ["technical"]],
    ["LOP_AFR_Landrover",      ["utility"]],
    ["LOP_AFR_Offroad",        ["utility"]],
    ["LOP_AFR_Truck",          ["truck"]]
];

private _vehicleCategoryCaps = createHashMapFromArray
[
    ["tank", 1],
    ["apc", 1],
    ["technical", 4],
    ["truck", 2],
    ["utility", 2]
];

private _vehicleCategoryLocalCaps = createHashMapFromArray
[
    ["tank", 1],
    ["apc", 1],
    ["technical", 2],
    ["truck", 1],
    ["utility", 1]
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

// ─────────────────────────────────────────────────────────
// MISSION-NAMESPACE PARAMETERS
// ─────────────────────────────────────────────────────────

missionNamespace setVariable ["DZ_gridSize", _gridSize];
missionNamespace setVariable ["DZ_alpha", 0.35];
missionNamespace setVariable ["DZ_eps", _gridSize * 0.9];
missionNamespace setVariable ["DZ_preSpawnFactor", 1.5];
missionNamespace setVariable ["DZ_updateInterval", 1];
missionNamespace setVariable ["DZ_corpseCleanupInterval", 900];
missionNamespace setVariable ["DZ_enableCorpseCleanup", true];
missionNamespace setVariable ["DZ_loadoutSaveInterval", 60];
missionNamespace setVariable ["DZ_respawnPoints", _respawnPoints];

missionNamespace setVariable ["DZ_cpChance", 0.0003];

missionNamespace setVariable ["CH_sideEnemy", resistance];
missionNamespace setVariable ["CH_sidePlayers", east];

missionNamespace setVariable ["DZ_captureHold", 60];
missionNamespace setVariable ["DZ_recaptureSpawnCooldown", 180];
missionNamespace setVariable ["DZ_spawnRetryCooldown", 30];
missionNamespace setVariable ["DZ_counterRepeatCooldown", 180];
missionNamespace setVariable ["DZ_counterGlobalCooldown", 180];
missionNamespace setVariable ["DZ_counterFirstChance", 0.03];
missionNamespace setVariable ["DZ_counterRepeatChance", 0.02];
missionNamespace setVariable ["DZ_counterMaxActive", 2];
missionNamespace setVariable ["DZ_frontMinEnemyNeighbors", 2];
missionNamespace setVariable ["DZ_counterSpawnRadius", _gridSize * 0.35];

missionNamespace setVariable ["DZ_styleEnemyDormant", 0];
missionNamespace setVariable ["DZ_styleEnemyActive", 1];
missionNamespace setVariable ["DZ_stylePlayerOwned", 2];
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

// ── CLEANUP / DESPAWN TIMINGS ─────────────────────────────
//
// Sector despawn (live cleanup of enemy patrols when nobody's around):
//   DZ_enableLiveDespawn — master switch
//   DZ_cleanupDelay      — seconds without players nearby before despawn
//
// Mission cleanup (mission-specific spawned units after success/failure):
//   DZ_missionCleanupDelay — seconds after mission ends before living
//                            assets are deleted (wrecks/bodies stay)
//
// Abandoned vehicle cleanup (transport-spawned vehicles like UAZs):
//   DZ_abandonedVehicleEnabled  — master switch
//   DZ_abandonedVehicleTimeout  — seconds of "abandoned" before deletion
//   DZ_abandonedVehicleCheckInterval — how often the PFH polls

missionNamespace setVariable ["DZ_enableLiveDespawn",        true];
missionNamespace setVariable ["DZ_cleanupDelay",             300];   // 5 min sector despawn
missionNamespace setVariable ["DZ_missionCleanupDelay",      900];   // 15 min mission cleanup
missionNamespace setVariable ["DZ_abandonedVehicleEnabled",  true];
missionNamespace setVariable ["DZ_abandonedVehicleTimeout",  900];   // 15 min unused
missionNamespace setVariable ["DZ_abandonedVehicleCheckInterval", 60];   // poll every 60s
