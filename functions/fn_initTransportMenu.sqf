/*
 * DZ_fnc_initTransportMenu
 * Adds ACE transport request actions to the transport support object.
 */

params [["_object", objNull, [objNull]]];

if (isNull _object) exitWith { false };
if (!hasInterface) exitWith { true };
if (_object getVariable ["transport_action_added", false]) exitWith { true };

_object setVariable ["transport_action_added", true, false];

_object addAction
[
    "Запросить транспорт (Мотоцикл)",
    {
        params ["_target", "_caller"];

        [_caller] remoteExecCall ["DZ_fnc_requestTransport", 2];
    },
    nil,
    1,
    false,
    false,
    "",
    "(side _this == resistance) && {_this distance _target < 5}"
];

true
