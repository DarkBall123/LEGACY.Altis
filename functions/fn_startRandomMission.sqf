/*
 * DZ_fnc_startRandomMission
 * Selects and starts one eligible random mission for a specific side.
 *
 * _source: "auto"  - scheduler-driven (default). Subject to the
 *                    DZ_missionAutoMinPlayers gate.
 *          "fob"   - FOB laptop contract request. No min-players
 *                    gate; completion pays the doubled reward.
 *          other   - passed straight through to DZ_fnc_startMission.
 *
 * _side : the side to start the mission for. For "auto" without a
 *         specific side, we round-robin across every player side that
 *         doesn't already have an active mission, so the scheduler
 *         keeps both factions busy.
 */

params [
    ["_source", "auto",     [""]],
    ["_side",   sideUnknown]
];

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];

if (_side isEqualTo sideUnknown) then {
    private _idle = _playerSides select { !([_x] call DZ_fnc_missionActiveForSide) };
    if (_idle isNotEqualTo []) then {

        private _lastStarts = missionNamespace getVariable ["DZ_missionLastAutoStartTime", createHashMap];
        private _picks = _idle apply {[ _lastStarts getOrDefault [str _x, -1], _x ]};
        _picks sort true;
        _side = (_picks # 0) # 1;
    };
};

if (_side isEqualTo sideUnknown) exitWith { false };
if !(_side in _playerSides)       exitWith { false };

if ([_side] call DZ_fnc_missionActiveForSide) exitWith { false };

if (_source == "auto") then
{
    private _minPlayers = missionNamespace getVariable ["DZ_missionAutoMinPlayers", 1];
    private _players    = allPlayers select { !isNull _x && { isPlayer _x } && { (side group _x) isEqualTo _side } };
    if ((count _players) < _minPlayers) then
    {
        _source = "";
    };
};

if (_source == "") exitWith { false };

private _missionId = call DZ_fnc_selectRandomMission;
if (_missionId == "") exitWith { false };

private _otherSides = _playerSides - [_side];
private _crossActive = _otherSides findIf {
    ([_x] call DZ_fnc_missionActiveForSide) &&
    { (([_x] call DZ_fnc_missionStateOf) get "id") == _missionId }
};
if (_crossActive >= 0) exitWith { false };

private _started = [_missionId, objNull, _source, _side] call DZ_fnc_startMission;

if (_started isEqualTo true) then {
    private _lastStarts = missionNamespace getVariable ["DZ_missionLastAutoStartTime", createHashMap];
    _lastStarts set [str _side, time];
    missionNamespace setVariable ["DZ_missionLastAutoStartTime", _lastStarts];
};

_started isEqualTo true
