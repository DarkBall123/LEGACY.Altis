/*
 * DZ_fnc_getUrbanCells
 * Returns a HashMap of {sectorId → true} for every sector flagged as
 * urban.
 *
 * Option B refactor: sectors are now built directly from BIS named
 * locations (`fn_buildSectorGrid.sqf`), so by definition every sector
 * IS urban. This function is kept as a vestigial back-compat hook for
 * any caller that still asks "is this sector urban?" — it returns
 * true for every registered sector.
 */

private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _urban = createHashMap;

{
    _x params ["_sectorId"];
    _urban set [_sectorId, true];
} forEach _sectorGrid;

diag_log format ["[DZ] Urban scan (Option B): every sector is urban by construction (%1 sectors)", count _urban];

_urban
