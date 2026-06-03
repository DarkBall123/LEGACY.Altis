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

private _enemyAirSupportClasses =
[
    ["UK3CB_MDF_O_UH1H_M240", 0.75],
    ["UK3CB_MDF_O_Mystere",   0.25]
];


// ── MEF (UK3CB Malden Defence Force) unit pools ───────────────────────
// Rebalanced for variety: the old pools were RIF_1-dominated (weight
// 1.0 vs everyone else at 0.10-0.55), so every squad looked the same.
// New shape: RIF_1 is the baseline anchor at 1.0, but the
// supporting specialists are bumped to 0.40-0.70 so a 4-man squad
// reliably picks up a mix of AR/LAT/GL/MD + the occasional sniper or
// HMG. Each pool has a clear flavour:
//   urban    : close-combat heavy (LAT, GL, HMG, MD)
//   open     : long-range capable (SNI, SPOT, AT, AA)
//   counter  : assault loadout (more AR/HMG, AT pairs, MD)

private _urbanUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    1.00],
    ["UK3CB_MDF_O_AR",       0.70],
    ["UK3CB_MDF_O_LAT",      0.65],
    ["UK3CB_MDF_O_GL",       0.55],
    ["UK3CB_MDF_O_MD",       0.45],
    ["UK3CB_MDF_O_HMG",      0.40],
    ["UK3CB_MDF_O_HMG_ASST", 0.30],
    ["UK3CB_MDF_O_AT",       0.30],
    ["UK3CB_MDF_O_AT_ASST",  0.22],
    ["UK3CB_MDF_O_ENG",      0.25],
    ["UK3CB_MDF_O_DEM",      0.20],
    ["UK3CB_MDF_O_SNI",      0.18],
    ["UK3CB_MDF_O_SPOT",     0.15]
];

private _openUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    1.00],
    ["UK3CB_MDF_O_AR",       0.65],
    ["UK3CB_MDF_O_LAT",      0.60],
    ["UK3CB_MDF_O_AT",       0.50],
    ["UK3CB_MDF_O_AT_ASST",  0.40],
    ["UK3CB_MDF_O_SNI",      0.45],
    ["UK3CB_MDF_O_SPOT",     0.35],
    ["UK3CB_MDF_O_GL",       0.45],
    ["UK3CB_MDF_O_MD",       0.40],
    ["UK3CB_MDF_O_AA",       0.30],
    ["UK3CB_MDF_O_AA_ASST",  0.25],
    ["UK3CB_MDF_O_ENG",      0.18]
];

private _counterUnitPool =
[
    ["UK3CB_MDF_O_RIF_1",    1.00],
    ["UK3CB_MDF_O_AR",       0.75],
    ["UK3CB_MDF_O_LAT",      0.65],
    ["UK3CB_MDF_O_AT",       0.55],
    ["UK3CB_MDF_O_AT_ASST",  0.40],
    ["UK3CB_MDF_O_GL",       0.55],
    ["UK3CB_MDF_O_HMG",      0.45],
    ["UK3CB_MDF_O_HMG_ASST", 0.35],
    ["UK3CB_MDF_O_MD",       0.40],
    ["UK3CB_MDF_O_SNI",      0.25],
    ["UK3CB_MDF_O_SPOT",     0.20],
    ["UK3CB_MDF_O_DEM",      0.15]
];

private _urbanFixedSquads =
[
    // Solo / pair / triad scout patterns ─────────────────────────────
    [["UK3CB_MDF_O_TL"],                                                                                                     0.35],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1"],                                                                                0.50],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                                              1.00],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_LAT"],                                                             0.85],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                                              0.95],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_GL",    "UK3CB_MDF_O_MD"],                                                              0.90],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_DEM",   "UK3CB_MDF_O_RIF_1"],                                                           0.55],
    // Quad+ urban specialist mixes ────────────────────────────────────
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR",    "UK3CB_MDF_O_HMG",    "UK3CB_MDF_O_HMG_ASST"],                                  0.65],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AT",    "UK3CB_MDF_O_AT_ASST","UK3CB_MDF_O_RIF_1"],                                     0.70],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_ENG",   "UK3CB_MDF_O_DEM",    "UK3CB_MDF_O_RIF_1"],                                     0.40],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_GL",    "UK3CB_MDF_O_LAT",    "UK3CB_MDF_O_MD"],                                        0.65]
];

