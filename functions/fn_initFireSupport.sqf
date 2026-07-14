/*
 * DZ_fnc_initFireSupport
 * Call-for-fire v1: smoke & illumination, restricted to forward
 * observers / officers (units with DZ_fireSupportOfficer = true, set in
 * the mission.sqm slot init, or a class in DZ_fireSupportOfficerClasses).
 *
 * Flow: FO self-interaction «Огневая поддержка» → pick type → single map
 * click designates the target (max range from the caller). The server
 * validates role, ₽, base supplies and a per-type cooldown, then after a
 * short time-of-flight spawns the rounds with spread.
 *
 * Economy: ₽ (DZ_squadFunds*) + supplies (base stockpile) per mission —
 * the same axes the supply system uses. Lethal types (mortar / artillery
 * / Ми-24 CAS) and the reputation-collateral hook are later versions.
 *
 * Called from BOTH initServer.sqf and initPlayerLocal.sqf; server owns
 * DZ_fnc_fireSupportCall, clients own the targeting UI.
 */

if (isNil "DZ_fireSupportMaxRange")      then { DZ_fireSupportMaxRange      = 2500; };
if (isNil "DZ_fireSupportDelay")         then { DZ_fireSupportDelay         =   15; };
if (isNil "DZ_fireSupportSpread")        then { DZ_fireSupportSpread        =   35; };
if (isNil "DZ_fireSupportSmokeMoney")    then { DZ_fireSupportSmokeMoney    =  100; };
if (isNil "DZ_fireSupportSmokeSupply")   then { DZ_fireSupportSmokeSupply   =   20; };
if (isNil "DZ_fireSupportSmokeCooldown") then { DZ_fireSupportSmokeCooldown =  120; };
if (isNil "DZ_fireSupportSmokeRounds")   then { DZ_fireSupportSmokeRounds   =    6; };
if (isNil "DZ_fireSupportIllumMoney")    then { DZ_fireSupportIllumMoney    =  100; };
if (isNil "DZ_fireSupportIllumSupply")   then { DZ_fireSupportIllumSupply   =   20; };
if (isNil "DZ_fireSupportIllumCooldown") then { DZ_fireSupportIllumCooldown =  120; };
if (isNil "DZ_fireSupportIllumRounds")   then { DZ_fireSupportIllumRounds   =    4; };
if (isNil "DZ_fireSupportOfficerClasses") then { DZ_fireSupportOfficerClasses = []; };

DZ_fnc_fireSupportIsFO = {
    params [["_unit", objNull]];
    if (isNull _unit) exitWith { false };
    if (_unit getVariable ["DZ_fireSupportOfficer", false]) exitWith { true };
    (typeOf _unit) in (missionNamespace getVariable ["DZ_fireSupportOfficerClasses", []])
};

