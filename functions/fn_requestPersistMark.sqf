/*
 * DZ_fnc_requestPersistMark
 * Server-side handler for client requests to persist a container whose
 * inventory a player opened (sent by fn_initInventoryPersistMarking).
 *
 * Classification:
 *   - Editor-placed object (DZ_edenPlaced, tagged in fn_initServer before
 *     restoreAssets) → "contents" persistence: the object exists again at
 *     mission start, so only its inventory is saved/restored through the
 *     trophy-crate mechanism (stable id + DZ_trophyCrateRegistry). The
 *     id→position mapping is persisted in DZ_autoContainerIds so
 *     fn_restoreContainerContents can re-link after a restart.
 *   - Dynamic object → DZ_fnc_markPersistent ("recreate"): the periodic
 *     asset loop snapshots it; no forced save here (anti-spam).
 */

params [["_obj", objNull, [objNull]]];

if (!isServer) exitWith { false };
if (!(missionNamespace getVariable ["DZ_invPersistEnabled", true])) exitWith { false };

if (isNull _obj) exitWith { false };
if (_obj isKindOf "CAManBase") exitWith { false };
if (!alive _obj) exitWith { false };
if ((typeOf _obj) in ["GroundWeaponHolder", "GroundWeaponHolder_Scripted", "WeaponHolder", "WeaponHolderSimulated", "WeaponHolderSimulated_Scripted", "Weapon_Empty"]) exitWith { false };
if (_obj getVariable ["DZ_persist", false]) exitWith { true };
if ((_obj getVariable ["DZ_trophyCrateId", ""]) != "") exitWith { true };

private _result = false;

if (_obj getVariable ["DZ_edenPlaced", false]) then
{

    private _containerId = vehicleVarName _obj;
    if (_containerId == "") then
    {
        private _pos = getPosWorld _obj;
        _containerId = format ["inv_%1_%2", round (_pos # 0), round (_pos # 1)];
    };

    _obj setVariable ["DZ_trophyCrateId", _containerId, true];
    _obj setVariable ["DZ_noCleanup", true, true];
    _obj setVariable ["DZ_persist", true, true];
    _obj setVariable ["DZ_persistMode", "contents", true];

    private _registry = missionNamespace getVariable ["DZ_trophyCrateRegistry", []];
    _registry pushBackUnique _obj;
    missionNamespace setVariable ["DZ_trophyCrateRegistry", _registry];

    private _pos = getPosWorld _obj;
    private _autoIds = ["DZ_autoContainerIds", []] call DZ_fnc_storeGet;
    if ((_autoIds findIf { (_x param [0, ""]) isEqualTo _containerId }) < 0) then
    {
        _autoIds pushBack [_containerId, round (_pos # 0), round (_pos # 1), typeOf _obj];
        ["DZ_autoContainerIds", _autoIds] call DZ_fnc_storeSet;
    };

    call DZ_fnc_saveTrophyCrates;

    diag_log format ["[DZ_ASSETS] Auto-marked %1 at %2 mode=contents id=%3", typeOf _obj, getPosATL _obj, _containerId];
    _result = true;
}
else
{
    _result = [_obj] call DZ_fnc_markPersistent;

    if (_result) then
    {
        diag_log format ["[DZ_ASSETS] Auto-marked %1 at %2 mode=recreate", typeOf _obj, getPosATL _obj];
    };
};

_result
