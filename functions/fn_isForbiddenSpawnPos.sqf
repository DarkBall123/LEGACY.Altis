params [["_pos", []]];

if !(_pos isEqualType []) exitWith { false };
if ((count _pos) < 2) exitWith { false };

private _areas = missionNamespace getVariable ["DZ_forbiddenSpawnAreas", []];
private _inside = false;

{
    if (!isNull _x && { _pos inArea _x }) exitWith
    {
        _inside = true;
    };
} forEach _areas;

_inside
