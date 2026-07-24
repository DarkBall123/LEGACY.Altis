/*
 * DZ_fnc_uiInit
 * Starts the unified client HUD, periodic state snapshots and the ACE
 * self-interaction used to open the field tablet.
 */

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["DZ_uiInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_uiInitialized", true];

[] call DZ_fnc_uiPreviewDestroy;

uiNamespace setVariable ["DZ_uiNotifications", []];
uiNamespace setVariable ["DZ_uiNotificationHistory", []];
uiNamespace setVariable ["DZ_uiSnapshot", []];
uiNamespace setVariable ["DZ_uiEwState", [0, ""]];
uiNamespace setVariable ["DZ_uiTabletTab", "overview"];
uiNamespace setVariable ["DZ_uiTabletSelection", 0];
uiNamespace setVariable ["DZ_uiTerminalKind", "field"];
uiNamespace setVariable ["DZ_uiTerminalObject", objNull];
uiNamespace setVariable ["DZ_uiTerminalContext", ""];
uiNamespace setVariable ["DZ_uiPreviewObject", objNull];
uiNamespace setVariable ["DZ_uiPreviewCamera", objNull];
uiNamespace setVariable ["DZ_uiPreviewLights", []];
uiNamespace setVariable ["DZ_uiPreviewClass", ""];

DZ_fnc_uiRequestSnapshotLocal =
{
    if (isNull player) exitWith {};

    if (isServer) then
    {
        [player] call DZ_fnc_requestUiSnapshot;
    }
    else
    {
        [player] remoteExecCall ["DZ_fnc_requestUiSnapshot", 2];
    };
};

// The campaign UI is tablet-only. Clear an older HUD layer if this
// mission was restarted without returning to the main menu.
"DZ_HUD_LAYER" cutText ["", "PLAIN"];
uiNamespace setVariable ["DZ_HudDisplay", displayNull];

private _addTabletAction =
{
    params [["_unit", objNull]];
    if (isNull _unit) exitWith {};
    if (_unit getVariable ["DZ_uiTabletActionAdded", false]) exitWith {};
    _unit setVariable ["DZ_uiTabletActionAdded", true];

    if (!isNil "ace_interact_menu_fnc_createAction") then
    {
        private _action =
        [
            "DZ_FieldTablet",
            "Полевой планшет ОКСВ",
            "",
            { ["overview", "field", objNull, ""] call DZ_fnc_uiOpenTablet; },
            { alive player },
            {},
            [],
            {[0, 0, 0]},
            2
        ] call ace_interact_menu_fnc_createAction;

        [_unit, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    }
    else
    {
        _unit addAction
        [
            "Полевой планшет ОКСВ",
            { ["overview", "field", objNull, ""] call DZ_fnc_uiOpenTablet; },
            nil,
            0,
            false,
            true,
            "",
            "alive _this"
        ];
    };
};

uiNamespace setVariable ["DZ_uiAddTabletAction", _addTabletAction];

[
    { !isNull player && { time > 0 } },
    {
        params ["_addTabletAction"];
        [player] call _addTabletAction;
        [] call DZ_fnc_uiRequestSnapshotLocal;
    },
    [_addTabletAction]
] call CBA_fnc_waitUntilAndExecute;

["unit",
{
    params ["_unit"];
    [
        { !isNull (_this # 0) },
        {
            params ["_unit"];
            private _addTabletAction = uiNamespace getVariable ["DZ_uiAddTabletAction", {}];
            [_unit] call _addTabletAction;
            [] call DZ_fnc_uiRequestSnapshotLocal;
        },
        [_unit]
    ] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_addPlayerEventHandler;

[
    {
        if (!isNull player) then
        {
            [] call DZ_fnc_uiRequestSnapshotLocal;
        };
    },
    1,
    []
] call CBA_fnc_addPerFrameHandler;

// Animate only the client-local showroom object used by the open tablet.
// Nothing is rendered in the world HUD while the dialog is closed.
[
    {
        private _display = uiNamespace getVariable ["DZ_TabletDisplay", displayNull];
        if (!isNull _display) then
        {
            private _previewObject = uiNamespace getVariable ["DZ_uiPreviewObject", objNull];
            if (!isNull _previewObject) then
            {
                _previewObject setDir ((diag_tickTime * 5) mod 360);
            };
        };
    },
    0,
    []
] call CBA_fnc_addPerFrameHandler;

[
    "ПОЛЕВАЯ СЕТЬ",
    "Интерфейс ОКСВ подключён. Планшет доступен через ACE-взаимодействие с собой.",
    "success",
    7
] call DZ_fnc_uiNotify;

true
