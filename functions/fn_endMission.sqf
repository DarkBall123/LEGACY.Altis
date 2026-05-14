/*
 * DZ_fnc_endMission
 * Ends the active mission, updates cooldowns, notifies listeners, and schedules cleanup.
 */

params [["_result", "cancelled", [""]]];

if (!isServer) exitWith { false };

private _missionId = missionNamespace getVariable ["DZ_missionCurrentId", ""];
private _missionTitle = missionNamespace getVariable ["DZ_missionCurrentTitle", _missionId];
private _missionSource = missionNamespace getVariable ["DZ_missionSource", ""];


private _pfhHandles = missionNamespace getVariable ["DZ_missionPfhHandles", []];
{
    [_x] call CBA_fnc_removePerFrameHandler;
} forEach _pfhHandles;


private _unitsToClean    = +(missionNamespace getVariable ["DZ_missionUnits",    []]);
private _vehiclesToClean = +(missionNamespace getVariable ["DZ_missionVehicles", []]);
private _markersToClean  = +(missionNamespace getVariable ["DZ_missionMarkers",  []]);


if (_missionId != "") then
{
    private _cooldowns = missionNamespace getVariable ["DZ_missionCooldowns", createHashMap];
    _cooldowns set [_missionId, time];
    missionNamespace setVariable ["DZ_missionCooldowns", _cooldowns];
};


["DZ_missionEnded", [_missionId, _result, _missionSource, _missionTitle]] call CBA_fnc_localEvent;


missionNamespace setVariable ["DZ_missionActive", false, true];
missionNamespace setVariable ["DZ_missionCurrentId", "", true];
missionNamespace setVariable ["DZ_missionCurrentTitle", "", true];
missionNamespace setVariable ["DZ_missionSource", "", true];
missionNamespace setVariable ["DZ_missionStartTime", 0, true];
missionNamespace setVariable ["DZ_missionUnits", []];
missionNamespace setVariable ["DZ_missionMarkers", []];
missionNamespace setVariable ["DZ_missionVehicles", []];
missionNamespace setVariable ["DZ_missionPfhHandles", []];


private _message = switch (_result) do
{
    case "success": { "Миссия выполнена успешно. Хорошая работа." };
    case "failure": { "Миссия провалена." };
    default { "Миссия завершена досрочно." };
};

["hint", "Штаб", _message] call DZ_fnc_missionUi;


private _cleanupDelay = missionNamespace getVariable ["DZ_missionCleanupDelay", 300];

[
    {
        params ["_unitsToClean", "_vehiclesToClean", "_markersToClean"];

        {

            if (!isNull _x && { alive _x }) then
            {
                deleteVehicle _x;
            };
        } forEach _unitsToClean;

        {

            if (!isNull _x && { alive _x }) then
            {

                {
                    if (alive _x) then { deleteVehicle _x; };
                } forEach (crew _x);
                deleteVehicle _x;
            };
        } forEach _vehiclesToClean;


        {
            deleteMarker _x;
        } forEach _markersToClean;
    },
    [_unitsToClean, _vehiclesToClean, _markersToClean],
    _cleanupDelay
] call CBA_fnc_waitAndExecute;

true
