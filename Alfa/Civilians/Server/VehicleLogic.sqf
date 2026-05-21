/*
 * Alfa/Civilians/Server/VehicleLogic.sqf
 * Runs civilian vehicle patrol logic for the Alfa civilian subsystem.
 */

ENGIMA_CIVILIANS_SpawnCivilianVehicle = {
    params ["_pos"];
    private _vehicleClass = selectRandom ENGIMA_CIVILIANS_CIVILIAN_VEHICLE_CLASSES;
    private _road = [_pos, 200] call BIS_fnc_nearestRoad;

    if (!isNull _road) then {
        private _vehicle = createVehicle [_vehicleClass, getPos _road, [], 0, "NONE"];
        _vehicle lock 0;
        _vehicle lockDriver false;
        _vehicle lockCargo false;
        {
            _vehicle lockTurret [_x, false];
        } forEach (allTurrets [_vehicle, true]);

        private _driver = createAgent [selectRandom ENGIMA_CIVILIANS_UNIT_CLASSES, getPos _vehicle, [], 0, "NONE"];
        _driver moveInDriver _vehicle;


        private _group = group _driver;
        [_group, getPos _vehicle, 500] call BIS_fnc_taskPatrol;
    };
};
