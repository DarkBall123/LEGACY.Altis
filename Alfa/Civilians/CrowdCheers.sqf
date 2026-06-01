/*
 * Alfa/Civilians/CrowdCheers.sqf
 * Lets friendly ambient civilians briefly gather around and cheer players.
 */

if (missionNamespace getVariable ["ALFA_civCrowdCheersStarted", false]) exitWith {};
missionNamespace setVariable ["ALFA_civCrowdCheersStarted", true];

private _clapMove = "ALFA_CrowdClap";
private _clapAvailable = isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _clapMove);
private _happyMoves = [
    "ALFA_CrowdClap",
    "ALFA_CrowdClap",
    "ALFA_CrowdCheer",
    "ALFA_CrowdExcited1",
    "ALFA_CrowdExcited3"
] select {
    isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _x)
};
private _protestMoves = [
    "ALFA_CrowdExcited1",
    "ALFA_CrowdExcited3",
    "ALFA_CrowdCheer"
] select {
    isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _x)
};
private _calmMoves = [];
if (!_clapAvailable) then {
    diag_log "[ALFA_CIV] ALFA crowd reactions addon is not loaded. Crowd applause is disabled.";
};

while { true } do {
    private _players = allPlayers select {
        alive _x
        && { !(_x isKindOf "HeadlessClient_F") }
        && { vehicle _x isEqualTo _x }
    };

    {
        private _player = _x;
        private _nextCheerAt = _player getVariable ["ALFA_civNextCrowdCheerAt", 0];

        if (time >= _nextCheerAt) then {
            private _side = side group _player;
            private _repKey = switch (true) do {
                case (_side isEqualTo west):       { "ALFA_civilianReputation_west" };
                case (_side isEqualTo resistance): { "ALFA_civilianReputation_resistance" };
                case (_side isEqualTo east):       { "ALFA_civilianReputation_east" };
                default                            { "" };
            };
            private _reputation = if (_repKey isEqualTo "") then {
                0
            } else {
                missionNamespace getVariable [_repKey, 50]
            };

            if (_clapAvailable) then {
                private _nearCivilians = allUnits select {
                    alive _x
                    && { local _x }
                    && { vehicle _x isEqualTo _x }
                    && { side group _x isEqualTo civilian }
                    && { _x getVariable ["ALFA_civAmbient", false] }
                    && { !(_x getVariable ["ALFA_civCrowdCheering", false]) }
                    && { (_x getVariable ["ALFA_civPanicUntil", 0]) <= time }
                    && { (_x getVariable ["ALFA_civNextReactionTime", 0]) <= time }
                    && { (_x distance2D _player) <= 45 }
                };

                if (count _nearCivilians >= 2) then {
                    private _role = switch (true) do {
                        case (_reputation >= 80): { "grateful" };
                        case (_reputation >= 50): { "friendly" };
                        case (_reputation >= 20): { "cautious" };
                        default { "hostile" };
                    };
                    private _roleCivilians = _nearCivilians select {
                        (_x getVariable ["ALFA_civCrowdRole", "neutral"]) isEqualTo _role
                    };
                    if (count _roleCivilians >= 2) then {
                        _nearCivilians = _roleCivilians;
                    };
                    private _selectedMoves = switch (_role) do {
                        case "hostile": { _protestMoves };
                        case "cautious": { [] };
                        case "neutral": { [] };
                        default { _happyMoves };
                    };
                    private _useAnimation = !(_selectedMoves isEqualTo []);
                    private _soundPool = switch (_role) do {
                        case "hostile": { ["ALFA_CrowdAngry", "ALFA_CrowdAngryLarge", "ALFA_CrowdAngryLarge2", "ALFA_CrowdAngrySmall"] };
                        case "cautious": { ["ALFA_CrowdChill"] };
                        case "neutral": { ["ALFA_CrowdChill", "ALFA_CrowdChillLarge"] };
                        default { ["ALFA_CrowdHappy"] };
                    } select {
                        isClass (configFile >> "CfgSounds" >> _x)
                    };
                    private _maxCrowd = switch (_role) do {
                        case "grateful": { 5 };
                        case "hostile": { 5 };
                        case "cautious": { 3 };
                        default { 4 };
                    };
                    private _cheeringCivilians = _nearCivilians select [0, (count _nearCivilians) min _maxCrowd];
                    _player setVariable ["ALFA_civNextCrowdCheerAt", time + 75 + random 45];

                    {
                        private _civilian = _x;
                        _civilian setVariable ["ALFA_civCrowdCheering", true];
                        _civilian setBehaviour "CARELESS";
                        _civilian setSpeedMode "LIMITED";
                        _civilian setUnitPos "UP";
                    } forEach _cheeringCivilians;

                    [_cheeringCivilians, _player, _selectedMoves, _soundPool, _role, _useAnimation] spawn {
                        params ["_civilians", "_player", "_selectedMoves", "_soundPool", "_role", "_useAnimation"];

                        private _ringDistance = switch (_role) do {
                            case "grateful": { 5 };
                            case "friendly": { 7 };
                            case "hostile": { 9 };
                            default { 11 };
                        };
                        private _angleStep = 360 / ((count _civilians) max 1);

                        {
                            private _angle = (_forEachIndex * _angleStep) + random 25;
                            private _targetPos = _player getPos [_ringDistance + random 2, _angle];
                            _x setVariable ["ALFA_civCrowdTargetPos", _targetPos];
                            _x doMove _targetPos;
                        } forEach _civilians;

                        private _gatherUntil = time + 18;
                        waitUntil {
                            sleep 1;
                            time >= _gatherUntil
                            || {
                                ({ !isNull _x && { alive _x } && { (_x distance2D (_x getVariable ["ALFA_civCrowdTargetPos", getPosATL _x])) <= 3 } } count _civilians)
                                >= (((count _civilians) * 0.6) max 1)
                            }
                        };

                        private _cheerUntil = time + 12 + random 8;
                        private _leader = _civilians param [0, objNull];
                        if (!isNull _leader && { alive _leader } && { !(_soundPool isEqualTo []) }) then {
                            _leader say3D (selectRandom _soundPool);
                        };

                        {
                            if (!isNull _x && { alive _x }) then {
                                doStop _x;
                                _x setVariable ["ALFA_civCrowdCheerUntil", _cheerUntil];
                                _x setDir (_x getDir _player);
                                if (_useAnimation) then {
                                    _x setVariable ["ALFA_civCrowdMove", selectRandom _selectedMoves];
                                    _x switchMove (_x getVariable ["ALFA_civCrowdMove", ""]);
                                } else {
                                    _x setVariable ["ALFA_civCrowdMove", ""];
                                };
                            };
                        } forEach _civilians;

                        while { time < _cheerUntil } do {
                            {
                                if (
                                    !isNull _x
                                    && { alive _x }
                                    && { vehicle _x isEqualTo _x }
                                    && { _x getVariable ["ALFA_civCrowdCheering", false] }
                                ) then {
                                    _x setDir (_x getDir _player);
                                    if (_useAnimation) then {
                                        private _move = _x getVariable ["ALFA_civCrowdMove", ""];
                                        if (_move isEqualTo "" || { !(isClass (configFile >> "CfgMovesMaleSdr" >> "States" >> _move)) }) then {
                                            _move = selectRandom _selectedMoves;
                                            _x setVariable ["ALFA_civCrowdMove", _move];
                                        };
                                        if !(animationState _x isEqualTo _move) then {
                                            _x switchMove _move;
                                        };
                                    };
                                };
                            } forEach _civilians;
                            sleep 3;
                        };

                        {
                            if (!isNull _x && { _x getVariable ["ALFA_civCrowdCheering", false] }) then {
                                _x setVariable ["ALFA_civCrowdCheering", false];
                                _x setVariable ["ALFA_civCrowdMove", ""];
                                _x switchMove "AmovPercMstpSnonWnonDnon";
                                _x setSpeedMode "LIMITED";
                                _x doMove (_x getPos [15 + random 20, random 360]);
                            };
                        } forEach _civilians;
                    };
                };
            };
        };
    } forEach _players;

    sleep 5;
};
