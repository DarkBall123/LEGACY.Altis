/*
 * DZ_fnc_controlParams
 * Defines mission-wide constants, unit pools, spawn profiles, timings, and feature toggles.
 */

params [["_eps", 100]];

private _gridSize = 350;
private _zoneTemplate = [false, [[], []], -1, 0, false, -1, false, false, -1, -1];
private _enemyGroupRoot = configNull;

private _defaultEnemyUnitClass = "UK3CB_MDF_O_TL";

private _uavOperatorClasses   = ["UK3CB_MDF_O_OFF"];
private _uavOperatorBackpacks = ["O_Crocus_AP_Bag", "O_Crocus_AT_Bag"];

private _respawnPoints =
[
    // [label, position, side]
    ["APD",       [12295.449, 8872.09,   123.936], west],
    ["FreeAltis", [20791.287, 7269.035,   27.926], resistance]
];


// ── MEF (UK3CB Malden Defence Force) unit pools ───────────────────────
// Lean roster by design (no APC, no AT technical, no AR assistant, no
// rifleman variants). Weights tuned to keep MEF threatening but not OP.

private _urbanUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    1.00],
    ["UK3CB_MDF_O_LAT",      0.55],
    ["UK3CB_MDF_O_GL",       0.55],
    ["UK3CB_MDF_O_AR",       0.55],
    ["UK3CB_MDF_O_AT",       0.25],
    ["UK3CB_MDF_O_AT_ASST",  0.18],
    ["UK3CB_MDF_O_SNI",      0.20],
    ["UK3CB_MDF_O_SPOT",     0.15],
    ["UK3CB_MDF_O_MD",       0.20],
    ["UK3CB_MDF_O_HMG",      0.15],
    ["UK3CB_MDF_O_HMG_ASST", 0.10],
    ["UK3CB_MDF_O_ENG",      0.10],
    ["UK3CB_MDF_O_DEM",      0.08]
];

private _openUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    1.00],
    ["UK3CB_MDF_O_LAT",      0.65],
    ["UK3CB_MDF_O_GL",       0.50],
    ["UK3CB_MDF_O_AR",       0.55],
    ["UK3CB_MDF_O_AT",       0.45],
    ["UK3CB_MDF_O_AT_ASST",  0.25],
    ["UK3CB_MDF_O_SNI",      0.35],
    ["UK3CB_MDF_O_SPOT",     0.25],
    ["UK3CB_MDF_O_MD",       0.18],
    ["UK3CB_MDF_O_AA",       0.10],
    ["UK3CB_MDF_O_AA_ASST",  0.18]
];

private _counterUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    0.95],
    ["UK3CB_MDF_O_LAT",      0.55],
    ["UK3CB_MDF_O_GL",       0.55],
    ["UK3CB_MDF_O_AR",       0.60],
    ["UK3CB_MDF_O_AT",       0.50],
    ["UK3CB_MDF_O_AT_ASST",  0.30],
    ["UK3CB_MDF_O_SNI",      0.30],
    ["UK3CB_MDF_O_SPOT",     0.22],
    ["UK3CB_MDF_O_MD",       0.18],
    ["UK3CB_MDF_O_HMG",      0.25],
    ["UK3CB_MDF_O_HMG_ASST", 0.20]
];

private _urbanFixedSquads =
[
    [["UK3CB_MDF_O_TL"],                                                                       0.35],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1"],                                                  0.50],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                1.00],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_LAT"],                               0.85],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                0.95],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_GL",    "UK3CB_MDF_O_MD"],                                0.90],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_DEM",   "UK3CB_MDF_O_RIF_1"],                             0.55]
];

private _openFixedSquads =
[
    [["UK3CB_MDF_O_TL"],                                                                       0.45],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1"],                                                  0.55],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_SNI",   "UK3CB_MDF_O_AT"],                                0.70],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                                0.90],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR",    "UK3CB_MDF_O_LAT"],                               0.85],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_MD",    "UK3CB_MDF_O_AT"],                                0.70]
];

private _counterFixedSquads =
[
    [["UK3CB_MDF_O_SL"],                                                                       0.55],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                                0.65],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_SNI",   "UK3CB_MDF_O_AT"],                                0.55],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                0.95],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_HMG"],             0.70],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_MD",    "UK3CB_MDF_O_AT"],                                0.65]
];

private _urbanRandomSquads =
[
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1"]], ["pool", _urbanUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_SL"]],                       ["pool", _urbanUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR"]],     ["pool", _urbanUnitPool]], 0.40]
];

private _openRandomSquads =
[
    [createHashMapFromArray [["count", [2, 3]], ["required", ["UK3CB_MDF_O_TL"]],                       ["pool", _openUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AT"]],     ["pool", _openUnitPool]], 0.55],
    [createHashMapFromArray [["count", [3, 3]], ["required", ["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AT"]],     ["pool", _openUnitPool]], 0.35]
];

private _counterRandomSquads =
[
    [createHashMapFromArray [["count", [4, 5]], ["required", ["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AR"]],     ["pool", _counterUnitPool]], 0.80],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AT"]],     ["pool", _counterUnitPool]], 0.60],
    [createHashMapFromArray [["count", [3, 4]], ["required", ["UK3CB_MDF_O_TL"]],                       ["pool", _counterUnitPool]], 0.35]
];

private _urbanSquads   = _urbanFixedSquads   + _urbanRandomSquads;
private _openSquads    = _openFixedSquads    + _openRandomSquads;
private _counterSquads = _counterFixedSquads + _counterRandomSquads;

// ── Packages: infantry team + a paired vehicle ────────────────────────
// MEF has no APC, so the "heavy" pairing is the M1151 armed HMMWV and
// (very rarely, counter only) the M60A3 tank.

private _urbanPackages =
[
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_MB4WD_LMG"],     0.60],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],   "UK3CB_MDF_O_MTVR_Open"],       0.30],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                     "UK3CB_MDF_O_M1151_OGPK_M2"],   0.25]
];

private _openPackages =
[
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_Offroad_HMG"],     0.60],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],   "UK3CB_MDF_O_MTVR_Open"],       0.35],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                     "UK3CB_MDF_O_M1151_OGPK_M2"],   0.18],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_M1151"],     0.60]
];

private _counterPackages =
[
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_Offroad_HMG"],     0.55],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],   "UK3CB_MDF_O_MTVR_Open"],       0.32],
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                     "UK3CB_MDF_O_M1151_OGPK_M2"],   0.20]
];

