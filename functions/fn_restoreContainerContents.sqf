/*
 * DZ_fnc_restoreContainerContents
 * Re-links auto-marked editor-placed containers (DZ_autoContainerIds,
 * written by fn_requestPersistMark) after a restart and restores their
 * saved inventory through the trophy-crate mechanism.
 *
 * Called once from fn_initServer, right after DZ_fnc_restoreAssets (so
 * recreated dynamic assets are never matched — they lack DZ_edenPlaced).
 * Stale entries (object no longer found at the recorded position, e.g.
 * an Eden vehicle that was driven away) are logged and dropped.
 */

if (!isServer) exitWith { 0 };

private _autoIds = ["DZ_autoContainerIds", []] call DZ_fnc_storeGet;
if !(_autoIds isEqualType []) exitWith { 0 };
if (_autoIds isEqualTo []) exitWith { 0 };

private _restored = 0;
private _kept = [];

{
    private _entry = _x;
    _entry params [["_containerId", "", [""]], ["_posX", 0, [0]], ["_posY", 0, [0]], ["_class", "", [""]]];

    private _obj = objNull;

    if (_containerId != "" && { _class != "" }) then
    {
        private _candidates = nearestObjects [[_posX, _posY, 0], [_class], 3];
        private _idx = _candidates findIf
        {
            (_x getVariable ["DZ_edenPlaced", false]) &&
            { (_x getVariable ["DZ_trophyCrateId", ""]) isEqualTo "" }
        };

        if (_idx >= 0) then
        {
            _obj = _candidates # _idx;
        };
    };

    if (isNull _obj) then
    {
        diag_log format
        [
            "[DZ_ASSETS] Auto-container '%1' (%2) not found near [%3,%4] - dropping stale entry",
            _containerId,
            _class,
            _posX,
            _posY
        ];
        continue;
    };

    _obj setVariable ["DZ_trophyCrateId", _containerId, true];
    _obj setVariable ["DZ_noCleanup", true, true];
    _obj setVariable ["DZ_persist", true, true];
    _obj setVariable ["DZ_persistMode", "contents", true];

    private _registry = missionNamespace getVariable ["DZ_trophyCrateRegistry", []];
    _registry pushBackUnique _obj;
    missionNamespace setVariable ["DZ_trophyCrateRegistry", _registry];

    [_obj, _containerId] call DZ_fnc_restoreTrophyCrateContents;

    _kept pushBack _entry;
    _restored = _restored + 1;
} forEach _autoIds;

["DZ_autoContainerIds", _kept] call DZ_fnc_storeSet;
call DZ_fnc_storeFlush;

diag_log format ["[DZ_ASSETS] Re-linked %1 of %2 auto-container(s).", _restored, count _autoIds];

_restored
