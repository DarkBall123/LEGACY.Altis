/*
 *  Делит карту на клетки, исключая воду (surfaceIsWater)
 *  Возвращает массив центров _cells[]
 */
private _g    = missionNamespace getVariable ["DZ_gridSize",350];
private _size = worldSize;                                         // :contentReference[oaicite:2]{index=2}
private _cells = [];

for "_ix" from 0 to floor(_size / _g) do {
    for "_iy" from 0 to floor(_size / _g) do {
        private _pos = [(_ix * _g) + _g/2, (_iy * _g) + _g/2, 0];
        if !(surfaceIsWater _pos) then {                           // :contentReference[oaicite:3]{index=3}
            _cells pushBack _pos;
        };
    };
};

diag_log format ["[DZ] Grid ▶ %1 dry‑land cells (gridSize=%2 m)", count _cells, _g];
_cells