private _openFixedSquads =
[
    // Lean recce ─────────────────────────────────────────────────────
    [["UK3CB_MDF_O_TL"],                                                                                                     0.45],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1"],                                                                                0.55],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_SNI",   "UK3CB_MDF_O_SPOT"],                                                            0.70],
    // Standard fireteams ─────────────────────────────────────────────
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                                                              0.90],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR",    "UK3CB_MDF_O_LAT"],                                                             0.85],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_MD",    "UK3CB_MDF_O_AT"],                                                              0.70],
    // AT pairs + AA fire teams ───────────────────────────────────────
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AT",    "UK3CB_MDF_O_AT_ASST","UK3CB_MDF_O_RIF_1"],                                     0.65],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AA",    "UK3CB_MDF_O_AA_ASST","UK3CB_MDF_O_RIF_1"],                                     0.55],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_SNI",   "UK3CB_MDF_O_SPOT",   "UK3CB_MDF_O_RIF_1"],                                     0.45],
    // Big footprint mixed patrol ─────────────────────────────────────
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AR",    "UK3CB_MDF_O_LAT",    "UK3CB_MDF_O_GL",    "UK3CB_MDF_O_MD"],                   0.50]
];

private _counterFixedSquads =
[
    // Aggressive assault patterns ────────────────────────────────────
    [["UK3CB_MDF_O_SL"],                                                                                                     0.45],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                                                              0.65],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_SNI",   "UK3CB_MDF_O_AT"],                                                              0.55],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR"],                                                              0.95],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AR",     "UK3CB_MDF_O_HMG"],                                       0.70],
    [["UK3CB_MDF_O_TL", "UK3CB_MDF_O_MD",    "UK3CB_MDF_O_AT"],                                                              0.65],
    // Heavy-hitter compositions ──────────────────────────────────────
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AT",    "UK3CB_MDF_O_AT_ASST","UK3CB_MDF_O_AR",     "UK3CB_MDF_O_MD"],                  0.60],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_HMG",   "UK3CB_MDF_O_HMG_ASST","UK3CB_MDF_O_LAT",   "UK3CB_MDF_O_RIF_1"],               0.55],
    [["UK3CB_MDF_O_SL", "UK3CB_MDF_O_GL",    "UK3CB_MDF_O_AR",     "UK3CB_MDF_O_LAT",    "UK3CB_MDF_O_RIF_1"],               0.55]
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
// Pre-built crew + vehicle units. Expanded with the M113 humvee family
// and M998/M1025 light transports so MEF appearances stop looking
// repetitive. The MTVR truck shows up more often in counter-attacks
// (it's the natural reinforcement truck — drops a 5-man team).

private _urbanPackages =
[
    // Light technical patrols ──────────────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_MB4WD_LMG"],       0.12],   // Apex DLC — rare
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_Offroad_HMG"],     0.55],   // bumped
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_M113_M240"],       0.55],
    // Heavier humvee patrols ──────────────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M113_M2"],         0.45],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M1151_OGPK_M2"],   0.40],
    // Unarmed light transport patrols ─────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_MD"],                                        "UK3CB_MDF_O_M998_2DR"],        0.30],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_GL"],                                        "UK3CB_MDF_O_M1025_Unarmed"],   0.30],
    // Reinforcement truck (rare) ──────────────────────────────────────
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],    "UK3CB_MDF_O_MTVR_Open"],       0.25]
];

private _openPackages =
[
    // Mobile light recon ──────────────────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_Offroad_HMG"],     0.55],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_M1151"],           0.50],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_MB4WD_LMG"],       0.12],   // Apex DLC — rare
    // Crew-served + AT pair ───────────────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M1151_OGPK_M2"],   0.40],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M113_M2"],         0.35],
    // Light unarmed transports ────────────────────────────────────────
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_SNI"],                                       "UK3CB_MDF_O_M998_2DR"],        0.30],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_MD"],                                        "UK3CB_MDF_O_M113_Unarmed"],    0.30],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_GL", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_M1025_Unarmed"],   0.30],
    // Big reinforcement (rare) ────────────────────────────────────────
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],    "UK3CB_MDF_O_MTVR_Open"],       0.25]
];

private _counterPackages =
[
    // Heavy assault crews ─────────────────────────────────────────────
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M1151_OGPK_M2"],   0.50],
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT"],                      "UK3CB_MDF_O_M113_M2"],         0.50],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_Offroad_HMG"],     0.45],
    [[["UK3CB_MDF_O_TL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_RIF_1"],                                        "UK3CB_MDF_O_M113_M240"],       0.45],
    // Truck-borne reinforcements ──────────────────────────────────────
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_AT", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_MD"],    "UK3CB_MDF_O_MTVR_Open"],       0.50],
    [[["UK3CB_MDF_O_SL", "UK3CB_MDF_O_RIF_1", "UK3CB_MDF_O_GL", "UK3CB_MDF_O_AR", "UK3CB_MDF_O_HMG"],   "UK3CB_MDF_O_MTVR_Open"],       0.40]
];

