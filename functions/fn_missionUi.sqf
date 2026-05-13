params [["_action", "", [""]]];

switch (_action) do
{
    case "create":
    {
        params ["_action", "_id", "_pos", "_type", "_label"];
        if (!isServer) exitWith {};

        deleteMarker _id;

        private _marker = createMarker [_id, _pos];
        _marker setMarkerType _type;
        _marker setMarkerText _label;
        _marker setMarkerColor "ColorRed";
        _marker setMarkerAlpha 1;
    };

    case "delete":
    {
        params ["_action", "_id"];
        if (!isServer) exitWith {};

        deleteMarker _id;
    };

    case "hint":
    {
        params ["_action", "_title", "_body"];

        [_title, _body] remoteExecCall ["DZ_fnc_showHint", 0];
    };
};
