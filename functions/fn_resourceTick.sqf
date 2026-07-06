/*
 * DZ_fnc_resourceTick
 * One pass of the resource node payout. Called by the tick PFH in
 * fn_initResourceNodes.sqf every DZ_resourceTickInterval seconds.
 *
 * For each node:
 *   - resolve current sector owner via DZ_sectorOwner
 *   - if owner is a player side (west / resistance), credit their
 *     wallet via DZ_fnc_squadFundsAdjust and emit a side-message
 *   - if owner is MEF (east) / contested / unowned → no payout
 *
 * Also accumulates per-side totals into a single side message
 * ("APD добыли 760₽ с 3 точек ресурсов: Athanos, Selakano, Pyrgos.")
 * so players see one consolidated summary, not seven separate hints.
 */

if (!isServer) exitWith { false };

private _nodeIds        = missionNamespace getVariable ["DZ_resourceNodeIds", []];
private _nodeNames      = missionNamespace getVariable ["DZ_resourceNodeNames", []];
private _nodeIncome     = missionNamespace getVariable ["DZ_resourceNodeIncomeList", []];
private _nodeSectorIds  = missionNamespace getVariable ["DZ_resourceNodeSectorIds", []];
private _sectorOwner    = missionNamespace getVariable ["DZ_sectorOwner", []];
private _playerSides    = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _tickInterval   = missionNamespace getVariable ["DZ_resourceTickInterval", 1800];

if (_nodeIds isEqualTo []) exitWith { false };

private _sideTotals = createHashMap;

{
    private _idx       = _forEachIndex;
    private _sectorId  = _nodeSectorIds param [_idx, -1];
    if (_sectorId < 0) then { continue };

    private _owner = _sectorOwner param [_sectorId, sideUnknown];
    if !(_owner in _playerSides) then { continue };

    private _income   = _nodeIncome param [_idx, 0];
    if (_income <= 0) then { continue };

    private _nodeName = _nodeNames param [_idx, "?"];

    private _newBalance = [_income, format ["Resource income: %1", _nodeName], _owner] call DZ_fnc_squadFundsAdjust;

    private _key = str _owner;
    private _bucket = _sideTotals getOrDefault [_key, [0, []]];
    _bucket params ["_runningTotal", "_runningNames"];
    _runningTotal = _runningTotal + _income;
    _runningNames pushBack _nodeName;
    _sideTotals set [_key, [_runningTotal, _runningNames]];

    diag_log format ["[DZ_RES] Tick: %1 paid %2₽ to %3 (new balance: %4)",
        _nodeName, _income, _owner, _newBalance];
} forEach _nodeIds;

private _minsToNext = floor (_tickInterval / 60);
{
    private _sideKey = _x;
    private _data    = _y;
    _data params ["_total", "_names"];

    private _side = switch (_sideKey) do {
        case "EAST": { east };
        default { sideUnknown };
    };

    if (_side isEqualTo sideUnknown) then { continue };

    private _factionLabel = switch (true) do {
        case (_side isEqualTo east):       { "APD" };
        default { str _side };
    };

    private _msg = format
    [
        "[%1] Доход с ресурсных точек: +%2₽ (%3). Следующий через ~%4 мин.",
        _factionLabel,
        _total,
        _names joinString ", ",
        _minsToNext
    ];

    [_msg, _side] remoteExecCall ["DZ_fnc_sideMessage", 0];
    diag_log format ["[DZ_RES] %1", _msg];
} forEach _sideTotals;

if (_sideTotals isEqualTo createHashMap || { count _sideTotals == 0 }) then {
    diag_log "[DZ_RES] Tick: no nodes paid (all MEF or unowned).";
};

true
