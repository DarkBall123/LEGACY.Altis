/*
 * Alfa/Traffic/ConfigAndStart.sqf
 * Configures vehicle classes, spawn distances, traffic limits, and starts Alfa traffic.
 */

private ["_parameters"];

private _civilianCarClasses =
[
    "RHS_Ural_Civ_02",
    "RHS_Ural_Open_Civ_02",
    "RHS_Ural_Civ_01",
    "RHS_Ural_Open_Civ_01",
    "UK3CB_C_Ikarus_RED",
    "UK3CB_C_S1203_Ambulance",
    "C_Tractor_01_F",
    "C_Offroad_01_repair_F",
    "UK3CB_C_S1203",
    "UK3CB_C_Skoda",
    "UK3CB_C_Kamaz_Fuel",
    "UK3CB_C_Kamaz_Repair",
    "UK3CB_C_OLD_BIKE",
    "C_Hatchback_01_F"
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