// ── Vehicle pools ────────────────────────────────────────────────────
// Re-shaped after adding the M113 humvee family and M1025/M998 light
// transports. Pools are bigger and more varied so AI sightings stop
// being "again with the same MB4WD". Weights are RELATIVE — RIF-vs-
// AT-pattern-style probability split — not absolute %.

// Urban patrols favour the M113 family (close-quarters firepower) and
// the M1151 OGPK turret. Open offroads are de-emphasised because they
// die fast in built-up areas.
private _urbanVehiclePool =
[
    ["UK3CB_MDF_O_M113_M2",          0.65],
    ["UK3CB_MDF_O_M113_M240",        0.70],
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.50],
    ["UK3CB_MDF_O_Offroad_HMG",      0.55],   // bumped (covers some of MB4WD's slack)
    ["UK3CB_MDF_O_MB4WD_LMG",        0.12],   // Apex DLC — rare cameo, not common patrol
    ["UK3CB_MDF_O_M998_2DR",         0.35],
    ["UK3CB_MDF_O_M1025_Unarmed",    0.30],
    ["UK3CB_MDF_O_M60A3",            0.10]
];

// Open / rural pool — mobility matters more. Mix armed and unarmed
// light transports liberally. Tanks remain rare punctuation.
private _openVehiclePool =
[
    ["UK3CB_MDF_O_Offroad_HMG",      0.65],   // bumped
    ["UK3CB_MDF_O_MB4WD_LMG",        0.12],   // Apex DLC — rare cameo
    ["UK3CB_MDF_O_M1151",            0.55],   // bumped
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.45],
    ["UK3CB_MDF_O_M113_M240",        0.45],   // bumped
    ["UK3CB_MDF_O_M113_Unarmed",     0.45],
    ["UK3CB_MDF_O_M1025_Unarmed",    0.55],
    ["UK3CB_MDF_O_M998_2DR",         0.50],
    ["UK3CB_MDF_O_Offroad_Unarmed",  0.50],   // bumped
    ["UK3CB_MDF_O_MB4WD_Unarmed",    0.10],   // Apex DLC — rare cameo
    ["UK3CB_MDF_O_M60A3",            0.12]
];

