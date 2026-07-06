/*
 * DZ_fnc_initBaseContainerPersist
 * Auto-registers editor-placed storage containers near player bases so
 * their contents persist across restarts WITHOUT relying on the client
 * InventoryOpened event (which does not reliably reach the server,
 * especially through ACE's inventory interaction).
 *
 * For every container within DZ_baseContainerRadius of a base/respawn
 * point it assigns a stable position-derived id, marks it
 * "contents"-persistent and registers it in DZ_trophyCrateRegistry. The
 * existing periodic saveTrophyCrates loop (and disconnect / manual save)
 * then snapshots the contents; restoreTrophyCrateContents reloads them.
 *
 * Because Eden containers reappear at the same spot every restart, the
 * scan reproduces the same ids and restores into the same boxes — no
 * separate id map is needed. Called once from fn_initServer after
 * DZ_fnc_restoreContainerContents.
 */

if (!isServer) exitWith { 0 };

private _radius = missionNamespace getVariable ["DZ_baseContainerRadius", 300];
private _respawnPoints = missionNamespace getVariable ["DZ_respawnPoints", []];
if (_respawnPoints isEqualTo []) exitWith { 0 };

private _fnc_isContainer =
{
    params ["_obj"];

    if (_obj isKindOf "ReammoBox_F") exitWith { true };
    if (_obj isKindOf "CAManBase" || { _obj isKindOf "AllVehicles" }) exitWith { false };

    private _cfg = configOf _obj;
    (
        (getNumber (_cfg >> "transportMaxWeapons")   > 0) ||
        { getNumber (_cfg >> "transportMaxMagazines") > 0 } ||
        { getNumber (_cfg >> "transportMaxItems")     > 0 } ||
        { getNumber (_cfg >> "transportMaxBackpacks") > 0 } ||
        { getNumber (_cfg >> "maximumLoad")           > 0 }
    )
};

private _registry = missionNamespace getVariable ["DZ_trophyCrateRegistry", []];
private _seen = [];
private _registered = 0;

{
    _x params ["_label", "_pos", "_side"];

    {
        private _obj = _x;

        if (isNull _obj) then { continue };
        if (_obj in _seen) then { continue };
        if ((_obj getVariable ["DZ_trophyCrateId", ""]) != "") then { continue };
        if (!([_obj] call _fnc_isContainer)) then { continue };

        _seen pushBack _obj;

        private _worldPos = getPosWorld _obj;
        private _id = format ["basebox_%1_%2", round (_worldPos # 0), round (_worldPos # 1)];

        _obj setVariable ["DZ_trophyCrateId", _id, true];
        _obj setVariable ["DZ_noCleanup", true, true];
        _obj setVariable ["DZ_persist", true, true];
        _obj setVariable ["DZ_persistMode", "contents", true];

        _registry pushBackUnique _obj;

        [_obj, _id] call DZ_fnc_restoreTrophyCrateContents;

        _registered = _registered + 1;
    } forEach (nearestObjects [_pos, [], _radius]);
} forEach _respawnPoints;

missionNamespace setVariable ["DZ_trophyCrateRegistry", _registry];

if (_registered > 0) then
{
    call DZ_fnc_saveTrophyCrates;
};

diag_log format ["[DZ_ASSETS] Base-container persistence: registered %1 container(s) near %2 base(s).", _registered, count _respawnPoints];

_registered
