/* 
 * This file contains parameters to config and function call to start an instance of
 * traffic in the mission. The file is edited by the mission developer.
 *
 * See file Engima\Traffic\Documentation.txt for documentation and a full reference of 
 * how to customize and use Engima's Traffic.
 */
 
private ["_parameters"];

private _civilianCarClasses =
[
    "LOP_AFR_Civ_UAZ",
    "LOP_AFR_Civ_UAZ_Open",
    "LOP_AFR_Civ_Hatchback",
    "LOP_AFR_Civ_Landrover",
    "LOP_AFR_Civ_Offroad",
    "LOP_AFR_Civ_Ural_open",
    "LOP_AFR_Civ_Ural"
];

diag_log format ["[TRAFFIC] Civilian car pool size: %1", count _civilianCarClasses];

// Set traffic parameters.
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

// Start an instance of the traffic
_parameters spawn ENGIMA_TRAFFIC_StartTraffic;
