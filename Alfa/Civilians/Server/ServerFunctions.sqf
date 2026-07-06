/*
 * Alfa/Civilians/Server/ServerFunctions.sqf
 * Defines server-side spawning, movement, and lifecycle functions for civilian AI.
 */

ENGIMA_CIVILIANS_GetParamValue = {
	private ["_params", "_key"];
	private ["_value"];

	_params = _this select 0;
	_key = _this select 1;
	_value = if (count _this > 2) then { _this select 2 } else { objNull };

	{
		if (_x select 0 == _key) then {
			_value = _x select 1;
		};
	} foreach (_params);

	_value
};


ENGIMA_CIVILIANS_GetAllPlayersPositions = {
	private ["_playerPositions"];

	_playerPositions = [];

	if (isMultiplayer) then {
		{
			if (isPlayer _x) then {
				_playerPositions pushBack (position vehicle _x);
			};
		} foreach (playableUnits);
	}
	else {
		if (player == player) then {
			_playerPositions = [position vehicle player];
		};
	};


	_playerPositions
};

ENGIMA_CIVILIANS_GetAllPlayers = {
	allPlayers select {
		alive _x
		&& { !(_x isKindOf "HeadlessClient_F") }
	}
};

ENGIMA_CIVILIANS_CountPositionsInBuilding = {
	private ["_building"];
	private ["_count"];

	_building = _this select 0;

	_count = 0;
	while { format ["%1", _building buildingPos _count] != "[0,0,0]" } do {
		_count = _count + 1;
	};

	_count
};

ENGIMA_CIVILIANS_FindSpawnPosition = {
	private ["_minSpawnDistance", "_playerBuildings", "_blackListMarkers"];
	private ["_playerPositions", "_tries", "_positionFound", "_foundPosition", "_buildingPosCount", "_building", "_tooClose", "_buildingPosNo", "_playerBuilding"];

	_minSpawnDistance = _this select 0;
	_playerBuildings = _this select 1;
	_blackListMarkers = _this select 2;

	_playerPositions = call ENGIMA_CIVILIANS_GetAllPlayersPositions;

	_tries = 0;
	_positionFound = false;
	_foundPosition = [];

	while { count _playerBuildings > 0 && !_positionFound && _tries < 10 } do {
		_tries = _tries + 1;
		_playerBuilding = _playerBuildings select floor random count _playerBuildings;
		_building = _playerBuilding select 0;
		_buildingPosCount = _playerBuilding select 1;


		if (_buildingPosCount > 0) then {
			_buildingPosNo = floor random _buildingPosCount;

			_tooClose = false;
			if (time > 5) then {
				{
					if (_x distance _building < _minSpawnDistance) then {
						_tooClose = true;
					};
				} foreach _playerPositions;
			};

			if (!_tooClose) then {
				if (!([getPos _building, _blackListMarkers] call ENGIMA_CIVILIANS_PositionInsideBlackMarker)) then {
					_foundPosition = _building buildingPos _buildingPosNo;
					_positionFound = true;
				};
			};
		};
	};

	_foundPosition
};

ENGIMA_CIVILIANS_PositionInsideBlackMarker = {
	private ["_pos", "_blackListMarkers"];
	private ["_isInsideMarker"];

	_pos = _this select 0;
	_blackListMarkers = _this select 1;

	_isInsideMarker = false;

	{
		if (_pos inArea _x) then {
			_isInsideMarker = true;
		};
	} foreach _blackListMarkers;

	_isInsideMarker
};

