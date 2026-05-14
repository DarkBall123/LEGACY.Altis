/*
 * scripts/missions/fn_missionUI.sqf
 * Legacy mission UI marker and hint helper.
 */

params ["_action"];

switch (_action) do {

    case "create": {
        if (!isServer) exitWith {};
        params ["_action", "_id", "_pos", "_type", ["_label", ""], ["_color", "ColorRed"]];
        deleteMarker _id;
        private _marker = createMarker [_id, _pos];
        _marker setMarkerType  _type;
        _marker setMarkerText  _label;
        _marker setMarkerColor _color;
        _marker setMarkerAlpha 1;
    };

    case "delete": {
        if (!isServer) exitWith {};
        params ["_action", "_id"];
        deleteMarker _id;
    };

    case "hint": {
        params ["_action", "_title", "_body"];
        [_title, _body] remoteExec ["DZ_fnc_missionShowHint", 0, false];
    };
};
