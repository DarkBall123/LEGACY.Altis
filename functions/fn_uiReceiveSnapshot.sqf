/*
 * DZ_fnc_uiReceiveSnapshot
 * Stores the latest server-authoritative UI snapshot on the client.
 */

params [["_snapshot", [], [[]]]];

if (!hasInterface) exitWith {};
if (_snapshot isEqualTo []) exitWith {};

uiNamespace setVariable ["DZ_uiSnapshot", _snapshot];
uiNamespace setVariable ["DZ_uiSnapshotReceivedAt", diag_tickTime];

if (!isNull (uiNamespace getVariable ["DZ_TabletDisplay", displayNull])) then
{
    [false] call DZ_fnc_uiRefreshTablet;
};
