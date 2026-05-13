/*
 * DZ_fnc_missionUI
 *
 * Mission UI dispatcher.
 *
 *     ["create", id, pos, type, label, color]  call DZ_fnc_missionUI;
 *     ["delete", id]                            call DZ_fnc_missionUI;
 *     ["hint",   title, body]                   call DZ_fnc_missionUI;
 *
 * "create" / "delete" are server-side: createMarker is global, so all clients
 * see them. "hint" remoteExec's DZ_fnc_missionShowHint to every client (0).
 */

params ["_action"];

switch (_action) do {

    case "create": {
        if (!isServer) exitWith {};
        params ["_action", "_id", "_pos", "_type", ["_label", ""], ["_color", "ColorRed"]];
        deleteMarker _id;                       // safe even if marker doesn't exist
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
