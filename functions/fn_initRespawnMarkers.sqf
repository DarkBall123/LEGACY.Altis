if (!isServer) exitWith { false };

private _playerSide = missionNamespace getVariable ["CH_sidePlayers", east];
private _markerBaseName = switch (_playerSide) do
{
    case west: { "respawn_west" };
    case east: { "respawn_east" };
    case resistance: { "respawn_guerrila" };
    case civilian: { "respawn_civilian" };
    default { "respawn" };
};

private _markerColor = switch (_playerSide) do
{
    case west: { "ColorBlue" };
    case east: { "ColorRed" };
    case resistance: { "ColorGreen" };
    case civilian: { "ColorCivilian" };
    default { "ColorWhite" };
};

{
    if (_x isEqualType "" && { _x != "" }) then
    {
        deleteMarker _x;
    };
} forEach (missionNamespace getVariable ["DZ_respawnMarkerNames", []]);

private _rawPoints = +(missionNamespace getVariable ["DZ_respawnPoints", []]);
private _resolvedPoints = [];

{
    private _entry = _x;
    private _label = format ["База %1", _forEachIndex + 1];
    private _position = [];

    if (_entry isEqualType []) then
    {
        if ((count _entry) >= 2 && { (_entry # 0) isEqualType "" } && { (_entry # 1) isEqualType [] }) then
        {
            _label = _entry # 0;
            _position = +(_entry # 1);
        }
        else
        {
            _position = +_entry;
        };
    };

    if (_position isEqualType [] && { (count _position) >= 2 }) then
    {
        _resolvedPoints pushBack
        [
            _label,
            [_position # 0, _position # 1, if ((count _position) > 2) then { _position # 2 } else { 0 }]
        ];
    };
} forEach _rawPoints;

if (_resolvedPoints isEqualTo []) then
{
    private _fallbackUnits = playableUnits select
    {
        !isNull _x && { side group _x == _playerSide }
    };

    if (_fallbackUnits isEqualTo []) then
    {
        _fallbackUnits = allUnits select
        {
            !isNull _x && { side group _x == _playerSide }
        };
    };

    private _fallbackPosition = [worldSize * 0.5, worldSize * 0.5, 0];

    if (_fallbackUnits isNotEqualTo []) then
    {
        _fallbackPosition = getPosATL (_fallbackUnits # 0);
    };

    _resolvedPoints pushBack ["База", _fallbackPosition];
};

private _createdMarkers = [];

{
    _x params ["_label", "_position"];

    private _markerName = if (_forEachIndex == 0) then
    {
        _markerBaseName
    }
    else
    {
        format ["%1_%2", _markerBaseName, _forEachIndex]
    };

    private _marker = createMarker [_markerName, _position];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "mil_start";
    _marker setMarkerColor _markerColor;
    _marker setMarkerText _label;
    _marker setMarkerAlpha 1;

    _createdMarkers pushBack _marker;
} forEach _resolvedPoints;

missionNamespace setVariable ["DZ_respawnMarkerNames", _createdMarkers];
missionNamespace setVariable ["DZ_respawnPointsResolved", _resolvedPoints];

true
