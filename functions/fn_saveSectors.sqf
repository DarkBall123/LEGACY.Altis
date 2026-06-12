/*
 * DZ_fnc_saveSectors
 * Single choke point for persisting captured-sector state.
 * Reads the missionNamespace caches, sanitizes them and writes them to
 * persistent storage together with a save timestamp.
 *
 * Called by:
 *   - fn_handleZonesPFH end-of-tick when DZ_capturesDirty is set
 *   - periodic sector-save loop in fn_initServer (DZ_sectorSaveInterval)
 *   - HandleDisconnect event in fn_initServer
 *   - fn_manualSaveProgress
 */

if (!isServer) exitWith { false };

private _savedCaptures = missionNamespace getVariable ["DZ_savedCapturesCache", []];
private _savedOwners = missionNamespace getVariable ["DZ_savedSectorOwners", []];

if !(_savedCaptures isEqualType []) then
{
    _savedCaptures = [];
};

_savedCaptures = _savedCaptures select { _x isEqualType 0 };
_savedCaptures = _savedCaptures arrayIntersect _savedCaptures;

if !(_savedOwners isEqualType []) then
{
    _savedOwners = [];
};

_savedOwners = _savedOwners select
{
    (_x isEqualType []) &&
    { (_x param [0, -1]) isEqualType 0 } &&
    { (_x param [1, ""]) isEqualType "" }
};

private _savedAt = str systemTimeUTC;

["DZ_savedCaptures", _savedCaptures] call DZ_fnc_storeSet;
["DZ_savedSectorOwners", _savedOwners] call DZ_fnc_storeSet;
["DZ_sectorsSavedAt", _savedAt] call DZ_fnc_storeSet;
call DZ_fnc_storeFlush;

missionNamespace setVariable ["DZ_capturesDirty", false];

diag_log format
[
    "[DZ_SECTORS] Saved %1 captures, %2 owners, savedAt=%3",
    count _savedCaptures,
    count _savedOwners,
    _savedAt
];

true
