if (!hasInterface) exitWith {};

if (missionNamespace getVariable ["DZ_clientInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_clientInitDone", true];

[] call DZ_fnc_startAmbientSound;

[
    {
        params ["_args", "_handle"];

        if (!isNull player && { local player }) then
        {
            [_handle] call CBA_fnc_removePerFrameHandler;
            [player] remoteExecCall ["DZ_fnc_requestSavedLoadout", 2];

            [
                {
                    params ["_args", "_handle"];
                    _args params ["_unit", "_runAt"];

                    if (time < _runAt) exitWith {};

                    [_handle] call CBA_fnc_removePerFrameHandler;

                    if !(missionNamespace getVariable ["DZ_originalLoadoutReady", false]) then
                    {
                        [_unit] call DZ_fnc_storeOriginalLoadout;
                    };
                },
                0.2,
                [player, time + 1]
            ] call CBA_fnc_addPerFrameHandler;
        };
    },
    0.2,
    []
] call CBA_fnc_addPerFrameHandler;

addMissionEventHandler
[
    "EntityRespawned",
    {
        params ["_newEntity", "_oldEntity"];

        if (_newEntity isEqualTo player) then
        {
            [_newEntity] call DZ_fnc_applyOriginalLoadout;
        };
    }
];

[
    {
        params ["_args", "_handle"];

        if (
            isNil { missionNamespace getVariable "DZ_sectorGrid" } ||
            { isNil { missionNamespace getVariable "DZ_gridSize" } } ||
            { isNil { missionNamespace getVariable "DZ_sectorStatePayload" } }
        ) exitWith {};

        [_handle] call CBA_fnc_removePerFrameHandler;

        private _sectorGrid = missionNamespace getVariable ["DZ_sectorGrid", []];
        private _gridSize = missionNamespace getVariable ["DZ_gridSize", 350];
        private _halfSize = _gridSize * 0.5;
        private _sectorMarkers = [];

        {
            _x params ["_sectorId", "_centerX", "_centerY"];

            private _markerPos = [_centerX, _centerY, 0];
            private _marker = createMarkerLocal [format ["DZ_zone_%1", _sectorId], _markerPos];

            _marker setMarkerShapeLocal "RECTANGLE";
            _marker setMarkerBrushLocal "DiagGrid";
            _marker setMarkerSizeLocal [_halfSize, _halfSize];
            _marker setMarkerColorLocal "ColorBlue";
            _marker setMarkerAlphaLocal 0;
            _marker setMarkerTextLocal "";

            _sectorMarkers pushBack _marker;
        } forEach _sectorGrid;

        missionNamespace setVariable ["DZ_sectorMarkers", _sectorMarkers];
        missionNamespace setVariable ["DZ_renderedSectorState", []];
        missionNamespace setVariable ["DZ_lastPayloadRevision", -1];

        [missionNamespace getVariable ["DZ_sectorStatePayload", [0, []]]] call DZ_fnc_handleStateUpdate;

        [
            {
                private _payload = missionNamespace getVariable ["DZ_sectorStatePayload", [0, []]];
                private _revision = _payload # 0;
                private _lastRevision = missionNamespace getVariable ["DZ_lastPayloadRevision", -1];

                if (_revision != _lastRevision) then
                {
                    [_payload] call DZ_fnc_handleStateUpdate;
                };
            },
            0.25,
            []
        ] call CBA_fnc_addPerFrameHandler;
    },
    0.25,
    []
] call CBA_fnc_addPerFrameHandler;
