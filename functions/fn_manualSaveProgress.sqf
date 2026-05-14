/*
 * DZ_fnc_manualSaveProgress
 * Persists captured sector progress and notifies the caller.
 */

if (!isServer) exitWith { false };

private _savedCaptures = [];
private _zoneData = missionNamespace getVariable ["DZ_zoneData", []];
private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
private _sectorCount = count _sectorGrid;

if (_sectorCount > 0 && { _zoneData isEqualType [] } && { (count _zoneData) >= _sectorCount }) then
{
    for "_idx" from 0 to (_sectorCount - 1) do
    {
        private _state = _zoneData param [_idx, []];

        if (_state isEqualType [] && { (_state param [4, false]) isEqualTo true }) then
        {
            _savedCaptures pushBack _idx;
        };
    };
}
else
{
    _savedCaptures = missionNamespace getVariable ["DZ_savedCapturesCache", profileNamespace getVariable ["DZ_savedCaptures", []]];
};

if !(_savedCaptures isEqualType []) then
{
    _savedCaptures = [];
};

_savedCaptures = _savedCaptures select { _x isEqualType 0 };
_savedCaptures = _savedCaptures arrayIntersect _savedCaptures;

profileNamespace setVariable ["DZ_savedCaptures", _savedCaptures];
missionNamespace setVariable ["DZ_savedCapturesCache", _savedCaptures];

{
    [_x] call DZ_fnc_savePlayerLoadout;
} forEach (allPlayers select { !isNull _x && { isPlayer _x } && { alive _x } });

private _loadoutsSaved = call DZ_fnc_flushSavedLoadouts;
saveProfileNamespace;

diag_log format ["[DZ] Manual save completed: captures=%1 loadoutsSaved=%2", count _savedCaptures, _loadoutsSaved];

true