ENGIMA_CIVILIANS_FindDestinationPosition = {
	private ["_civilian", "_blackListMarkers", "_maxSpawnDistance"];
	private ["_tries", "_positionFound", "_foundPosition", "_buildingPosCount", "_buildings", "_building", "_buildingPosNo", "_unitPos"];

	_civilian = _this select 0;
	_blackListMarkers = _this select 1;
	_maxSpawnDistance = _this select 2;

	_foundPosition = [];
	_tries = 0;
	_positionFound = false;
	_unitPos = getPosAtl _civilian;

	if (random 100 > 50) then {

		_buildings = nearestObjects [_unitPos, ["house"], _maxSpawnDistance];

		while { count _buildings > 0 && !_positionFound && _tries < 10 } do {
			_tries = _tries + 1;

			_building = _buildings select floor random count _buildings;
			_buildingPosCount = [_building] call ENGIMA_CIVILIANS_CountPositionsInBuilding;

			if (_buildingPosCount > 0) then {
				if (!([getPos _building, _blackListMarkers] call ENGIMA_CIVILIANS_PositionInsideBlackMarker)) then {
					_buildingPosNo = floor random _buildingPosCount;
					_foundPosition = _building buildingPos _buildingPosNo;
					_positionFound = true;
				};
			};
		};
	}
	else {
		private ["_distance", "_angle", "_x", "_y", "_pos"];

		while { !_positionFound && _tries < 10 } do {
			_tries = _tries + 1;

			_distance = random 200;
			_angle = random 360;
			_x = _distance * cos _angle;
			_y = _distance * sin _angle;

			_pos = [(_unitPos select 0) + _x, (_unitPos select 1) + _y];
			if (!isOnRoad _pos && !surfaceIsWater _pos && !([_pos, _blackListMarkers] call ENGIMA_CIVILIANS_PositionInsideBlackMarker)) then {
				_foundPosition = _pos;
				_positionFound = true;
			};
		};
	};

	_foundPosition
};

ENGIMA_CIVILIANS_GetPlayerBuildings = {
	private ["_allPlayerPositions", "_maxSpawnDistance", "_blackListMarkers"];
	private ["_playerBuildings", "_buildings", "_playerBuildingsTemp", "_buildingPosCount"];

	_allPlayerPositions = _this select 0;
	_maxSpawnDistance = _this select 1;
	_blackListMarkers = _this select 2;

	_playerBuildings = [];

	{
		_buildings = nearestObjects [_x, ["house"], _maxSpawnDistance];
		sleep 0.01;
		_buildings = _buildings - _playerBuildings;
		sleep 0.01;
		_playerBuildings = _playerBuildings + _buildings;
		sleep 0.01;
	} foreach _allPlayerPositions;


	_playerBuildingsTemp = [];
	{
		_buildingPosCount = [_x] call ENGIMA_CIVILIANS_CountPositionsInBuilding;

		if (_buildingPosCount > 0) then {
			if (!([getPos _x, _blackListMarkers] call ENGIMA_CIVILIANS_PositionInsideBlackMarker)) then {
				_playerBuildingsTemp pushBack [_x, _buildingPosCount];
			};
		}
	} foreach _playerBuildings;


	_playerBuildingsTemp
};