// ── Vehicle pools (light technicals → M1151 → very rare tank) ─────────

private _urbanVehiclePool =
[
    ["UK3CB_MDF_O_Offroad_HMG",      0.60],
    ["UK3CB_MDF_O_MB4WD_LMG",        0.85],
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.30],
    ["UK3CB_MDF_O_M60A3",            0.15]
];

private _openVehiclePool =
[
    ["UK3CB_MDF_O_Offroad_HMG",      0.65],
    ["UK3CB_MDF_O_MB4WD_LMG",        0.75],
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.40],
    ["UK3CB_MDF_O_M1151",            0.55],
    ["UK3CB_MDF_O_Offroad_Unarmed",  0.80],
    ["UK3CB_MDF_O_MB4WD_Unarmed",    0.80],
    ["UK3CB_MDF_O_M60A3",            0.15]
];

private _counterVehiclePool =
[
    ["UK3CB_MDF_O_Offroad_HMG",      0.50],
    ["UK3CB_MDF_O_MB4WD_LMG",        0.60],
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.45],
    ["UK3CB_MDF_O_M1151",            0.20],
    ["UK3CB_MDF_O_MTVR_Open",        0.30],
    ["UK3CB_MDF_O_M60A3",            0.15]
];

private _vehicleMeta = createHashMapFromArray
[
    ["UK3CB_MDF_O_M60A3",            ["tank"]],
    ["UK3CB_MDF_O_M1151_OGPK_M2",    ["technical"]],
    ["UK3CB_MDF_O_M1151",            ["technical"]],
    ["UK3CB_MDF_O_Offroad_HMG",      ["technical"]],
    ["UK3CB_MDF_O_MB4WD_LMG",        ["technical"]],
    ["UK3CB_MDF_O_Offroad_Unarmed",  ["utility"]],
    ["UK3CB_MDF_O_MB4WD_Unarmed",    ["utility"]],
    ["UK3CB_MDF_O_MTVR_Open",        ["truck"]],
    ["UK3CB_MDF_O_MTVR_Refuel",      ["truck"]],
    ["UK3CB_MDF_O_MTVR_Repair",      ["truck"]],
    ["UK3CB_MDF_O_MTVR_Reammo",      ["truck"]]
];

// MEF has no APC class — the "apc" cap is dropped (caps only fire for
// categories that actually appear in the pools, so this is safe).
private _vehicleCategoryCaps = createHashMapFromArray
[
    ["tank",      1],
    ["technical", 4],
    ["truck",     2],
    ["utility",   2]
];

private _vehicleCategoryLocalCaps = createHashMapFromArray
[
    ["tank",      1],
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
missionNamespace setVariable ["DZ_preSpawnFactor", 1.5];
missionNamespace setVariable ["DZ_updateInterval", 1];
missionNamespace setVariable ["DZ_corpseCleanupInterval", 1200];
missionNamespace setVariable ["DZ_enableCorpseCleanup", true];
missionNamespace setVariable ["DZ_loadoutSaveInterval", 60];
missionNamespace setVariable ["DZ_respawnPoints", _respawnPoints];

missionNamespace setVariable ["DZ_cpChance", 0.0003];

// MEF (east) is the AI antagonist. Players are split across two sides:
// APD on west, "Free Altis" on resistance. Use DZ_playerSides for any
// "is this a player-faction unit?" check.
missionNamespace setVariable ["CH_sideEnemy",   east];
missionNamespace setVariable ["DZ_playerSides", [west, resistance]];
// CH_sidePlayers kept only as a single-side fallback for legacy code
// paths (set to the more military faction); prefer DZ_playerSides.
missionNamespace setVariable ["CH_sidePlayers", west];

missionNamespace setVariable ["DZ_captureHold", 60];
missionNamespace setVariable ["DZ_recaptureSpawnCooldown", 180];
missionNamespace setVariable ["DZ_spawnRetryCooldown", 30];
missionNamespace setVariable ["DZ_counterRepeatCooldown", 1000];
missionNamespace setVariable ["DZ_counterGlobalCooldown", 1000];
missionNamespace setVariable ["DZ_counterFirstChance", 0.01];
missionNamespace setVariable ["DZ_counterRepeatChance", 0.02];
missionNamespace setVariable ["DZ_counterMaxActive", 1];
missionNamespace setVariable ["DZ_counterAttacksEnabled", true];
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


missionNamespace setVariable ["DZ_enableLiveDespawn",        true];
missionNamespace setVariable ["DZ_cleanupDelay",             600];
missionNamespace setVariable ["DZ_missionCleanupDelay",      1200];
missionNamespace setVariable ["DZ_abandonedVehicleEnabled",  true];
missionNamespace setVariable ["DZ_abandonedVehicleTimeout",  1200];
missionNamespace setVariable ["DZ_abandonedVehicleCheckInterval", 60];
