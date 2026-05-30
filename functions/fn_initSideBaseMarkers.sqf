/*
 * DZ_fnc_initSideBaseMarkers
 * Locally hides opposing faction base/service markers without editing mission.sqm.
 */

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["DZ_sideBaseMarkersInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_sideBaseMarkersInitialized", true];

missionNamespace setVariable ["DZ_sideBaseMarkersAPD", missionNamespace getVariable [
    "DZ_sideBaseMarkersAPD",
    ["marker_10", "marker_11", "marker_12", "marker_13", "respawn_west"]
]];

missionNamespace setVariable ["DZ_sideBaseMarkersFreeAltis", missionNamespace getVariable [
    "DZ_sideBaseMarkersFreeAltis",
    ["marker_6", "marker_7", "marker_8", "marker_9", "respawn_guerilla", "respawn_guerrila"]
]];

DZ_fnc_applySideBaseMarkerVisibility = {
    private _apdMarkers = missionNamespace getVariable ["DZ_sideBaseMarkersAPD", []];
    private _freeMarkers = missionNamespace getVariable ["DZ_sideBaseMarkersFreeAltis", []];
    private _allMarkers = _apdMarkers + _freeMarkers;
    private _visibleMarkers = switch (side player) do {
        case west: { _apdMarkers };
        case resistance: { _freeMarkers };
        default { _allMarkers };
    };

    {
        if (getMarkerType _x != "") then {
            _x setMarkerAlphaLocal ([0, 1] select (_x in _visibleMarkers));
        };
    } forEach _allMarkers;
};

call DZ_fnc_applySideBaseMarkerVisibility;

[
    {
        call DZ_fnc_applySideBaseMarkerVisibility;
    },
    10,
    []
] call CBA_fnc_addPerFrameHandler;

true
