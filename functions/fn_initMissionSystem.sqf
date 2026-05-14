/*
 * DZ_fnc_initMissionSystem
 * Initializes mission lifecycle state, definitions, assets, and cooldown storage.
 */

if (!isServer) exitWith { false };

if ((count (missionNamespace getVariable ["DZ_missionDefinitions", createHashMap])) == 0) then
{
    private _definitions = call DZ_fnc_getMissionDefinitions;
    missionNamespace setVariable ["DZ_missionDefinitions", _definitions, true];
};

missionNamespace setVariable ["DZ_missionSchedulerEnabled", missionNamespace getVariable ["DZ_missionSchedulerEnabled", false]];
missionNamespace setVariable ["DZ_missionEventInterval", missionNamespace getVariable ["DZ_missionEventInterval", 1200]];
missionNamespace setVariable ["DZ_missionEventInitialDelay", missionNamespace getVariable ["DZ_missionEventInitialDelay", 1200]];
missionNamespace setVariable ["DZ_missionAutoMinPlayers", missionNamespace getVariable ["DZ_missionAutoMinPlayers", 1]];
missionNamespace setVariable ["DZ_missionCooldowns", missionNamespace getVariable ["DZ_missionCooldowns", createHashMap]];

if (isNil "DZ_missionConvoyRoutes") then
{
    DZ_missionConvoyRoutes =
    [
        [[4500, 6200, 0], [6800, 5100, 0]],
        [[7200, 8400, 0], [5100, 9200, 0]],
        [[3800, 4100, 0], [6200, 3900, 0]]
    ];
};

if (isNil "DZ_missionHvtLocations") then
{
    DZ_missionHvtLocations =
    [
        [5200, 7800, 0],
        [8100, 6300, 0],
        [4700, 9100, 0],
        [6500, 4800, 0]
    ];
};

if (isNil "DZ_missionPilotLocations") then
{
    DZ_missionPilotLocations =
    [
        [5800, 8200, 0],
        [7400, 5600, 0],
        [4200, 7100, 0],
        [6900, 9400, 0]
    ];
};

if (isNil "DZ_missionExtractLz") then
{
    DZ_missionExtractLz =
    [
        [4100, 5900, 0],
        [7800, 7200, 0],
        [5500, 4300, 0]
    ];
};

missionNamespace setVariable ["DZ_missionActive", missionNamespace getVariable ["DZ_missionActive", false], true];
missionNamespace setVariable ["DZ_missionCurrentId", missionNamespace getVariable ["DZ_missionCurrentId", ""], true];
missionNamespace setVariable ["DZ_missionCurrentTitle", missionNamespace getVariable ["DZ_missionCurrentTitle", ""], true];
missionNamespace setVariable ["DZ_missionSource", missionNamespace getVariable ["DZ_missionSource", ""], true];
missionNamespace setVariable ["DZ_missionStartTime", missionNamespace getVariable ["DZ_missionStartTime", 0], true];
missionNamespace setVariable ["DZ_missionUnits", missionNamespace getVariable ["DZ_missionUnits", []]];
missionNamespace setVariable ["DZ_missionMarkers", missionNamespace getVariable ["DZ_missionMarkers", []]];
missionNamespace setVariable ["DZ_missionVehicles", missionNamespace getVariable ["DZ_missionVehicles", []]];
missionNamespace setVariable ["DZ_missionPfhHandles", missionNamespace getVariable ["DZ_missionPfhHandles", []]];

true
