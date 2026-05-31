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
        ["title", "Перехват конвоя MEF"],
        ["description", "Уничтожить конвой снабжения мальденских оккупационных сил до прибытия в пункт назначения."],
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
        ["title", "Ликвидация офицера MEF"],
        ["description", "Устранить полевого командира MEF и забрать оперативные документы."],
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
        ["title", "Спасти пилота AAF"],
        ["description", "Освободить и эвакуировать сбитого пилота AAF из плена MEF."],
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
        ["title", "Уничтожить склады MEF"],
        ["description", "Найти и уничтожить полевые склады оружия захватчиков в обозначенном районе."],
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
        ["title", "Контрбатарейная борьба"],
        ["description", "Найти и уничтожить миномётную группу MEF, ведущую огонь по мирному поселению."],
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
        ["title", "Доставка гуманитарной помощи"],
        ["description", "Доставить груз IDAP в три отрезанных от снабжения поселения сквозь блокаду MEF."],
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
        ["description", "Найти и обезвредить СВУ на участке дороги, через который проходят гражданские и гуманитарные конвои."],
        ["startFunction", "DZ_fnc_startEodMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "idap_repair",
    createHashMapFromArray
    [
        ["title", "Дозаправка транспорта IDAP"],
        ["description", "Достичь застрявшего автомобиля IDAP, отбить засаду MEF и заправить пустой бак (ACE: канистра или топливозаправщик)."],
        ["startFunction", "DZ_fnc_startIdapVehicleRepairMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "air_defense",
    createHashMapFromArray
    [
        ["title", "Подавление ПВО MEF"],
        ["description", "По названию населённого пункта найти и уничтожить РЛС, ЗАК и ЗРК захватчиков. Воздушное пространство закрыто."],
        ["startFunction", "DZ_fnc_startAirDefenseMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "defend_informant",
    createHashMapFromArray
    [
        ["title", "Прикрытие перебежчика"],
        ["description", "Удержать захваченный сектор с перебежчиком против волн контратаки MEF, затем доставить его на базу. Требуется захваченная территория."],
        ["startFunction", "DZ_fnc_startDefendInformantMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", false],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

[
    "heli_intercept",
    createHashMapFromArray
    [
        ["title", "Воздушный перехват"],
        ["description", "Найти и уничтожить ударный вертолёт MEF, патрулирующий район. Текущее положение отмечено на карте."],
        ["startFunction", "DZ_fnc_startHeliInterceptMission"],
        ["implemented", true],
        ["manualEnabled", true],
        ["randomEnabled", true],
        ["weight", 1],
        ["cooldown", 1800]
    ]
] call _register;

_definitions
