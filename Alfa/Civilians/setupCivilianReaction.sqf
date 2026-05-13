/*
    Adds danger reactions to Engima pedestrian civilians only.
    Server-side: one shared shot monitor handles all registered civilians.
*/

if (!isServer) exitWith {};

params ["_unit"];

if (isNil "ALFA_civReactionUnits") then {
    ALFA_civReactionUnits = [];
};

if (isNil "ALFA_civRecentShots") then {
    ALFA_civRecentShots = [];
};

if (isNil "ALFA_fnc_civFlee") then {
    ALFA_fnc_civFlee = {
        params ["_unit", "_threat"];

        private _threatPos = if (isNull _threat) then { getPosATL _unit } else { getPosATL _threat };
        private _dir = _threatPos getDir _unit;
        private _dest = _unit getPos [70 + random 50, _dir + random 50 - 25];

        _unit enableAI "MOVE";
        _unit enableAI "PATH";
        _unit allowFleeing 1;
        _unit setBehaviour "CARELESS";
        _unit setSpeedMode "FULL";
        _unit setUnitPos "UP";
        _unit forceSpeed -1;
        _unit move _dest;
        _unit doMove _dest;

        [_unit, _dest] spawn {
            params ["_unit", "_dest"];

            private _until = time + 10;
            while { time < _until && { !isNull _unit } && { alive _unit } && { vehicle _unit isEqualTo _unit } } do {
                _unit setUnitPos "UP";
                _unit setBehaviour "CARELESS";
                _unit setSpeedMode "FULL";
                _unit forceSpeed -1;
                _unit move _dest;
                _unit doMove _dest;
                sleep 1;
            };
        };
    };

    ALFA_fnc_civHide = {
        params ["_unit", "_threat"];

        private _houses = nearestObjects [_unit, ["House", "Building"], 55, true];
        private _hidePos = [];

        {
            private _positions = _x buildingPos -1;
            if !(_positions isEqualTo []) exitWith {
                _hidePos = selectRandom _positions;
            };
        } forEach _houses;

        if (_hidePos isEqualTo []) exitWith {
            [_unit, _threat] call ALFA_fnc_civFlee;
        };

        _unit enableAI "MOVE";
        _unit enableAI "PATH";
        _unit allowFleeing 1;
        _unit setBehaviour "CARELESS";
        _unit setSpeedMode "FULL";
        _unit setUnitPos "UP";
        _unit forceSpeed -1;
        _unit move _hidePos;
        _unit doMove _hidePos;
    };

    ALFA_fnc_civSurrender = {
        params ["_unit", "_threat"];

        doStop _unit;
        _unit setBehaviour "CARELESS";
        _unit setSpeedMode "LIMITED";
        _unit setUnitPos "UP";
        _unit playMoveNow "AmovPercMstpSsurWnonDnon";

        [_unit, _threat] spawn {
            params ["_unit", "_threat"];

            sleep (8 + random 6);
            if (isNull _unit || { !alive _unit } || { !(vehicle _unit isEqualTo _unit) }) exitWith {};
            [_unit, _threat] call ALFA_fnc_civFlee;
        };
    };

    ALFA_fnc_civFreeze = {
        params ["_unit", "_threat"];

        doStop _unit;
        _unit setBehaviour "CARELESS";
        _unit setSpeedMode "LIMITED";
        _unit setUnitPos "MIDDLE";

        [_unit, _threat] spawn {
            params ["_unit", "_threat"];

            sleep (2 + random 3);
            if (isNull _unit || { !alive _unit } || { !(vehicle _unit isEqualTo _unit) }) exitWith {};
            [_unit, _threat] call ALFA_fnc_civFlee;
        };
    };

    ALFA_fnc_civThrowGrenade = {
        params ["_unit", "_threat"];

        if ((_unit getVariable ["ALFA_civGrenadesLeft", 0]) <= 0) exitWith { [_unit, _threat] call ALFA_fnc_civFlee };
        if (isNull _threat) exitWith { [_unit, _threat] call ALFA_fnc_civFlee };
        if ((_unit distance2D _threat) > 45) exitWith { [_unit, _threat] call ALFA_fnc_civFlee };

        _unit setVariable ["ALFA_civGrenadesLeft", 0];

        doStop _unit;
        _unit setBehaviour "AWARE";
        _unit setDir (_unit getDir _threat);
        _unit playMoveNow "AwopPercMstpSgthWnonDnon_end";

        [_unit, _threat] spawn {
            params ["_unit", "_threat"];
            sleep 0.45;

            if (isNull _unit || { isNull _threat } || { !alive _unit } || { !(vehicle _unit isEqualTo _unit) }) exitWith {};

            private _grenadeMags = [
                "rhs_mag_an_m14_th3",
                "HandGrenade"
            ];
            private _magClass = selectRandom _grenadeMags;
            private _ammoClass = getText (configFile >> "CfgMagazines" >> _magClass >> "ammo");

            if (_ammoClass isEqualTo "" || { !(isClass (configFile >> "CfgAmmo" >> _ammoClass)) }) exitWith {
                [_unit, _threat] call ALFA_fnc_civFlee;
            };

            private _start = eyePos _unit;
            private _target = eyePos _threat;
            private _grenade = createVehicle [_ammoClass, ASLToATL _start, [], 0, "CAN_COLLIDE"];
            _grenade setPosASL _start;

            private _velocity = _start vectorFromTo _target;
            _grenade setVelocity [
                (_velocity select 0) * (16 + random 4),
                (_velocity select 1) * (16 + random 4),
                4 + random 3
            ];

            private _runDir = (getPosATL _threat) getDir _unit;
            private _runPos = _unit getPos [90 + random 60, _runDir + random 40 - 20];
            _unit enableAI "MOVE";
            _unit enableAI "PATH";
            _unit allowFleeing 1;
            _unit setBehaviour "CARELESS";
            _unit setSpeedMode "FULL";
            _unit setUnitPos "UP";
            _unit forceSpeed -1;
            _unit move _runPos;
            _unit doMove _runPos;

            [_unit, _runPos] spawn {
                params ["_unit", "_runPos"];

                private _until = time + 12;
                while { time < _until && { !isNull _unit } && { alive _unit } && { vehicle _unit isEqualTo _unit } } do {
                    _unit setUnitPos "UP";
                    _unit setBehaviour "CARELESS";
                    _unit setSpeedMode "FULL";
                    _unit forceSpeed -1;
                    _unit move _runPos;
                    _unit doMove _runPos;
                    sleep 1;
                };
            };
        };
    };

    ALFA_fnc_civGetThreat = {
        params ["_unit", "_firer"];

        if (!isNull _firer && { alive _firer }) exitWith { _firer };

        private _nearPlayers = allPlayers select {
            alive _x
            && { !(_x isKindOf "HeadlessClient_F") }
            && { (_x distance2D _unit) < 55 }
        };

        if (_nearPlayers isEqualTo []) exitWith { objNull };

        _nearPlayers select 0
    };

    ALFA_fnc_civReactToThreat = {
        params ["_unit", "_threat", ["_distance", 0]];

        if (isNull _unit || { !alive _unit }) exitWith {};
        if !(vehicle _unit isEqualTo _unit) exitWith {};
        if (_distance > 55) exitWith {};
        if ((_unit getVariable ["ALFA_civNextReactionTime", 0]) > time) exitWith {};

        _unit setVariable ["ALFA_civNextReactionTime", time + 6 + random 8];

        switch (_unit getVariable ["ALFA_civReaction", "flee"]) do {
            case "stone": { [_unit, _threat] call ALFA_fnc_civThrowGrenade };
            case "hide": { [_unit, _threat] call ALFA_fnc_civHide };
            case "surrender": { [_unit, _threat] call ALFA_fnc_civSurrender };
            case "freeze": { [_unit, _threat] call ALFA_fnc_civFreeze };
            default { [_unit, _threat] call ALFA_fnc_civFlee };
        };
    };
};