DZ_fnc_fireSupportCall = {
    if (!isServer) exitWith {};
    params [["_caller", objNull], ["_pos", [0,0,0]], ["_type", "smoke"]];
    if (isNull _caller) exitWith {};

    private _reply = [owner _caller, 0] select (isNull _caller);

    if !([_caller] call DZ_fnc_fireSupportIsFO) exitWith {
        ["Огневая поддержка", "Вызов доступен только корректировщику."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _side = side _caller;
    private _playerSides = missionNamespace getVariable ["DZ_playerSides", [east]];
    if !(_side in _playerSides) exitWith {};

    if !(_pos isEqualType [] && { (count _pos) >= 2 }) exitWith {};
    private _maxR = missionNamespace getVariable ["DZ_fireSupportMaxRange", 2500];
    if ((_caller distance2D _pos) > _maxR) exitWith {
        ["Огневая поддержка", format ["Цель вне зоны действия (макс. %1 м).", _maxR]] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    _type = toLower _type;
    private _money = 0; private _supply = 0; private _cooldown = 120; private _rounds = 4;
    private _label = ""; private _cdKey = "";
    switch (_type) do {
        case "smoke": {
            _money = DZ_fireSupportSmokeMoney;    _supply = DZ_fireSupportSmokeSupply;
            _cooldown = DZ_fireSupportSmokeCooldown; _rounds = DZ_fireSupportSmokeRounds;
            _label = "Дымовая завеса"; _cdKey = "DZ_fireSupportCdSmoke";
        };
        case "illum": {
            _money = DZ_fireSupportIllumMoney;    _supply = DZ_fireSupportIllumSupply;
            _cooldown = DZ_fireSupportIllumCooldown; _rounds = DZ_fireSupportIllumRounds;
            _label = "Осветительные"; _cdKey = "DZ_fireSupportCdIllum";
        };
        default {};
    };
    if (_cdKey isEqualTo "") exitWith {
        ["Огневая поддержка", "Неизвестный тип задачи."] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    private _cdUntil = missionNamespace getVariable [_cdKey, 0];
    if (time < _cdUntil) exitWith {
        ["Огневая поддержка", format ["Батарея перезаряжается ещё %1 с.", round (_cdUntil - time)]] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    if (_money > 0 && { !([_money, _side] call DZ_fnc_squadFundsHasEnough) }) exitWith {
        ["Огневая поддержка", format ["Недостаточно средств. Нужно: %1₽.", _money]] remoteExecCall ["DZ_fnc_showHint", _reply];
    };
    if (_supply > 0 && { !isNil "DZ_fnc_supplyHasEnough" } && { !(["base", _supply] call DZ_fnc_supplyHasEnough) }) exitWith {
        ["Огневая поддержка", format ["Недостаточно снабжения на складе базы. Нужно: %1.", _supply]] remoteExecCall ["DZ_fnc_showHint", _reply];
    };

    if (_money > 0) then { [0 - _money, format ["Fire support: %1", _type], _side] call DZ_fnc_squadFundsAdjust; };
    if (_supply > 0 && { !isNil "DZ_fnc_supplyAdjust" }) then { ["base", 0 - _supply, format ["fire support %1", _type]] call DZ_fnc_supplyAdjust; };

    missionNamespace setVariable [_cdKey, time + _cooldown];

    private _mk = format ["DZ_fireSupportTgt_%1", round (diag_tickTime * 1000)];
    createMarker [_mk, _pos];
    _mk setMarkerShape "ICON";
    _mk setMarkerType  "mil_destroy";
    _mk setMarkerColor "ColorYellow";
    _mk setMarkerText  _label;

    private _delay = missionNamespace getVariable ["DZ_fireSupportDelay", 15];
    [format ["Выстрел! %1 — готовность через %2 с.", _label, _delay], _side] remoteExecCall ["DZ_fnc_sideMessage", 0];

    [_pos, _type, _rounds, _mk, _delay] spawn {
        params ["_pos", "_type", "_rounds", "_mk", "_delay"];

        private _resolveClass = {
            params ["_cands"];
            private _r = "";
            {
                if (isClass (configFile >> "CfgAmmo" >> _x) || { isClass (configFile >> "CfgVehicles" >> _x) }) exitWith { _r = _x; };
            } forEach _cands;
            _r
        };

        private _spread = missionNamespace getVariable ["DZ_fireSupportSpread", 35];
        private _smokeCls = [["SmokeShellArtillery", "SmokeShell"]] call _resolveClass;
        private _illumCls = [["Flare_82mm_AMOS_White", "F_40mm_White"]] call _resolveClass;

        sleep _delay;

        for "_i" from 1 to _rounds do {
            private _ox = (_pos # 0) + (_spread - random (2 * _spread));
            private _oy = (_pos # 1) + (_spread - random (2 * _spread));

            if (_type isEqualTo "smoke") then {
                if (_smokeCls != "") then { _smokeCls createVehicle [_ox, _oy, 0]; };
            } else {
                if (_illumCls != "") then {
                    private _f = createVehicle [_illumCls, [_ox, _oy, 180], [], 0, "CAN_COLLIDE"];
                    _f setVelocity [0, 0, -6];
                };
            };

            sleep (0.3 + random 0.5);
        };

        sleep 30;
        deleteMarker _mk;
    };
};

if (hasInterface) then {
    if (missionNamespace getVariable ["DZ_fireSupportClientInit", false]) exitWith {};
    missionNamespace setVariable ["DZ_fireSupportClientInit", true];

    DZ_fnc_fireSupportOpenTargeting = {
        params [["_type", "smoke"]];
        missionNamespace setVariable ["DZ_fireSupportPendingType", _type];
        missionNamespace setVariable ["DZ_fireSupportArmedUntil", time + 20];
        ["Огневая поддержка", "Укажите цель на карте одиночным кликом (ЛКМ) в течение 20 с."] call DZ_fnc_showHint;
        openMap true;
        onMapSingleClick {
            params ["_u", "_pos"];
            onMapSingleClick "";
            if (time > (missionNamespace getVariable ["DZ_fireSupportArmedUntil", 0])) exitWith { false };
            openMap false;
            private _t = missionNamespace getVariable ["DZ_fireSupportPendingType", "smoke"];
            [player, _pos, _t] remoteExecCall ["DZ_fnc_fireSupportCall", 2];
            ["Огневая поддержка", "Запрос передан на батарею."] call DZ_fnc_showHint;
            true
        };
    };

    DZ_fnc_fireSupportAddActions = {
        params [["_unit", objNull]];
        if (isNull _unit) exitWith {};
        if (_unit getVariable ["DZ_fireSupportActionsAdded", false]) exitWith {};
        _unit setVariable ["DZ_fireSupportActionsAdded", true];

        private _menu = [
            "DZ_FireSupport", "Огневая поддержка", "",
            {}, { [player] call DZ_fnc_fireSupportIsFO }, {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions"], _menu] call ace_interact_menu_fnc_addActionToObject;

        private _smoke = [
            "DZ_FireSupportSmoke", "Дымовая завеса", "",
            { ["smoke"] call DZ_fnc_fireSupportOpenTargeting; },
            { [player] call DZ_fnc_fireSupportIsFO }, {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions", "DZ_FireSupport"], _smoke] call ace_interact_menu_fnc_addActionToObject;

        private _illum = [
            "DZ_FireSupportIllum", "Осветительные", "",
            { ["illum"] call DZ_fnc_fireSupportOpenTargeting; },
            { [player] call DZ_fnc_fireSupportIsFO }, {}, [], {[0, 0, 0]}, 4
        ] call ace_interact_menu_fnc_createAction;
        [_unit, 1, ["ACE_SelfActions", "DZ_FireSupport"], _illum] call ace_interact_menu_fnc_addActionToObject;
    };

    [
        { !isNil "ace_interact_menu_fnc_createAction" && { !isNull player } },
        {
            [player] call DZ_fnc_fireSupportAddActions;
            ["unit", { params ["_unit"]; [_unit] call DZ_fnc_fireSupportAddActions; }] call CBA_fnc_addPlayerEventHandler;
        },
        []
    ] call CBA_fnc_waitUntilAndExecute;
};

true
