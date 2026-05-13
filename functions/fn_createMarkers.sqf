/*
 *  Строит маркеры‑соты, выводит их цвет в журнал
 *  params: [_cells, _urbanHash]
 */
params ["_cells","_urbanHash"];
private _g=missionNamespace getVariable["DZ_gridSize",350];
private _alpha=missionNamespace getVariable["DZ_alpha",0.35];
private _half=_g/2;
{
    private _idx=_forEachIndex;
    private _m=format["DZ_zone_%1",_idx];
    _m=createMarker[_m,_x];
    _m setMarkerShape"RECTANGLE";_m setMarkerBrush"DiagGrid";_m setMarkerSize[_half,_half];
    private _clr=if(_idx in _urbanHash)then{"ColorBlue"}else{"ColorGrey"};
    _m setMarkerColor _clr;_m setMarkerAlpha _alpha;publicVariable _m;
    diag_log format["[DZ] ▸ %1 %2 %3",_m,_clr,_x];
}forEach _cells;
