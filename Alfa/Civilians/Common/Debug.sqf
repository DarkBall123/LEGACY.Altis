/*
 * Alfa/Civilians/Common/Debug.sqf
 * Defines debug marker helpers for Alfa civilian diagnostics.
 */

ENGIMA_CIVILIANS_SilentDebugMode = false;

ENGIMA_CIVILIANS_DebugTextEventArgs = [];
ENGIMA_CIVILIANS_DebugMarkerEventArgs = [];
ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs = [];

"ENGIMA_CIVILIANS_DebugTextEventArgs" addPublicVariableEventHandler {
    ENGIMA_CIVILIANS_DebugTextEventArgs call ENGIMA_CIVILIANS_ShowDebugTextLocal;
};

"ENGIMA_CIVILIANS_DebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_CIVILIANS_DebugMarkerEventArgs call ENGIMA_CIVILIANS_SetDebugMarkerLocal;
};

"ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs" addPublicVariableEventHandler {
    ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs call ENGIMA_CIVILIANS_DeleteDebugMarkerLocal;
};

ENGIMA_CIVILIANS_MarkerExists = {
	private ["_exists", "_marker"];

	_marker = _this select 0;

	_exists = false;
	if (((getMarkerPos _marker) select 0) != 0 || ((getMarkerPos _marker) select 1 != 0)) then {
		_exists = true;
	};
	_exists
};

ENGIMA_CIVILIANS_ShowDebugTextAllClients = {
    ENGIMA_CIVILIANS_DebugTextEventArgs = _this;
    publicVariable "ENGIMA_CIVILIANS_DebugTextEventArgs";
    ENGIMA_CIVILIANS_DebugTextEventArgs call ENGIMA_CIVILIANS_ShowDebugTextLocal;
};

ENGIMA_CIVILIANS_ShowDebugTextLocal = {
    private ["_minutes", "_seconds"];

    if (!isNull player) then {
        if (!ENGIMA_CIVILIANS_SilentDebugMode) then {
            player sideChat (_this select 0);
        };
    };

    _minutes = floor (time / 60);
    _seconds = floor (time - (_minutes * 60));
    diag_log ((str _minutes + ":" + str _seconds) + " Debug: " + (_this select 0));
};

ENGIMA_CIVILIANS_SetDebugMarkerLocal = {
    private ["_markerName", "_position", "_size", "_direction", "_type", "_shape", "_markerColor", "_markerText"];
    private ["_marker"];

    if (!isNull player) then {
        if (!ENGIMA_CIVILIANS_SilentDebugMode) then {
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

            if ([_markerName] call ENGIMA_CIVILIANS_MarkerExists) then {
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

ENGIMA_CIVILIANS_SetDebugMarkerAllClients = {
    ENGIMA_CIVILIANS_DebugMarkerEventArgs = _this;
    publicVariable "ENGIMA_CIVILIANS_DebugMarkerEventArgs";
    ENGIMA_CIVILIANS_DebugMarkerEventArgs call ENGIMA_CIVILIANS_SetDebugMarkerLocal;
};

ENGIMA_CIVILIANS_DeleteDebugMarkerLocal = {
    private ["_markerName"];
    _markerName = _this select 0;
    deleteMarkerLocal _markerName;
};

ENGIMA_CIVILIANS_DeleteDebugMarkerAllClients = {
    ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs = _this;
    publicVariable "ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs";
    ENGIMA_CIVILIANS_DeleteDebugMarkerEventArgs call ENGIMA_CIVILIANS_DeleteDebugMarkerLocal;
};
