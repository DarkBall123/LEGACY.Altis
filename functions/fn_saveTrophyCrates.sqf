/*
 * DZ_fnc_saveTrophyCrates
 * Snapshots every registered trophy crate's full top-level cargo
 * (weapons, magazines, items, backpacks) to profileNamespace.
 *
 * Called by:
 *   - Periodic PFH (every DZ_trophyCrateSaveInterval seconds, default 300)
 *   - HandleDisconnect event (catches state from a player who just
 *     dropped trophies before leaving)
 *   - Admin "save now" hook if you want, via fn_manualSaveProgress
 *
 * Known limitation: this saves TOP-LEVEL cargo only. If a player puts
 * a backpack into the crate that contains weapons, those nested items
 * are NOT recursively saved — Arma's getWeaponCargo/getItemCargo/etc.
 * return only the immediate contents of the container. Players who
 * want to preserve backpack-internal kit should empty the backpack
 * into the crate first.
 */

if (!isServer) exitWith { false };

private _registry = missionNamespace getVariable ["DZ_trophyCrateRegistry", []];
if (_registry isEqualTo []) exitWith { false };

private _saved      = 0;
private _orphaned   = 0;
private _kept       = [];

{
    private _crate = _x;
    if (isNull _crate) then {
        _orphaned = _orphaned + 1;
        continue;
    };

    private _crateId = _crate getVariable ["DZ_trophyCrateId", ""];
    if (_crateId == "") then {
        _orphaned = _orphaned + 1;
        continue;
    };

    // Snapshot in the [class, count] pair format that addXCargoGlobal expects.
    private _snapshot = [
        getWeaponCargo   _crate,
        getMagazineCargo _crate,
        getItemCargo     _crate,
        getBackpackCargo _crate
    ];

    profileNamespace setVariable [format ["DZ_trophyCrate_%1", _crateId], _snapshot];

    _kept pushBack _crate;
    _saved = _saved + 1;
} forEach _registry;

missionNamespace setVariable ["DZ_trophyCrateRegistry", _kept];

if (_saved > 0) then {
    saveProfileNamespace;
};

diag_log format ["[DZ_TROPHY_CRATE] Save pass: %1 crates saved, %2 orphaned (deregistered).", _saved, _orphaned];

true
