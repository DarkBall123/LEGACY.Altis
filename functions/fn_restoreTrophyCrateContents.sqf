/*
 * DZ_fnc_restoreTrophyCrateContents
 * Replaces a trophy crate's Eden default cargo with the snapshot saved
 * to profileNamespace by fn_saveTrophyCrates. Called from
 * fn_initTrophyCrate on each crate's first init.
 *
 * The snapshot format is the tuple of (getWeaponCargo, getMagazineCargo,
 * getItemCargo, getBackpackCargo) — each of which is a [[classes], [counts]]
 * pair compatible with addXCargoGlobal.
 *
 * If no snapshot exists (e.g. first server boot, or you just added the
 * crate in Eden), the crate keeps whatever Eden put in it. Good
 * default — lets you seed starter loot in Eden.
 */

if (!isServer) exitWith { false };

params [
    ["_crate",   objNull, [objNull]],
    ["_crateId", "",      [""]]
];

if (isNull _crate || { _crateId == "" }) exitWith { false };

private _snapshot = [format ["DZ_trophyCrate_%1", _crateId], []] call DZ_fnc_storeGet;
if (_snapshot isEqualTo []) exitWith {
    diag_log format ["[DZ_TROPHY_CRATE] '%1' first run — keeping Eden default cargo.", _crateId];
    false
};

_snapshot params [
    ["_weaponData",   [[],[]]],
    ["_magazineData", [[],[]]],
    ["_itemData",     [[],[]]],
    ["_backpackData", [[],[]]]
];

// Wipe Eden default cargo before restoring.
clearWeaponCargoGlobal   _crate;
clearMagazineCargoGlobal _crate;
clearItemCargoGlobal     _crate;
clearBackpackCargoGlobal _crate;

// getXCargo returns [[classes], [counts]] — addXCargoGlobal wants [class, count].
private _fnc_restorePair = {
    params ["_crateRef", "_pairs", "_addCmd"];
    _pairs params [["_classes", []], ["_counts", []]];

    private _count = _classes findIf { !(_x isEqualType "") };
    if (_count >= 0) exitWith {};

    {
        private _class = _x;
        private _n     = _counts param [_forEachIndex, 0];
        if (_n <= 0 || { _class == "" }) then { continue };

        // Use a switch to call the right command (no first-class commands in SQF).
        switch (_addCmd) do {
            case "weapon"  : { _crateRef addWeaponCargoGlobal   [_class, _n] };
            case "magazine": { _crateRef addMagazineCargoGlobal [_class, _n] };
            case "item"    : { _crateRef addItemCargoGlobal     [_class, _n] };
            case "backpack": { _crateRef addBackpackCargoGlobal [_class, _n] };
        };
    } forEach _classes;
};

[_crate, _weaponData,   "weapon"]   call _fnc_restorePair;
[_crate, _magazineData, "magazine"] call _fnc_restorePair;
[_crate, _itemData,     "item"]     call _fnc_restorePair;
[_crate, _backpackData, "backpack"] call _fnc_restorePair;

diag_log format ["[DZ_TROPHY_CRATE] '%1' restored: %2 weapon classes, %3 mag classes, %4 item classes, %5 backpack classes",
    _crateId,
    count (_weaponData   param [0, []]),
    count (_magazineData param [0, []]),
    count (_itemData     param [0, []]),
    count (_backpackData param [0, []])];

true
