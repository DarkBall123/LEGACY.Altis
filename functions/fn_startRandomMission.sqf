/*
 * DZ_fnc_startRandomMission
 * Selects and starts one eligible random mission.
 *
 * _source: "auto"  - scheduler-driven (default). Subject to the
 *                    DZ_missionAutoMinPlayers gate.
 *          "fob"   - FOB laptop contract request. No min-players
 *                    gate; completion pays the doubled reward.
 *          other   - passed straight through to DZ_fnc_startMission.
 */

params [["_source", "auto", [""]]];

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith { false };

if (_source == "auto") then
{
    private _minPlayers = missionNamespace getVariable ["DZ_missionAutoMinPlayers", 1];
    private _players = allPlayers select { !isNull _x && { isPlayer _x } };
    if ((count _players) < _minPlayers) then
    {
        _source = "";
    };
};

if (_source == "") exitWith { false };

private _missionId = call DZ_fnc_selectRandomMission;
if (_missionId == "") exitWith { false };

private _started = [_missionId, objNull, _source] call DZ_fnc_startMission;

_started isEqualTo true
