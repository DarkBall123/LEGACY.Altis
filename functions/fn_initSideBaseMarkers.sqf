/*
 * DZ_fnc_initSideBaseMarkers
 * Locally hides opposing faction base/service markers without editing mission.sqm.
 */

if (!hasInterface) exitWith { false };
if (missionNamespace getVariable ["DZ_sideBaseMarkersInitialized", false]) exitWith { true };
missionNamespace setVariable ["DZ_sideBaseMarkersInitialized", true];

missionNamespace setVariable ["DZ_sideBaseMarkersAPD", missionNamespace getVariable [
    "DZ_sideBaseMarkersAPD",
    ["marker_10", "marker_11", "marker_12", "marker_13"]
]];

missionNamespace setVariable ["DZ_sideBaseMarkersFreeAltis", missionNamespace getVariable [
    "DZ_sideBaseMarkersFreeAltis",
    ["marker_6", "marker_7", "marker_8", "marker_9"]
]];

missionNamespace setVariable ["DZ_hiddenRespawnMapMarkers", missionNamespace getVariable [
    "DZ_hiddenRespawnMapMarkers",
    ["respawn_west", "respawn_guerilla", "respawn_guerrila"]
]];

DZ_fnc_applySideBaseMarkerVisibility = {
    private _apdMarkers = missionNamespace getVariable ["DZ_sideBaseMarkersAPD", []];
    private _freeMarkers = missionNamespace getVariable ["DZ_sideBaseMarkersFreeAltis", []];
    private _respawnMarkers = missionNamespace getVariable ["DZ_hiddenRespawnMapMarkers", []];
    private _allMarkers = (_apdMarkers + _freeMarkers + _respawnMarkers) arrayIntersect (_apdMarkers + _freeMarkers + _respawnMarkers);
    private _visibleMarkers = switch (side player) do {
        case west: { _apdMarkers };
        case resistance: { _freeMarkers };
        default { _allMarkers };
    };

    {
        if (getMarkerType _x != "") then {
            private _alpha = if (_x in _respawnMarkers) then { 0 } else { [0, 1] select (_x in _visibleMarkers) };
            _x setMarkerAlphaLocal _alpha;
        };
    } forEach _allMarkers;
};

DZ_fnc_forceSideBaseMarkerVisibilityRefresh = {
    params [["_duration", 8], ["_interval", 0.2]];

    call DZ_fnc_applySideBaseMarkerVisibility;

    private _oldHandle = missionNamespace getVariable ["DZ_sideBaseMarkerBurstHandle", -1];
    if !(_oldHandle isEqualTo -1) then {
        [_oldHandle] call CBA_fnc_removePerFrameHandler;
    };

    private _runUntil = time + _duration;
    private _handle = [
        {
            params ["_args", "_handle"];
            _args params ["_runUntil"];

            call DZ_fnc_applySideBaseMarkerVisibility;

            if (time >= _runUntil) then {
                [_handle] call CBA_fnc_removePerFrameHandler;

                if ((missionNamespace getVariable ["DZ_sideBaseMarkerBurstHandle", -1]) isEqualTo _handle) then {
                    missionNamespace setVariable ["DZ_sideBaseMarkerBurstHandle", -1];
                };
            };
        },
        _interval,
        [_runUntil]
    ] call CBA_fnc_addPerFrameHandler;

    missionNamespace setVariable ["DZ_sideBaseMarkerBurstHandle", _handle];
};

[8, 0.2] call DZ_fnc_forceSideBaseMarkerVisibilityRefresh;

[
    {
        call DZ_fnc_applySideBaseMarkerVisibility;
    },
    10,
    []
] call CBA_fnc_addPerFrameHandler;

addMissionEventHandler
[
    "EntityKilled",
    {
        params ["_killed"];

        if (_killed isEqualTo player) then {
            [12, 0.2] call DZ_fnc_forceSideBaseMarkerVisibilityRefresh;
        };
    }
];

addMissionEventHandler
[
    "EntityRespawned",
    {
        params ["_newEntity"];

        if (_newEntity isEqualTo player) then {
            [6, 0.2] call DZ_fnc_forceSideBaseMarkerVisibilityRefresh;
        };
    }
];

true
