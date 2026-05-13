params [["_payload", [0, []]]];

_payload params
[
    ["_revision", 0],
    ["_sectorState", []]
];

private _lastRevision = missionNamespace getVariable ["DZ_lastPayloadRevision", -1];

if (_revision == _lastRevision) exitWith {};

private _renderedSectorState = missionNamespace getVariable ["DZ_renderedSectorState", []];

{
    private _currentState = if (_forEachIndex < count _renderedSectorState) then
    {
        _renderedSectorState # _forEachIndex
    }
    else
    {
        -1
    };

    if !(_x isEqualTo _currentState) then
    {
        [_forEachIndex, _x] call DZ_fnc_renderSectorState;
        _renderedSectorState set [_forEachIndex, _x];
    };
} forEach _sectorState;

missionNamespace setVariable ["DZ_renderedSectorState", _renderedSectorState];
missionNamespace setVariable ["DZ_lastPayloadRevision", _revision];
