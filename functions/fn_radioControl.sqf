/*
 * DZ_fnc_radioControl
 *
 * Server-side authoritative radio controller.
 *
 *     [_radio, "play"] remoteExecCall ["DZ_fnc_radioControl", 2];
 *     [_radio, "stop"] remoteExecCall ["DZ_fnc_radioControl", 2];
 *     [_radio, "next"] remoteExecCall ["DZ_fnc_radioControl", 2];
 *
 * State per-radio (variables on the object, public so clients can read
 * them in ACE action conditions):
 *   radio_playing   — bool
 *   radio_track     — int, index into DZ_RadioTracks
 *   radio_session   — int, incremented on every state change. Used by
 *                     the chained "next track" callback to detect that
 *                     it's been superseded (player hit Stop, or skipped)
 *                     and bail without firing.
 *
 * Tracks come from DZ_RadioTracks, set in initServer.sqf:
 *     DZ_RadioTracks = [
 *         ["sound\ZOV_1.ogg", "Z", 180],
 *         ...
 *     ];
 *   [filePath, displayTitle, durationSeconds]
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

// Helper: play a specific track and chain the next one.
// Registered before the switch so "play" and "next" can call it immediately.
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

    // Stop any in-flight sample on this radio, then start the new one.
    // playSound3D is global: every client renders it at _radio's
    // position with proper 3D falloff, so range/audibility is automatic.
    [_radio, _path, _title] remoteExec ["DZ_fnc_radioPlayLocal", 0, _radio];

    // Schedule the next track. The session check at the top of this
    // function makes sure we don't auto-advance after Stop or Next.
    [
        {
            params ["_radio", "_session"];
            if (isNull _radio) exitWith {};
            if ((_radio getVariable ["radio_session", 0]) != _session) exitWith {};
            if !(_radio getVariable ["radio_playing", false]) exitWith {};

            private _tracks = missionNamespace getVariable ["DZ_RadioTracks", []];
            if (_tracks isEqualTo []) exitWith {};

            private _next = ((_radio getVariable ["radio_track", 0]) + 1) mod (count _tracks);

            // Bump session for the auto-advance so it counts as a state
            // change (so a player Stop landing one frame later still wins).
            private _newSession = (_radio getVariable ["radio_session", 0]) + 1;
            _radio setVariable ["radio_session", _newSession, true];
            _radio setVariable ["radio_track",   _next,       true];

            [_radio, _next, _newSession] call DZ_fnc_radioControl_playTrack;
        },
        [_radio, _session],
        _duration + 1
    ] call CBA_fnc_waitAndExecute;
};

// Bump the session counter on EVERY state change. Any pending
// CBA_fnc_waitAndExecute callback from a previous track checks this
// before firing — if it doesn't match, the action's been superseded.
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
        // Session already bumped above — any pending callback bails.
    };

    case "next":
    {
        if !(_radio getVariable ["radio_playing", false]) exitWith {};

        private _trackIdx = ((_radio getVariable ["radio_track", 0]) + 1) mod (count _tracks);
        _radio setVariable ["radio_track", _trackIdx, true];

        [_radio, _trackIdx, _session] call DZ_fnc_radioControl_playTrack;
    };
};
