ENGIMA_CIVILIANS_SpawnCivilianVehicle = {
    params ["_pos"];
    private _vehicleClass = selectRandom ENGIMA_CIVILIANS_CIVILIAN_VEHICLE_CLASSES;
    private _road = [_pos, 200] call BIS_fnc_nearestRoad;
    
    if (!isNull _road) then {
        private _vehicle = createVehicle [_vehicleClass, getPos _road, [], 0, "NONE"];
        private _driver = createAgent [selectRandom ENGIMA_CIVILIANS_UNIT_CLASSES, getPos _vehicle, [], 0, "NONE"];
        _driver moveInDriver _vehicle;
        
        // Патрулирование по дорогам
        private _group = group _driver;
        [_group, getPos _vehicle, 500] call BIS_fnc_taskPatrol;
    };
};