ENGIMA_CIVILIANS_StartCivilians = {
	private ["_unit", "_maxUnitsCount"];
	private ["_civilianItems"];
	private ["_spawnUnit", "_allPlayerPositions", "_playerBuildings"];

	private _side = [_this, "SIDE", civilian] call ENGIMA_CIVILIANS_GetParamValue;
	private _minSkill = [_this, "MIN_SKILL", 0.4] call ENGIMA_CIVILIANS_GetParamValue;
	private _maxSkill = [_this, "MAX_SKILL", 0.6] call ENGIMA_CIVILIANS_GetParamValue;
	private _unitClasses = [_this, "UNIT_CLASSES", ["LOP_CHR_Civ_Worker_02", "LOP_CHR_Civ_Worker_01", "LOP_CHR_Civ_Worker_04", "LOP_CHR_Civ_Worker_03", "LOP_CHR_Civ_Woodlander_04", "LOP_CHR_Civ_Woodlander_03", "LOP_CHR_Civ_Villager_02", "LOP_CHR_Civ_Villager_03", "LOP_CHR_Civ_Villager_04", "LOP_CHR_Civ_Villager_01", "LOP_CHR_Civ_SchoolTeacher", "LOP_CHR_Civ_Rocker_04", "LOP_CHR_Civ_Rocker_01", "LOP_CHR_Civ_Profiteer_04", "LOP_CHR_Civ_Random", "LOP_CHR_Civ_Priest_01", "LOP_CHR_Civ_Policeman_01", "LOP_CHR_Civ_Functionary_02", "LOP_CHR_Civ_Functionary_01", "LOP_CHR_Civ_Doctor_01", "LOP_CHR_Civ_Citizen_02", "LOP_CHR_Civ_Citizen_01", "LOP_CHR_Civ_Citizen_04", "LOP_CHR_Civ_Assistant"]] call ENGIMA_CIVILIANS_GetParamValue;
	private _unitsPerBuilding = [_this, "UNITS_PER_BUILDING", 0.1] call ENGIMA_CIVILIANS_GetParamValue;
	private _maxGroupsCount = [_this, "MAX_GROUPS_COUNT", 100] call ENGIMA_CIVILIANS_GetParamValue;
	private _minSpawnDistance = [_this, "MIN_SPAWN_DISTANCE", 100] call ENGIMA_CIVILIANS_GetParamValue;
	private _maxSpawnDistance = [_this, "MAX_SPAWN_DISTANCE", 500] call ENGIMA_CIVILIANS_GetParamValue;
	private _blackListMarkers = [_this, "BLACKLIST_MARKERS", []] call ENGIMA_CIVILIANS_GetParamValue;
	private _hideBlacklistMarkers = [_this, "HIDE_BLACKLIST_MARKERS", true] call ENGIMA_CIVILIANS_GetParamValue;
	private _fnc_OnSpawningCallback = [_this, "ON_UNIT_SPAWNING_CALLBACK", { true }] call ENGIMA_CIVILIANS_GetParamValue;
	private _fnc_OnSpawnedCallback = [_this, "ON_UNIT_SPAWNED_CALLBACK", {}] call ENGIMA_CIVILIANS_GetParamValue;
	private _fnc_OnRemoveCallback = [_this, "ON_UNIT_REMOVE_CALLBACK", { true }] call ENGIMA_CIVILIANS_GetParamValue;
	private _debug = [_this, "DEBUG", false] call ENGIMA_CIVILIANS_GetParamValue;
	private _maxCivilianLifetime = [_this, "MAX_CIVILIAN_LIFETIME", 600] call ENGIMA_CIVILIANS_GetParamValue;

	if (_hideBlacklistMarkers) then {
		{
			_x setMarkerAlpha 0;
		} foreach _blackListMarkers;
	};


	_spawnUnit = {
		params ["_side", "_minSpawnDistance", "_unitClasses", "_playerBuildings", "_blackListMarkers", "_fnc_OnSpawningCallback" , "_fnc_OnSpawnedCallback", "_currentCivilianCount", "_calculatedCivilianCount"];
		private ["_pos", "_unit", "_group"];

		_pos = [_minSpawnDistance, _playerBuildings, _blackListMarkers] call ENGIMA_CIVILIANS_FindSpawnPosition;
		_unit = objNull;

		if (count _pos > 0) then {
            private _classToSpawn = selectRandom _unitClasses;
            private _spawnArgs = [_classToSpawn, _pos];
            private _spawnOk = [_spawnArgs, _currentCivilianCount, _calculatedCivilianCount] call _fnc_OnSpawningCallback;

            _classToSpawn = _spawnArgs select 0;
            _pos = _spawnArgs select 1;

            if (!isNil "_pos" && { typeName _pos == "ARRAY" } && { _pos isEqualTypeArray [0,0] || _pos isEqualTypeArray [0,0,0] }) then {
                if (!isNil "_spawnOk" && { typeName _spawnOk == "BOOL" } && { _spawnOk }) then {
			_group = createGroup _side;
			_unit = _group createUnit [_classToSpawn, [0, 0, 100], [], random 360, "FORM"];

			ENGIMA_CIVILIANS_GROUP_INSTANCE_NO = ENGIMA_CIVILIANS_GROUP_INSTANCE_NO + 1;
			_unit setVehicleVarName "ENGIMA_CIVILIAN_UNIT_" + str ENGIMA_CIVILIANS_GROUP_INSTANCE_NO;

                    doStop _unit;
                    _unit setPos _pos;

			[_unit, _currentCivilianCount] spawn _fnc_OnSpawnedCallback;
                };
            };
		};

		_unit
	};


	sleep 0.5;

	_civilianItems = [];

	while { true } do {
        private _civilianCount = count _civilianItems;

		private _allPlayers = call ENGIMA_CIVILIANS_GetAllPlayers;
		_allPlayerPositions = _allPlayers apply { position vehicle _x };
		_playerBuildings = [_allPlayerPositions, _maxSpawnDistance, _blackListMarkers] call ENGIMA_CIVILIANS_GetPlayerBuildings;
		_maxUnitsCount = ceil (_unitsPerBuilding * count _playerBuildings);


		if (_maxUnitsCount > _maxGroupsCount) then {
			_maxUnitsCount = _maxGroupsCount;
		};

		if (_civilianCount < _maxUnitsCount && { (count _allPlayerPositions) > 0 }) then {
			private _civilianCountsByPlayer = [];
			{
				_civilianCountsByPlayer pushBack 0;
			} foreach _allPlayerPositions;

			{
				private _civilian = _x select 0;
				private _nearestPlayerIndex = -1;
				private _nearestPlayerDistance = 1e10;

				{
					private _distance = _x distance _civilian;
					if (_distance < _nearestPlayerDistance) then {
						_nearestPlayerDistance = _distance;
						_nearestPlayerIndex = _forEachIndex;
					};
				} foreach _allPlayerPositions;

				if (_nearestPlayerIndex >= 0) then {
					_civilianCountsByPlayer set [_nearestPlayerIndex, (_civilianCountsByPlayer select _nearestPlayerIndex) + 1];
				};
			} foreach _civilianItems;

			private _spawnPlayerIndex = -1;
			private _spawnPlayerBuildings = [];
			private _activeSides = [];
			{
				private _playerSide = side group _x;
				if !(_playerSide in _activeSides) then {
					_activeSides pushBack _playerSide;
				};
			} foreach _allPlayers;

			private _targetSide = sideUnknown;
			private _lowestSideQuotaFill = 1e10;
			{
				private _candidateSide = _x;
				private _sidePlayerCount = { side group _x isEqualTo _candidateSide } count _allPlayers;
				private _sideCivilianCount = 0;

				{
					if (side group (_allPlayers select _forEachIndex) isEqualTo _candidateSide) then {
						_sideCivilianCount = _sideCivilianCount + _x;
					};
				} forEach _civilianCountsByPlayer;

				private _sideTarget = _maxUnitsCount * _sidePlayerCount / (count _allPlayers);
				private _sideQuotaFill = _sideCivilianCount - _sideTarget;
				if (_sideQuotaFill < _lowestSideQuotaFill) then {
					_lowestSideQuotaFill = _sideQuotaFill;
					_targetSide = _candidateSide;
				};
			} foreach _activeSides;

			{
				private _playerCivilianCount = _civilianCountsByPlayer select _forEachIndex;
				private _playerSide = side group (_allPlayers select _forEachIndex);

				if (_playerSide isEqualTo _targetSide && { _spawnPlayerIndex < 0 || { _playerCivilianCount < (_civilianCountsByPlayer select _spawnPlayerIndex) } }) then {
					private _candidateBuildings = [[_x], _maxSpawnDistance, _blackListMarkers] call ENGIMA_CIVILIANS_GetPlayerBuildings;
					if (count _candidateBuildings > 0) then {
						_spawnPlayerIndex = _forEachIndex;
						_spawnPlayerBuildings = _candidateBuildings;
					};
				};
			} foreach _allPlayerPositions;

			if (_spawnPlayerIndex < 0) then {
				{
					private _playerCivilianCount = _civilianCountsByPlayer select _forEachIndex;

					if (_spawnPlayerIndex < 0 || { _playerCivilianCount < (_civilianCountsByPlayer select _spawnPlayerIndex) }) then {
						private _candidateBuildings = [[_x], _maxSpawnDistance, _blackListMarkers] call ENGIMA_CIVILIANS_GetPlayerBuildings;
						if (count _candidateBuildings > 0) then {
							_spawnPlayerIndex = _forEachIndex;
							_spawnPlayerBuildings = _candidateBuildings;
						};
					};
				} foreach _allPlayerPositions;
			};

			if (_spawnPlayerIndex >= 0) then {
				_unit = [_side, _minSpawnDistance, _unitClasses, _spawnPlayerBuildings, _blackListMarkers, _fnc_OnSpawningCallback, _fnc_OnSpawnedCallback, _civilianCount, _maxUnitsCount] call _spawnUnit;
				if (!isNull _unit) then {
					_unit setSkill _minSkill + random (_maxSkill - _minSkill);

					private _nearestPlayerPos = [];
					private _nearestPlayerDistance = 1e10;
					{
						private _distance = _x distance2D _unit;
						if (_distance < _nearestPlayerDistance) then {
							_nearestPlayerDistance = _distance;
							_nearestPlayerPos = _x;
						};
					} foreach _allPlayerPositions;

					private _initialDestination = [];
					if !(_nearestPlayerPos isEqualTo []) then {
						private _distance = 12 + random 16;
						private _direction = random 360;
						private _candidate = [
							(_nearestPlayerPos select 0) + sin _direction * _distance,
							(_nearestPlayerPos select 1) + cos _direction * _distance,
							0
						];

						if (!surfaceIsWater _candidate && { !([_candidate, _blackListMarkers] call ENGIMA_CIVILIANS_PositionInsideBlackMarker) }) then {
							_initialDestination = _candidate;
							_unit setBehaviour "CARELESS";
							_unit setSpeedMode "LIMITED";
							_unit doMove _initialDestination;
						};
					};

					_civilianItems pushBack [
						_unit,
						"CITIZEN",
						_initialDestination,
						getPos _unit,
						!(_initialDestination isEqualTo []),
						time + 30,
						false,
						time
					];
				};
			};

			sleep 0.1;
		};

		private _civilianItemsToKeep = [];
        {
            private ["_civilian"];
            private ["_keepBecausePlayerNear", "_removeUnit", "_group", "_spawnTime", "_expired"];

            _civilian = _x select 0;
            _keepBecausePlayerNear = false;
            _spawnTime = if (count _x > 7) then { _x select 7 } else { time };
            _expired = (time - _spawnTime) >= _maxCivilianLifetime;

            {
                if (_x distance _civilian < _maxSpawnDistance) then {
                    _keepBecausePlayerNear = true;
                };
            } foreach _allPlayerPositions;

            if (_keepBecausePlayerNear && { !_expired }) then {
                _civilianItemsToKeep pushBack _x;
            }
            else {
                _removeUnit = [_civilian, count _civilianItems] call _fnc_OnRemoveCallback;

                if (isNil "_removeUnit") then {
                    _removeUnit = true;
                };

                if (typeName _removeUnit != "BOOL") then {
                    _removeUnit = true;
                };

                if (!_removeUnit && { !_expired }) then {
                    _civilianItemsToKeep pushBack _x;
                }
                else {
                    _group = group _civilian;
                    [vehicleVarName _civilian] call ENGIMA_CIVILIANS_DeleteDebugMarkerAllClients;
                    deleteVehicle _civilian;
                    deleteGroup _group;
                };
            };

            sleep 0.01;
        } foreach _civilianItems;

		_civilianItems = _civilianItemsToKeep;

		{
			private ["_unit", "_behaviour", "_destinationPos", "_lastPos", "_isMoving", "_nextActionTime", "_isRunning"];
			private ["_destPos"];

			_unit = _x select 0;
			_behaviour = _x select 1;
			_destinationPos = _x select 2;
			_lastPos = _x select 3;
			_isMoving = _x select 4;
			_nextActionTime = _x select 5;
			_isRunning = _x select 6;


			if (_isMoving && _lastPos distance getPos _unit < 1) then {
				_isMoving = false;
				_nextActionTime = time + random ENGIMA_CIVILIANS_MAXWAITINGTIME;

				_x set [4, _isMoving];
				_x set [5, _nextActionTime];

				(group _unit) setFormDir random 360;
			};


			if (!_isMoving && time > _nextActionTime) then {

				_destPos = [_unit, _blackListMarkers, _maxSpawnDistance] call ENGIMA_CIVILIANS_FindDestinationPosition;
				if (count _destPos > 0) then {
					_unit doMove _destPos;
					_unit setBehaviour "CARELESS";

					_destinationPos = _destPos;
					_isMoving = true;
					_isRunning = random 1 < ENGIMA_CIVILIANS_RUNNINGCHANCE;

					_x set [3, _destinationPos];
					_x set [4, _isMoving];
					_x set [6, _isRunning];
				};
			};

			if (_isRunning) then {
				_unit setSpeedMode "NORMAL";
			}
			else {
				_unit setSpeedMode "LIMITED";
			};

			_x set [3, getPos _unit];

			if (_debug) then {
				[vehicleVarName _unit, getPos _unit, "mil_dot", "ColorWhite", "Civ"] call ENGIMA_CIVILIANS_SetDebugMarkerAllClients;
			};

		} foreach _civilianItems;

		sleep 3;
	};
};
