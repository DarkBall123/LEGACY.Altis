/*
 * DZ_fnc_getMissionDefinitions
 * Builds the registered mission definition table used by manual and random starts.
 */

private _definitions = createHashMap;

private _register =
{
    params ["_id", "_definition"];

    _definition set ["id", _id];
    _definitions set [_id, _definition];
};

[
    "interdiction",
    createHashMapFromArray
    [
        ["title", "Атака на конвой"],
        ["description", "Уничтожить вражеский конвой снабжения до прибытия в пункт назначения."],
        ["startFunction", "DZ_fnc_startInterdictionMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 0]
    ]
] call _register;

[
    "assassination",
    createHashMapFromArray
    [
        ["title", "Убить офицера"],
        ["description", "Ликвидировать полевого командира боевиков и забрать документы."],
        ["startFunction", "DZ_fnc_startAssassinationMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "downed_pilot",
    createHashMapFromArray
    [
        ["title", "Спасти пилота"],
        ["description", "Освободить и эвакуировать сбитого пилота из плена боевиков."],
        ["startFunction", "DZ_fnc_startDownedPilotMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "destroy_cache",
    createHashMapFromArray
    [
        ["title", "Уничтожить тайники"],
        ["description", "Найти и уничтожить тайники с оружием боевиков."],
        ["startFunction", "DZ_fnc_startDestroyCacheMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "artillery_hunt",
    createHashMapFromArray
    [
        ["title", "Уничтожить миномёт"],
        ["description", "Найти и уничтожить миномётную группу, обстреливающую мирную деревню."],
        ["startFunction", "DZ_fnc_startArtilleryHuntMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "humanitarian_aid",
    createHashMapFromArray
    [
        ["title", "Гуманитарная помощь"],
        ["description", "Доставить гуманитарную помощь в три мирные деревни."],
        ["startFunction", "DZ_fnc_startHumanitarianAidMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", false],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "eod",
    createHashMapFromArray
    [
        ["title", "Разминирование маршрута"],
        ["description", "Найти и обезвредить СВУ на участке дороги, используемом мирными конвоями."],
        ["startFunction", "DZ_fnc_startEodMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

_definitions
