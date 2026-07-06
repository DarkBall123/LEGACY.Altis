/*
 * DZ_fnc_addMissionAssets
 * Registers mission-spawned units, vehicles, markers, and PFH handles
 * for cleanup, attributing them to the side that owns the mission.
 *
 * Side resolution priority:
 *   1. Explicit `_side` parameter (passed by refactored mission scripts).
 *   2. `DZ_missionContextSide` (set by prepareMissionState during
 *      synchronous startup; mission scripts that capture _missionSide
 *      and pass it through PFH args will set it before calling).
 *   3. The single active side, if exactly one is active.
 *   4. No-op + log (we refuse to guess between two concurrent missions).
 */

params [
    ["_unitsToAdd",      [], [[]]],
    ["_vehiclesToAdd",   [], [[]]],
    ["_markersToAdd",    [], [[]]],
    ["_pfhHandlesToAdd", [], [[]]],
    ["_side",            sideUnknown]
];

if (!isServer) exitWith { false };

if (_side isEqualTo sideUnknown) then {
    _side = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
};
if (_side isEqualTo sideUnknown) then {
    private _active = call DZ_fnc_missionActiveSides;
    if ((count _active) == 1) then { _side = _active # 0 };
};

if (_side isEqualTo sideUnknown) exitWith {
    diag_log format ["[DZ_ASSETS] No resolvable side — units=%1 veh=%2 markers=%3 pfh=%4 (call ignored).",
        count _unitsToAdd, count _vehiclesToAdd, count _markersToAdd, count _pfhHandlesToAdd];
    false
};

private _state = [_side] call DZ_fnc_missionStateOf;

private _units      = _state get "units";
private _vehicles   = _state get "vehicles";
private _markers    = _state get "markers";
private _pfhHandles = _state get "pfhHandles";

{
    _units pushBackUnique _x;
} forEach (_unitsToAdd select { !isNull _x });

{
    _vehicles pushBackUnique _x;
} forEach (_vehiclesToAdd select { !isNull _x });

{
    _markers pushBackUnique _x;
} forEach (_markersToAdd select { _x != "" });

{
    _pfhHandles pushBackUnique _x;
} forEach _pfhHandlesToAdd;

_state set ["units",      _units];
_state set ["vehicles",   _vehicles];
_state set ["markers",    _markers];
_state set ["pfhHandles", _pfhHandles];

private _ctx = missionNamespace getVariable ["DZ_missionContextSide", sideUnknown];
if (_ctx isEqualTo sideUnknown || { _ctx isEqualTo _side }) then {
    [_side] call DZ_fnc_missionSyncLegacyGlobals;
};

true
