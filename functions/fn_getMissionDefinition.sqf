/*
 * DZ_fnc_getMissionDefinition
 * Returns one mission definition by id from the registered mission table.
 */

params [
    ["_missionId", "", [""]]
];

private _definitions = missionNamespace getVariable ["DZ_missionDefinitions", createHashMap];

if ((count _definitions) == 0) then
{
    _definitions = call DZ_fnc_getMissionDefinitions;
    missionNamespace setVariable ["DZ_missionDefinitions", _definitions];
};

_definitions getOrDefault [_missionId, createHashMap]
