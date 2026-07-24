/*
 * DZ_fnc_uiPreviewSetClass
 * Builds a lit client-local 3D showroom and broadcasts it to the
 * dzuipreviewrt render target used by the tablet.
 */

params [["_className", "", [""]]];

if (!hasInterface) exitWith { false };
if (_className == "") exitWith
{
    [] call DZ_fnc_uiPreviewDestroy;
    false
};
if (!isClass (configFile >> "CfgVehicles" >> _className)) exitWith
{
    diag_log format ["[DZ_UI_PREVIEW] Missing CfgVehicles class: %1", _className];
    [] call DZ_fnc_uiPreviewDestroy;
    false
};
if (!isPiPEnabled) exitWith
{
    diag_log "[DZ_UI_PREVIEW] PiP is disabled in video options.";
    [] call DZ_fnc_uiPreviewDestroy;
    false
};

private _currentClass = uiNamespace getVariable ["DZ_uiPreviewClass", ""];
private _currentObject = uiNamespace getVariable ["DZ_uiPreviewObject", objNull];
private _currentCamera = uiNamespace getVariable ["DZ_uiPreviewCamera", objNull];
if (
    _currentClass == _className
    && { !isNull _currentObject }
    && { !isNull _currentCamera }
) exitWith { true };

[] call DZ_fnc_uiPreviewDestroy;

private _scenePosATL =
[
    worldSize * 0.5,
    worldSize * 0.5,
    2500
];

private _object = createVehicleLocal
[
    _className,
    _scenePosATL,
    [],
    0,
    "CAN_COLLIDE"
];
if (isNull _object) exitWith
{
    diag_log format ["[DZ_UI_PREVIEW] createVehicleLocal failed for %1", _className];
    false
};

_object setPosATL _scenePosATL;
_object setVectorUp [0, 0, 1];
_object setDir ((diag_tickTime * 5) mod 360);
_object allowDamage false;

private _isPerson = _object isKindOf "CAManBase";
if (_isPerson) then
{
    _object disableAI "ALL";
    _object setCaptive true;

    private _animation = if ((primaryWeapon _object) != "") then
    {
        "AmovPercMstpSrasWrflDnon"
    }
    else
    {
        "AmovPercMstpSnonWnonDnon"
    };

    _object switchMove _animation;
    _object playMoveNow _animation;
};

_object enableSimulation false;

private _minimum = [-0.5, -0.5, -0.5];
private _maximum = [0.5, 0.5, 0.5];
if (_isPerson) then
{
    // Character config bounds include the bind-pose arms and weapon
    // proxies. Fixed body-sized bounds keep the camera tightly framed.
    _minimum = [-0.42, -0.32, 0.00];
    _maximum = [0.42, 0.32, 1.88];
}
else
{
    private _bounds = boundingBoxReal _object;
    _minimum = _bounds param [0, _minimum];
    _maximum = _bounds param [1, _maximum];
};

private _span = _maximum vectorDiff _minimum;
private _modelCenter = _minimum vectorAdd (_span vectorMultiply 0.5);
private _targetAGL = _object modelToWorldVisual _modelCenter;
private _radius = ((vectorMagnitude _span) * 0.5) max 0.4;
private _maxDimension = ((abs (_span # 0)) max (abs (_span # 1))) max (abs (_span # 2));
private _distance = if (_isPerson) then
{
    3.15
}
else
{
    (_maxDimension * 1.18) max 1.35
};

private _cameraPosition = _targetAGL vectorAdd
[
    _distance * 0.42,
    -_distance * 0.90,
    -_radius * 0.08
];

private _camera = "camera" camCreate _cameraPosition;
_camera camSetTarget _targetAGL;
_camera camSetFov 0.50;
_camera camCommit 0;
_camera cameraEffect ["Internal", "Back", "dzuipreviewrt"];

private _keyLight = "#lightpoint" createVehicleLocal _cameraPosition;
_keyLight setLightBrightness 5.5;
_keyLight setLightColor [1.00, 0.88, 0.72];
_keyLight setLightAmbient [0.46, 0.50, 0.54];
_keyLight setLightDayLight true;
_keyLight setLightUseFlare false;
_keyLight setLightAttenuation [0, 1, 0, 0, _distance * 2.0, _distance * 2.5];
_keyLight lightAttachObject [_camera, [0, 0, 0]];

private _fillPosition = _targetAGL vectorAdd
[
    -_radius * 1.7,
    _radius * 1.3,
    _radius * 1.4
];
private _fillLight = "#lightpoint" createVehicleLocal _fillPosition;
_fillLight setLightBrightness 2.2;
_fillLight setLightColor [0.42, 0.60, 1.00];
_fillLight setLightAmbient [0.18, 0.24, 0.34];
_fillLight setLightDayLight true;
_fillLight setLightUseFlare false;
_fillLight setLightAttenuation [0, 1, 0, 0, _distance * 2.0, _distance * 2.5];

uiNamespace setVariable ["DZ_uiPreviewObject", _object];
uiNamespace setVariable ["DZ_uiPreviewCamera", _camera];
uiNamespace setVariable ["DZ_uiPreviewLights", [_keyLight, _fillLight]];
uiNamespace setVariable ["DZ_uiPreviewClass", _className];
uiNamespace setVariable ["DZ_uiPreviewKey", _className];

diag_log format
[
    "[DZ_UI_PREVIEW] Live showroom ready: class=%1 person=%2 span=%3 radius=%4 distance=%5",
    _className,
    _isPerson,
    _span,
    _radius,
    _distance
];

true
