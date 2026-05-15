/*
 * DZ_fnc_enforcePylonRestrictions
 * Removes forbidden pylon magazines from non-Zeus air assets.
 */

params [["_vehicle", objNull, [objNull]]];

if (isNull _vehicle) exitWith { false };
if (_vehicle getVariable ["DZ_createdByZeus", false]) exitWith { false };
if (_vehicle getVariable ["DZ_noPylonRestrictions", false]) exitWith { false };
if !(_vehicle isKindOf "Air") exitWith { false };

private _pylons = getPylonMagazines _vehicle;
if (_pylons isEqualTo []) exitWith { false };

private _classTokens = missionNamespace getVariable
[
    "DZ_forbiddenPylonClassTokens",
    ["EMP", "NAPALM", "FSNB_", "ASPHYXIANT", "BLISTER", "NERVE", "NOVA", "RIOTCSGAS"]
];
private _displayTokens = missionNamespace getVariable
[
    "DZ_forbiddenPylonDisplayTokens",
    ["EMP", "GAS", "NUCLEAR", "BLISTER AGENT", "NAPALM"]
];
private _blockedPylons = [];

{
    private _magazine = _x;

    if (_magazine != "") then
    {
        private _classText = toUpper _magazine;
        private _displayText = toUpper (getText (configFile >> "CfgMagazines" >> _magazine >> "displayName"));
        private _blockedByClass = (_classTokens findIf { (_classText find _x) >= 0 }) >= 0;
        private _blockedByDisplay = (_displayTokens findIf { (_displayText find _x) >= 0 }) >= 0;

        if (_blockedByClass || { _blockedByDisplay }) then
        {
            private _pylonIndex = _forEachIndex + 1;
            _blockedPylons pushBack [_pylonIndex, _magazine, _displayText];
        };
    };
} forEach _pylons;

if (_blockedPylons isEqualTo []) exitWith { false };

if (!local _vehicle) exitWith
{
    [_vehicle] remoteExecCall ["DZ_fnc_enforcePylonRestrictions", _vehicle];
    false
};

private _pylonsInfo = getAllPylonsInfo _vehicle;
private _removed = [];

{
    _x params ["_pylonIndex", "_magazine", "_displayText"];

    private _pylonInfo = _pylonsInfo param [_pylonIndex - 1, []];
    private _turret = _pylonInfo param [2, []];
    if !(_turret isEqualType []) then
    {
        _turret = [];
    };

    _vehicle setPylonLoadout [_pylonIndex, "", true, _turret];
    _vehicle setAmmoOnPylon [_pylonIndex, 0];
    _removed pushBack [_pylonIndex, _magazine, _displayText];
} forEach _blockedPylons;

if (_removed isNotEqualTo []) then
{
    _vehicle setVariable ["DZ_forbiddenPylonsRemoved", _removed, true];
    diag_log format ["[DZ_PYLONS] Removed forbidden pylons from %1 (%2): %3", typeOf _vehicle, _vehicle, _removed];
};

_removed isNotEqualTo []