// Counter-attacks lean heavy: armed humvees + M113 gunners + the tank
// has a marginally higher chance of showing up.
private _counterVehiclePool =
[
    ["UK3CB_MDF_O_M1151_OGPK_M2",    0.55],
    ["UK3CB_MDF_O_M113_M2",          0.55],
    ["UK3CB_MDF_O_M113_M240",        0.50],
    ["UK3CB_MDF_O_Offroad_HMG",      0.55],   // bumped
    ["UK3CB_MDF_O_MB4WD_LMG",        0.12],   // Apex DLC — rare cameo
    ["UK3CB_MDF_O_M1151",            0.30],
    ["UK3CB_MDF_O_MTVR_Open",        0.30],
    ["UK3CB_MDF_O_M60A3",            0.20]
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
    ["UK3CB_MDF_O_MTVR_Reammo",      ["truck"]],
    // Humvee family (additions): two armed M113 humvee variants plus
    // three light unarmed transports. Categorise armed = technical,
    // unarmed = utility so caps still gate them sensibly.
    ["UK3CB_MDF_O_M113_M2",          ["technical"]],
    ["UK3CB_MDF_O_M113_M240",        ["technical"]],
    ["UK3CB_MDF_O_M113_Unarmed",     ["utility"]],
    ["UK3CB_MDF_O_M1025_Unarmed",    ["utility"]],
    ["UK3CB_MDF_O_M998_2DR",         ["utility"]]
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
missionNamespace setVariable ["DZ_sectorInfluenceRadius", _gridSize * 0.9];
missionNamespace setVariable ["DZ_preSpawnFactor", 1.5];
missionNamespace setVariable ["DZ_updateInterval", 1];
missionNamespace setVariable ["DZ_corpseCleanupInterval", 1800];
missionNamespace setVariable ["DZ_enableCorpseCleanup", true];
missionNamespace setVariable ["DZ_loadoutSaveInterval", 60];
missionNamespace setVariable ["DZ_respawnPoints", _respawnPoints];
missionNamespace setVariable ["DZ_scriptRespawnMarkersEnabled", false];

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
missionNamespace setVariable ["DZ_frontierCaptureOnly", true];
missionNamespace setVariable ["DZ_frontierSeedBaseSectors", true];
missionNamespace setVariable ["DZ_frontierBaseRadius", _gridSize * 1.25];
missionNamespace setVariable ["DZ_frontierPruneDisconnectedSaves", true];
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

// ── Option B sector model: zone radii per BIS location type ─────────
// Sectors are now anchored on real named locations (towns, airports,
// villages…) instead of a uniform 350m grid. Each type has a default
// radius; override via DZ_zoneRadiiOverride below if you want capitals
// to be bigger, villages smaller, etc.
//
// Defaults (in metres):       capital 1000 / city 800 / village 500
//                             local 400  /  airport 900 / CityCenter 700
//
// DZ_adjacencyBuffer: extra gap (m) between two zones' boundaries
// before they're considered neighbours for the frontier graph. Smaller
// buffer = more disconnected zones (harder to push deep). Larger = more
// chained captures possible.
//
// DZ_adjacencyMaxNeighbours: cap on how many neighbours each zone can
// have. Prevents a capital surrounded by villages from accumulating
// 20+ frontier links and bogging down the graph.
missionNamespace setVariable ["DZ_zoneRadiiOverride",     createHashMap];
missionNamespace setVariable ["DZ_adjacencyBuffer",       800];
missionNamespace setVariable ["DZ_adjacencyMaxNeighbours", 8];

// ── Resource node system (Tier 1) ────────────────────────────────────
// Strategic income nodes. Each is anchored at a real Altis location.
// Whichever player faction controls the sector containing the node
// gets a wallet income tick every DZ_resourceTickInterval seconds.
// MEF-held / contested nodes pay nothing.
//
// Entry shape: [nodeId, displayName, position, type, perTickIncome]
//   - type is a free-form tag for now; future versions can attach
//     special effects per type (intel reveal, price discount, …).
//
// Position tweakable in Eden by anyone with admin — these are sensible
// defaults near each landmark, but you can override via
// DZ_resourceNodePosOverride hashmap (nodeId → [x,y,0]) without
// editing this file.
missionNamespace setVariable ["DZ_resourceTickInterval", 1800];   // 30 min
missionNamespace setVariable ["DZ_resourceMarkerRefreshInterval", 15]; // visual refresh

missionNamespace setVariable ["DZ_resourceNodes",
[
    // [nodeId,             displayName,                       position,             type,            perTick]
    ["athanos_oil",        "Athanos Refinery",                [17800, 5300,    0],  "oil",           300],
    ["altis_intl_fuel",    "Altis International Airport",     [18800, 13500,   0],  "air_fuel",      160],
    ["selakano_quarry",    "Selakano Quarry",                 [22500, 6500,    0],  "quarry",        200],
    ["pyrgos_intel",       "Pyrgos Data Center",              [16800, 12500,   0],  "intel",         120],
    ["kavala_factory",     "Kavala Factory",                  [3700,  13000,   0],  "manufacturing", 160],
    ["sofia_oil",          "Sofia Oil Pump",                  [22600, 19500,   0],  "oil",           300],
    ["molos_airfield",     "Molos Airfield",                  [12300, 18000,   0],  "air_fuel",      160]
]];

// Marker icon per resource type. Anything not listed falls back to mil_dot.
missionNamespace setVariable ["DZ_resourceNodeMarkerType", createHashMapFromArray
[
    ["oil",           "loc_Fuelstation"],
    ["air_fuel",      "loc_Heliport"],
    ["quarry",        "loc_Quarry"],
    ["intel",         "loc_Transmitter"],
    ["manufacturing", "loc_Power"]
]];

missionNamespace setVariable ["DZ_styleWestOwned", 0];
missionNamespace setVariable ["DZ_styleEastOwned", 1];
missionNamespace setVariable ["DZ_styleResistanceOwned", 2];
missionNamespace setVariable ["DZ_styleEnemyDormant", 1];
missionNamespace setVariable ["DZ_styleEnemyActive", 1];
missionNamespace setVariable ["DZ_stylePlayerOwned", 0];
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

// Trophy vehicle storage: pad object Variable Names that grant the
// "Сохранить трофейную технику" ACE action. vehicle_delivery_pad is the
// IDAP shop pad (both factions), logistics_point is the Free Altis FOB
// motorcycle dispatcher, police_trophy is the APD base trophy pad.
missionNamespace setVariable ["DZ_trophyVehicleStoragePadNames",
    ["vehicle_delivery_pad", "logistics_point", "police_trophy"], true];
