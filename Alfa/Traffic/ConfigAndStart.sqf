/*
 * Alfa/Traffic/ConfigAndStart.sqf
 * Configures vehicle classes, spawn distances, traffic limits, and starts Alfa traffic.
 */

private ["_parameters"];

private _civilianCarClasses =
[
    "LOP_CHR_Civ_Offroad",
    "LOP_CHR_Civ_Landrover",
    "LOP_CHR_Civ_Hatchback",
    "LOP_CHR_Civ_UAZ_Open",
    "LOP_CHR_Civ_UAZ",
    "LOP_CHR_Civ_Ural",
    "LOP_CHR_Civ_Ural_open",
    "UK3CB_C_Lada",
    "UK3CB_C_OLD_BIKE",
    "UK3CB_C_TT650",
    "UK3CB_C_Gaz24",
    "UK3CB_C_YAVA"
];

diag_log format ["[TRAFFIC] Civilian car pool size: %1", count _civilianCarClasses];


_parameters = [
    ["SIDE", civilian],
    ["VEHICLES", _civilianCarClasses],
    ["VEHICLES_COUNT", 2],
    ["MIN_SPAWN_DISTANCE", 400],
    ["MAX_SPAWN_DISTANCE", 1200],
    ["MIN_SKILL", 0.75],
    ["MAX_SKILL", 0.9],
    ["DEBUG", false]
];


_parameters spawn ENGIMA_TRAFFIC_StartTraffic;
