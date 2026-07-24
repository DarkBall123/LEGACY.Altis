/*
 * DZ_fnc_uiPreviewDestroy
 * Tears down the client-local showroom used by the tablet preview.
 */

if (!hasInterface) exitWith { false };

private _camera = uiNamespace getVariable ["DZ_uiPreviewCamera", objNull];
if (!isNull _camera) then
{
    _camera cameraEffect ["Terminate", "Back", "dzuipreviewrt"];
    camDestroy _camera;
};

private _object = uiNamespace getVariable ["DZ_uiPreviewObject", objNull];
if (!isNull _object) then
{
    deleteVehicle _object;
};

{
    if (!isNull _x) then
    {
        deleteVehicle _x;
    };
} forEach (uiNamespace getVariable ["DZ_uiPreviewLights", []]);

uiNamespace setVariable ["DZ_uiPreviewCamera", objNull];
uiNamespace setVariable ["DZ_uiPreviewObject", objNull];
uiNamespace setVariable ["DZ_uiPreviewLights", []];
uiNamespace setVariable ["DZ_uiPreviewClass", ""];
uiNamespace setVariable ["DZ_uiPreviewKey", ""];

true
