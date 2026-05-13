params
[
    ["_sectorId", -1],
    ["_styleId", -1]
];

if (_sectorId < 0) exitWith {};

private _sectorMarkers = missionNamespace getVariable ["DZ_sectorMarkers", []];
private _marker = _sectorMarkers param [_sectorId, ""];

if (_marker isEqualTo "") exitWith {};

private _renderConfig = switch (_styleId) do
{
    case 0: { ["ColorBlue", "DiagGrid", 0.18] };
    case 1: { ["ColorBlue", "FDiagonal", 0.46] };
    case 2: { ["ColorRed", "DiagGrid", 0.28] };
    case 3: { ["ColorOrange", "Cross", 0.58] };
    default { ["ColorBlue", "DiagGrid", 0.18] };
};

_renderConfig params ["_color", "_brush", "_alpha"];

_marker setMarkerBrushLocal _brush;
_marker setMarkerColorLocal _color;
_marker setMarkerAlphaLocal _alpha;
