/*
 * DZ_fnc_manualSaveProgress
 * Persists captured sectors, player loadouts and asset snapshots.
 */

if (!isServer) exitWith { false };

private _savedCaptures = [];
private _savedOwners = [];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _sectorOwner = missionNamespace getVariable ["DZ_sectorOwner", []];
private _sideEnemy = missionNamespace getVariable ["CH_sideEnemy", east];
private _sectorCount = count _sectorGrid;

private _fnc_sideToKey =
{
    params ["_side"];

    switch (true) do
    {
        case (_side isEqualTo west):       { "WEST" };
        case (_side isEqualTo east):       { "EAST" };
        case (_side isEqualTo resistance): { "GUER" };
        default { "" };
    }
};

if (_sectorCount > 0 && { _zoneData isEqualType [] } && { (count _zoneData) >= _sectorCount }) then
{
    for "_idx" from 0 to (_sectorCount - 1) do
    {
        private _state = _zoneData param [_idx, []];

        if (_state isEqualType [] && { (_state param [4, false]) isEqualTo true }) then
        {
            _savedCaptures pushBack _idx;

            private _ownerSide = _sectorOwner param [_idx, west];
            private _ownerKey = [_ownerSide] call _fnc_sideToKey;
            if (_ownerKey != "" && { !(_ownerSide isEqualTo _sideEnemy) }) then
            {
                _savedOwners pushBack [_idx, _ownerKey];
            };
        };
    };
}
else
{
    _savedCaptures = missionNamespace getVariable ["DZ_savedCapturesCache", ["DZ_savedCaptures", []] call DZ_fnc_storeGet];
    _savedOwners = missionNamespace getVariable ["DZ_savedSectorOwners", ["DZ_savedSectorOwners", []] call DZ_fnc_storeGet];
};

missionNamespace setVariable ["DZ_savedCapturesCache", _savedCaptures];
missionNamespace setVariable ["DZ_savedSectorOwners", _savedOwners];

// Sanitizes the caches set above and persists them with a timestamp.
call DZ_fnc_saveSectors;

{
    [_x] call DZ_fnc_savePlayerLoadout;
} forEach (allPlayers select { !isNull _x && { isPlayer _x } && { alive _x } });

private _loadoutsSaved = call DZ_fnc_flushSavedLoadouts;

private _assetsSaved = [true] call DZ_fnc_saveAssets;
call DZ_fnc_saveTrophyCrates;

call DZ_fnc_storeFlush;

diag_log format ["[DZ] Manual save completed: captures=%1 loadoutsSaved=%2 assetsSaved=%3", count (missionNamespace getVariable ["DZ_savedCapturesCache", []]), _loadoutsSaved, _assetsSaved];

true
