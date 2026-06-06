/*
 * DZ_fnc_initTrophyCrate
 * Eden init-field hook for trophy-weapon crates placed at player
 * faction bases. Makes the crate's inventory persist across server
 * restarts via profileNamespace.
 *
 * Eden setup:
 *   - Place a crate (any AmmoBox / EquipBox / Land_*Crate_*)
 *   - Give it a Variable Name in Eden (e.g. "apd_trophy_crate_1")
 *     This is the persistence key — keep it stable across mission edits
 *     or you'll lose the saved contents
 *   - Init field: [this] call DZ_fnc_initTrophyCrate;
 *
 * What it does:
 *   1. Registers the crate in DZ_trophyCrateRegistry (server-side list
 *      so the periodic-save PFH knows what to snapshot)
 *   2. Restores the crate's saved inventory from profileNamespace —
 *      replaces whatever Eden put in the crate by default
 *
 * Falls back to a position-derived ID if no Variable Name is set, but
 * THIS IS FRAGILE — moving the crate even slightly in Eden creates a
 * "new" crate from the persistence layer's point of view. Always set a
 * Variable Name for serious use.
 */

params [["_crate", objNull, [objNull]]];

if (isNull _crate) exitWith { false };
if (!isServer) exitWith { true };

// Resolve persistence ID
private _crateId = vehicleVarName _crate;
if (_crateId == "") then {
    private _pos = getPosWorld _crate;
    _crateId = format ["crate_%1_%2", round (_pos # 0), round (_pos # 1)];
    diag_log format ["[DZ_TROPHY_CRATE] WARNING: %1 has no Variable Name in Eden, using position-derived ID '%2'. Move the crate and you'll lose its contents!",
        _crate, _crateId];
};
_crate setVariable ["DZ_trophyCrateId", _crateId, true];

// Mark it so other persistence systems leave its inventory alone.
// (The DZ_persist flag drives saveAssets / abandoned-vehicle cleanup;
// crates aren't vehicles, but the noCleanup flag is cheap insurance.)
_crate setVariable ["DZ_noCleanup", true, true];

// Register in the global list the save PFH walks.
private _registry = missionNamespace getVariable ["DZ_trophyCrateRegistry", []];
_registry pushBackUnique _crate;
missionNamespace setVariable ["DZ_trophyCrateRegistry", _registry];

// Restore saved contents.
[_crate, _crateId] call DZ_fnc_restoreTrophyCrateContents;

diag_log format ["[DZ_TROPHY_CRATE] Registered '%1' (%2) at %3", _crateId, typeOf _crate, getPosATL _crate];

true
