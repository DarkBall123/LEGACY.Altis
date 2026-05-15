/*
 * DZ_fnc_radioControl
 * Server-authoritative radio state controller for play, stop, next, and auto-advance.
 */

if (!isServer) exitWith {};

params [
    ["_radio",  objNull, [objNull]],
    ["_action", "",      [""]]
];

if (isNull _radio) exitWith {};

private _tracks = missionNamespace getVariable ["DZ_RadioTracks", []];
if (_tracks isEqualTo []) exitWith
{
    diag_log "[RADIO] DZ_RadioTracks not defined. Set it in initServer.sqf.";
};


DZ_fnc_radioControl_playTrack =
{
    params ["_radio", "_trackIdx", "_session"];

    if (isNull _radio) exitWith {};
    if ((_radio getVariable ["radio_session", 0]) != _session) exitWith {};
    if !(_radio getVariable ["radio_playing", false]) exitWith {};

    private _tracks = missionNamespace getVariable ["DZ_RadioTracks", []];
    if (_tracks isEqualTo []) exitWith {};
    if (_trackIdx >= count _tracks) exitWith {};

    private _trackData = _tracks # _trackIdx;
    _trackData params ["_path", "_title", "_duration"];


    [_radio, _path, _title] remoteExecCall ["DZ_fnc_radioPlayLocal", 0];


    [
        {
            params ["_radio", "_session"];
            if (isNull _radio) exitWith {};
            if ((_radio getVariable ["radio_session", 0]) != _session) exitWith {};
            if !(_radio getVariable ["radio_playing", false]) exitWith {};

            private _tracks = missionNamespace getVariable ["DZ_RadioTracks", []];
            if (_tracks isEqualTo []) exitWith {};

            private _next = ((_radio getVariable ["radio_track", 0]) + 1) mod (count _tracks);


            private _newSession = (_radio getVariable ["radio_session", 0]) + 1;
            _radio setVariable ["radio_session", _newSession, true];
            _radio setVariable ["radio_track",   _next,       true];

            [_radio, _next, _newSession] call DZ_fnc_radioControl_playTrack;
        },
        [_radio, _session],
        _duration + 1
    ] call CBA_fnc_waitAndExecute;
};


private _session = (_radio getVariable ["radio_session", 0]) + 1;
_radio setVariable ["radio_session", _session, true];

switch (_action) do
{
    case "play":
    {
        if (_radio getVariable ["radio_playing", false]) exitWith {};

        private _trackIdx = _radio getVariable ["radio_track", 0];
        if (_trackIdx >= count _tracks) then { _trackIdx = 0; };

        _radio setVariable ["radio_playing", true, true];
        _radio setVariable ["radio_track", _trackIdx, true];

        [_radio, _trackIdx, _session] call DZ_fnc_radioControl_playTrack;
    };

    case "stop":
    {
        _radio setVariable ["radio_playing", false, true];

    };

    case "next":
    {
        if !(_radio getVariable ["radio_playing", false]) exitWith {};

        private _trackIdx = ((_radio getVariable ["radio_track", 0]) + 1) mod (count _tracks);
        _radio setVariable ["radio_track", _trackIdx, true];

        [_radio, _trackIdx, _session] call DZ_fnc_radioControl_playTrack;
    };
};
