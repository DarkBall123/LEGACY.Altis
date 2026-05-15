/*
 * DZ_fnc_initPylonRestrictions
 * Starts forbidden-pylon filtering and marks local Zeus-spawned assets as exempt.
 */

private _attachCuratorHandler =
{
    {
        private _curator = _x;

        if (local _curator && { !(_curator getVariable ["DZ_pylonRestrictionsCuratorEh", false]) }) then
        {
            _curator setVariable ["DZ_pylonRestrictionsCuratorEh", true];
            _curator addEventHandler
            [
                "CuratorObjectPlaced",
                {
                    params ["_curator", "_entity"];

                    if (!isNull _entity) then
                    {
                        _entity setVariable ["DZ_createdByZeus", true, true];
                        _entity setVariable ["DZ_noPylonRestrictions", true, true];

                        if (_entity isKindOf "Air") then
                        {
                            diag_log format ["[DZ_PYLONS] Zeus asset exempted: %1 (%2)", typeOf _entity, _entity];
                        };
                    };
                }
            ];
        };
    } forEach allCurators;
};

if (hasInterface && { !(missionNamespace getVariable ["DZ_pylonRestrictionsCuratorWatcherDone", false]) }) then
{
    missionNamespace setVariable ["DZ_pylonRestrictionsCuratorWatcherDone", true];
    call _attachCuratorHandler;

    [
        {
            params ["_args", "_handle"];
            _args params ["_attachCuratorHandler"];
            call _attachCuratorHandler;
        },
        missionNamespace getVariable ["DZ_pylonCuratorCheckInterval", 5],
        [_attachCuratorHandler]
    ] call CBA_fnc_addPerFrameHandler;
};

if (!isServer) exitWith {};
if (missionNamespace getVariable ["DZ_pylonRestrictionsInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_pylonRestrictionsInitDone", true];

missionNamespace setVariable ["DZ_forbiddenPylonClassTokens", ["EMP", "NAPALM", "FSNB_", "ASPHYXIANT", "BLISTER", "NERVE", "NOVA", "RIOTCSGAS"], true];
missionNamespace setVariable ["DZ_forbiddenPylonDisplayTokens", ["EMP", "GAS", "NUCLEAR", "BLISTER AGENT", "NAPALM"], true];

call _attachCuratorHandler;

addMissionEventHandler
[
    "EntityCreated",
    {
        params ["_entity"];

        if (!isNull _entity && { _entity isKindOf "Air" }) then
        {
            [_entity] spawn
            {
                params ["_entity"];
                sleep 1;
                [_entity] call DZ_fnc_enforcePylonRestrictions;
            };
        };
    }
];

[
    {
        params ["_args", "_handle"];
        _args params ["_attachCuratorHandler"];

        call _attachCuratorHandler;

        {
            [_x] call DZ_fnc_enforcePylonRestrictions;
        } forEach (vehicles select { !isNull _x && { _x isKindOf "Air" } });
    },
    missionNamespace getVariable ["DZ_pylonRestrictionCheckInterval", 15],
    [_attachCuratorHandler]
] call CBA_fnc_addPerFrameHandler;

{
    [_x] call DZ_fnc_enforcePylonRestrictions;
} forEach (vehicles select { !isNull _x && { _x isKindOf "Air" } });

diag_log "[DZ_PYLONS] Forbidden pylon restriction system initialized.";
