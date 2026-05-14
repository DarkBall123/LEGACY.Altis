/*
 * DZ_fnc_startRandomMission
 * Selects and starts one eligible random mission.
 */

if (!isServer) exitWith { false };

call DZ_fnc_initMissionSystem;

if (missionNamespace getVariable ["DZ_missionActive", false]) exitWith { false };

private _minPlayers = missionNamespace getVariable ["DZ_missionAutoMinPlayers", 1];
private _players = allPlayers select { !isNull _x && { isPlayer _x } };
if ((count _players) < _minPlayers) exitWith { false };

private _missionId = call DZ_fnc_selectRandomMission;
if (_missionId == "") exitWith { false };

private _started = [_missionId, objNull, "auto"] call DZ_fnc_startMission;

_started isEqualTo true
