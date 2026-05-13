params [
    ["_missionId", "", [""]],
    ["_source", "manual", [""]],
    ["_definition", createHashMap, [createHashMap]]
];

if (!isServer) exitWith { false };
if (_missionId == "") exitWith { false };

private _title = _definition getOrDefault ["title", _missionId];

missionNamespace setVariable ["DZ_missionActive", true, true];
missionNamespace setVariable ["DZ_missionCurrentId", _missionId, true];
missionNamespace setVariable ["DZ_missionCurrentTitle", _title, true];
missionNamespace setVariable ["DZ_missionSource", _source, true];
missionNamespace setVariable ["DZ_missionStartTime", time, true];
missionNamespace setVariable ["DZ_missionUnits", []];
missionNamespace setVariable ["DZ_missionMarkers", []];
missionNamespace setVariable ["DZ_missionVehicles", []];
missionNamespace setVariable ["DZ_missionPfhHandles", []];

["DZ_missionStarted", [_missionId, _source, _title]] call CBA_fnc_localEvent;

true
