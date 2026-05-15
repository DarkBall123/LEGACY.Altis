/*
 * Alfa/Traffic/Common/Debug.sqf
 * Defines debug marker helpers for Alfa traffic diagnostics.
 */

ENGIMA_TRAFFIC_SilentDebugMode = false;

ENGIMA_TRAFFIC_DebugTextEventArgs = [];
ENGIMA_TRAFFIC_DebugMarkerEventArgs = [];
ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs = [];

"ENGIMA_TRAFFIC_DebugTextEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DebugTextEventArgs call ENGIMA_TRAFFIC_ShowDebugTextLocal;
};

"ENGIMA_TRAFFIC_DebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DebugMarkerEventArgs call ENGIMA_TRAFFIC_SetDebugMarkerLocal;
};

"ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs call ENGIMA_TRAFFIC_DeleteDebugMarkerLocal;
};


ENGIMA_TRAFFIC_ShowDebugTextAllClients = {
    ENGIMA_TRAFFIC_DebugTextEventArgs = _this;
    publicVariable "ENGIMA_TRAFFIC_DebugTextEventArgs";
    ENGIMA_TRAFFIC_DebugTextEventArgs call ENGIMA_TRAFFIC_ShowDebugTextLocal;
};


ENGIMA_TRAFFIC_ShowDebugTextLocal = {
    private ["_minutes", "_seconds"];

    if (!isNull player) then {
        if (!ENGIMA_TRAFFIC_SilentDebugMode) then {
            player sideChat (_this select 0);
        };
    };

    _minutes = floor (time / 60);
    _seconds = floor (time - (_minutes * 60));
    diag_log ((str _minutes + ":" + str _seconds) + " Debug: " + (_this select 0));
};


ENGIMA_TRAFFIC_SetDebugMarkerLocal = {
    private ["_markerName", "_position", "_size", "_direction", "_type", "_shape", "_markerColor", "_markerText"];
    private ["_marker"];

    if (!isNull player) then {
        if (!ENGIMA_TRAFFIC_SilentDebugMode) then {
            _markerName = _this select 0;
            _position = _this select 1;
            _markerColor = "Default";
            _markerText = "";

            if (count _this == 6) then {
                _size = _this select 2;
                _direction = _this select 3;
                _shape = _this select 4;
                _markerColor = _this select 5;
            };
            if (count _this == 7) then {
                _size = _this select 2;
                _direction = _this select 3;
                _shape = _this select 4;
                _markerColor = _this select 5;
                _markerText = _this select 6;
            };
            if (count _this == 3) then {
                _type = _this select 2;
                _shape = "ICON";
            };
            if (count _this == 4) then {
                _type = _this select 2;
                _shape = "ICON";
                _markerColor = _this select 3;
            };
            if (count _this == 5) then {
                _type = _this select 2;
                _shape = "ICON";
                _markerColor = _this select 3;
                _markerText = _this select 4;
            };


            if ([_markerName] call ENGIMA_TRAFFIC_MarkerExists) then {
                deleteMarkerLocal _markerName;
            };


            _marker = createMarkerLocal [_markerName, _position];
            _marker setMarkerShapeLocal _shape;
            _marker setMarkerColorLocal _markerColor;
            _marker setMarkerTextLocal _markerText;

            if (count _this == 6 || count _this == 7) then {
                _marker setMarkerSizeLocal _size;
                _marker setMarkerDirLocal _direction;
            };
            if (count _this == 3 || count _this == 4 || count _this == 5) then {
                _marker setMarkerTypeLocal _type;
            };
        };
    };
};


ENGIMA_TRAFFIC_SetDebugMarkerAllClients = {
    ENGIMA_TRAFFIC_DebugMarkerEventArgs = _this;
    publicVariable "ENGIMA_TRAFFIC_DebugMarkerEventArgs";
    ENGIMA_TRAFFIC_DebugMarkerEventArgs call ENGIMA_TRAFFIC_SetDebugMarkerLocal;
};


ENGIMA_TRAFFIC_DeleteDebugMarkerLocal = {
    private ["_markerName"];
    _markerName = _this select 0;
    deleteMarkerLocal _markerName;
};


ENGIMA_TRAFFIC_DeleteDebugMarkerAllClients = {
    ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs = _this;
    publicVariable "ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs";
    ENGIMA_TRAFFIC_DeleteDebugMarkerEventArgs call ENGIMA_TRAFFIC_DeleteDebugMarkerLocal;
};
