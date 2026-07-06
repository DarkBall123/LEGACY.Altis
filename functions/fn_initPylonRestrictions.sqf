/*
 * DZ_fnc_initPylonRestrictions
 * Starts forbidden-pylon filtering and marks local Zeus-spawned assets as exempt.
 */

private _attachCuratorHandler =
{
    private _ensureSaveAction =
    {
        if (isNil { missionNamespace getVariable "DZ_zeusManualSaveProgressAction" }) then
        {
            missionNamespace setVariable
            [
                "DZ_zeusManualSaveProgressAction",
                [
                    "DZ_manual_save_progress",
                    "Сохранить прогресс",
                    "",
                    {
                        [] remoteExecCall ["DZ_fnc_manualSaveProgress", 2];
                    },
                    {
                        params ["_target", "_player", "_params"];
                        !isNull _target &&
                        { local _target } &&
                        { (getAssignedCuratorUnit _target) isEqualTo _player }
                    }
                ] call ace_interact_menu_fnc_createAction
            ];
        };

        if (isNil { missionNamespace getVariable "DZ_zeusManualSaveProgressSelfAction" }) then
        {
            missionNamespace setVariable
            [
                "DZ_zeusManualSaveProgressSelfAction",
                [
                    "DZ_manual_save_progress_self",
                    "Сохранить прогресс",
                    "",
                    {
                        [] remoteExecCall ["DZ_fnc_manualSaveProgress", 2];
                    },
                    {
                        params ["_target", "_player", "_params"];
                        _target isEqualTo _player &&
                        {
                            ({
                                (getAssignedCuratorUnit _x) isEqualTo _player
                            } count allCurators) > 0
                        }
                    }
                ] call ace_interact_menu_fnc_createAction
            ];
        };
    };

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

                        if (_entity isKindOf "AllVehicles" || { _entity isKindOf "ReammoBox_F" } || { _entity isKindOf "ThingX" }) then
                        {
                            [_entity] remoteExecCall ["DZ_fnc_requestPersistMark", 2];
                        };

                        if (_entity isKindOf "Air") then
                        {
                            diag_log format ["[DZ_PYLONS] Zeus asset exempted: %1 (%2)", typeOf _entity, _entity];
                        };
                    };
                }
            ];
        };

        if (!isNil "ace_interact_menu_fnc_createAction" && {!isNil "ace_interact_menu_fnc_addActionToObject"}) then
        {
            call _ensureSaveAction;

            private _saveAction = missionNamespace getVariable ["DZ_zeusManualSaveProgressAction", []];
            if (_saveAction isEqualType [] && { !(_curator getVariable ["DZ_zeusManualSaveProgressActionAdded", false]) }) then
            {
                _curator setVariable ["DZ_zeusManualSaveProgressActionAdded", true];
                [_curator, 0, ["ACE_MainActions"], _saveAction] call ace_interact_menu_fnc_addActionToObject;
            };
        };
    } forEach allCurators;

    if (!isNil "ace_interact_menu_fnc_createAction" &&
        {!isNil "ace_interact_menu_fnc_addActionToClass"} &&
        { !(missionNamespace getVariable ["DZ_zeusManualSaveProgressSelfActionAdded", false]) }) then
    {
        call _ensureSaveAction;
        missionNamespace setVariable ["DZ_zeusManualSaveProgressSelfActionAdded", true];

        private _selfSaveAction = missionNamespace getVariable ["DZ_zeusManualSaveProgressSelfAction", []];
        if (_selfSaveAction isEqualType []) then
        {
            ["CAManBase", 1, ["ACE_SelfActions"], _selfSaveAction, true] call ace_interact_menu_fnc_addActionToClass;
        };
    };
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
