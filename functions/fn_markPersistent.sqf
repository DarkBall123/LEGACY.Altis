/*
 * DZ_fnc_markPersistent
 * Generic entry point for making an object persistent across restarts.
 *
 * Usage: [_obj] call DZ_fnc_markPersistent;            // mode "recreate"
 *        [_obj, "contents"] call DZ_fnc_markPersistent;
 *
 * Modes:
 *   "recreate" — dynamic object (vehicle, crate, tent, fortification):
 *                fn_saveAssets snapshots class/position/damage/cargo and
 *                fn_restoreAssets recreates it after a restart.
 *   "contents" — editor-placed object that exists again at mission start:
 *                only its inventory is saved/restored (trophy-crate
 *                mechanism); it must never be snapshotted for recreation
 *                or the restart would duplicate it.
 *
 * Registered objects live in missionNamespace DZ_persistRegistry, the
 * primary scan source for fn_saveAssets (covers ammo boxes and statics
 * that the `vehicles` command does not return). Capped by
 * DZ_persistMaxAssets so auto-marking cannot grow the snapshot without
 * bound.
 */

params [["_obj", objNull, [objNull]], ["_mode", "recreate", [""]]];

if (!isServer) exitWith { false };
if (isNull _obj) exitWith { false };

private _registry = missionNamespace getVariable ["DZ_persistRegistry", []];

if !(_obj in _registry) then
{
    private _maxAssets = missionNamespace getVariable ["DZ_persistMaxAssets", 400];

    if ((count _registry) >= _maxAssets) exitWith
    {
        diag_log format
        [
            "[DZ_ASSETS] Persist registry cap (%1) reached - refusing to mark %2",
            _maxAssets,
            typeOf _obj
        ];
    };

    _registry pushBack _obj;
    missionNamespace setVariable ["DZ_persistRegistry", _registry];
};

// Cap refusal above leaves the object unregistered — do not flag it
// either, or the legacy `vehicles` scan in fn_saveAssets would still
// snapshot it past the cap.
if !(_obj in _registry) exitWith { false };

if !(_obj getVariable ["DZ_persist", false] && { (_obj getVariable ["DZ_persistMode", ""]) isEqualTo _mode }) then
{
    _obj setVariable ["DZ_persist", true, true];
    _obj setVariable ["DZ_persistMode", _mode, true];
    missionNamespace setVariable ["DZ_assetsDirty", true];
};

true
