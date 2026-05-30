/*
 * DZ_fnc_requestMissionStatus
 * Sends the current mission status to the requesting player. Shows
 * the caller's faction status only — not the other side's mission.
 *
 * Off-side callers (spectators/debug) get a roll-up of every active
 * player-side mission so something useful still appears.
 */

params [
    ["_caller", objNull, [objNull]]
];

if (!isServer) exitWith {};
if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;

call DZ_fnc_initMissionSystem;

private _side = [_caller] call DZ_fnc_missionSideOfPlayer;

if (_side isEqualTo sideUnknown) exitWith {
    // Off-side fallback: show all active sides.
    private _active = call DZ_fnc_missionActiveSides;
    if (_active isEqualTo []) exitWith {
        ["Штаб", "Нет активных миссий ни у одной фракции."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
    };
    private _lines = [];
    {
        private _s     = [_x] call DZ_fnc_missionStateOf;
        private _label = [_x] call DZ_fnc_missionSideLabel;
        _lines pushBack (format ["%1: %2 (%3 мин)",
            _label,
            _s get "title",
            floor ((time - (_s get "startTime")) / 60)
        ]);
    } forEach _active;
    ["Штаб", _lines joinString endl] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _factionLabel = [_side] call DZ_fnc_missionSideLabel;

if !([_side] call DZ_fnc_missionActiveForSide) exitWith {
    [
        "Штаб",
        format ["У %1 нет активной миссии.", _factionLabel]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _state = [_side] call DZ_fnc_missionStateOf;

[
    "Штаб",
    format [
        "Фракция: %1\nАктивная миссия: %2\nИсточник: %3\nПродолжительность: %4 мин",
        _factionLabel,
        _state get "title",
        _state get "source",
        floor ((time - (_state get "startTime")) / 60)
    ]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