if (isNil "ALFA_civShotMonitorReady") then {
    ALFA_civShotMonitorReady = true;

    [] spawn {
        while { true } do {
            {
                if (isPlayer _x && { isNil { _x getVariable "ALFA_civFiredEh" } }) then {
                    private _eh = _x addEventHandler ["Fired", {
                        params ["_shooter"];

                        if (isNull _shooter) exitWith {};
                        if !(isPlayer _shooter) exitWith {};

                        ALFA_civRecentShots pushBack [time, _shooter, getPosATL _shooter];
                        ALFA_civRecentShots = ALFA_civRecentShots select { (time - (_x select 0)) < 8 };
                    }];

                    _x setVariable ["ALFA_civFiredEh", _eh];
                };
            } forEach allPlayers;

            ALFA_civRecentShots = ALFA_civRecentShots select { (time - (_x select 0)) < 8 };
            ALFA_civReactionUnits = ALFA_civReactionUnits select { !isNull _x && { alive _x } };

            {
                _x params ["_shotTime", "_shooter", "_shotPos"];

                if (!isNull _shooter && { alive _shooter }) then {
                    {
                        if (vehicle _x isEqualTo _x && { (_x distance2D _shotPos) < 55 }) then {
                            [_x, _shooter, _x distance2D _shotPos] call ALFA_fnc_civReactToThreat;
                        };
                    } forEach ALFA_civReactionUnits;
                };
            } forEach ALFA_civRecentShots;

            sleep 1;
        };
    };
};

if (isNull _unit) exitWith {};
if (!alive _unit) exitWith {};
if !(vehicle _unit isEqualTo _unit) exitWith {};
if (_unit getVariable ["ALFA_civReactionReady", false]) exitWith {};

_unit setVariable ["ALFA_civReactionReady", true, true];

private _roll = random 1;
private _reaction = "flee";

if (_roll < 0.05) then {
    _reaction = "stone";
} else {
    if (_roll < 0.20) then {
        _reaction = "hide";
    } else {
        if (_roll < 0.35) then {
            _reaction = "surrender";
        } else {
            if (_roll < 0.40) then {
                _reaction = "freeze";
            };
        };
    };
};

_unit setVariable ["ALFA_civReaction", _reaction, true];
_unit setVariable ["ALFA_civNextReactionTime", 0];
_unit setVariable ["ALFA_civGrenadesLeft", 1];
ALFA_civReactionUnits pushBackUnique _unit;

_unit addEventHandler ["FiredNear", {
    params ["_unit", "_firer", "_distance"];

    private _threat = [_unit, _firer] call ALFA_fnc_civGetThreat;
    [_unit, _threat, _distance] call ALFA_fnc_civReactToThreat;
}];

_unit addEventHandler ["Hit", {
    params ["_unit", "_source"];

    if (isNull _unit || { !alive _unit }) exitWith {};
    if !(vehicle _unit isEqualTo _unit) exitWith {};

    _unit setVariable ["ALFA_civReaction", "flee", true];
    _unit setVariable ["ALFA_civNextReactionTime", time + 12];
    [_unit, _source] call ALFA_fnc_civFlee;
}];
