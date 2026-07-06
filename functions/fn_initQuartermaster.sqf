/*
 * DZ_fnc_initQuartermaster
 * Initializes the IDAP humanitarian aid hub. The shop offers unarmed
 * humanitarian transport, medical supplies, and utility equipment.
 * Both player factions (APD and Free Altis) may purchase here — the
 * hub is neutral and the NPC is captive/protected.
 *
 * Eden setup:
 *   - Place a civilian NPC (e.g. C_IDAP_Man_AidWorker_*_F) at the hub
 *   - Init field: [this] call DZ_fnc_initQuartermaster;
 *   - Place a `vehicle_delivery_pad`-named object on the apron
 */

params [["_npc", objNull, [objNull]]];

if (isNull _npc) exitWith { false };
if (!hasInterface) exitWith { true };
if (_npc getVariable ["dz_quartermaster_added", false]) exitWith { true };
_npc setVariable ["dz_quartermaster_added", true, false];

_npc disableAI "MOVE";
_npc disableAI "PATH";
_npc disableAI "AUTOTARGET";
_npc disableAI "TARGET";
_npc disableAI "FSM";
_npc setBehaviour "CARELESS";
_npc allowDamage false;
_npc setCaptive true;

private _catalog = [

    ["vehicles",  "veh_quad",          "Квадроцикл",                    500, ["C_Quadbike_01_F"]],
    ["vehicles",  "veh_hilux_med",     "Toyota Hilux (медицинский)",    800, ["UK3CB_C_Hilux_Ambulance"]],
    ["vehicles",  "veh_ural_repair",   "Урал-4320 (ремонтный)",         800, ["UK3CB_C_Ural_Repair"]],
    ["vehicles",  "veh_ural_fuel",     "Урал-4320 (топливный)",         800, ["UK3CB_C_Ural_Fuel"]],
    ["vehicles",  "veh_ural_fortify",  "Урал-4320 (фортификации)",      800, ["rhsgref_cdf_b_ural"]],
    ["vehicles",  "veh_landrover",     "Land Rover (транспортный)",    1000, ["UK3CB_C_LandRover_Softtop_Transport_Open"]],
    ["vehicles",  "veh_tahoe",         "Chevrolet Tahoe",              1400, ["UK3CB_C_SUV"]],
    ["vehicles",  "veh_uh1h",          "UH-1H (транспортный)",         3000, ["UK3CB_C_UH1H"]],

    ["crates",    "crate_medical",     "Ящик с медикаментами",          500, ["ACE_medicalSupplyCrate_advanced"]],

    ["equipment", "equip_searchlight", "Прожектор",                     200, ["UK3CB_UN_B_Searchlight"]],
    ["equipment", "equip_cargo_net",   "Грузовая сеть (коробка)",       250, ["CargoNet_01_box_F"]]
];

private _resolveClass = {
    params ["_candidates"];
    private _result = "";
    {
        if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _result = _x; };
    } forEach _candidates;
    _result
};

private _shopParent = [
    "DZ_Shop",
    "IDAP — Гуманитарная помощь",
    "",
    {},
    { true },
    {},
    [],
    {[0, 0, 1.5]},
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_npc, 0, ["ACE_MainActions"], _shopParent] call ace_interact_menu_fnc_addActionToObject;

private _balanceAction = [
    "DZ_Shop_Balance",
    "Узнать баланс",
    "",
    {
        params ["_target", "_player"];
        private _actualPlayer = [ACE_player, player] select (isNull ACE_player);
        [_actualPlayer] remoteExecCall ["DZ_fnc_squadFundsRequestBalance", 2];
    },
    { true },
    {},
    [],
    {[0, 0, 1.5]},
    6,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_npc, 0, ["ACE_MainActions", "DZ_Shop"], _balanceAction] call ace_interact_menu_fnc_addActionToObject;

private _categoryActions = createHashMap;

{
    _x params ["_categoryId", "_categoryLabel", "_categoryPriority"];
    private _catAction = [
        format ["DZ_Shop_Cat_%1", _categoryId],
        _categoryLabel,
        "",
        {},
        { true },
        {},
        [],
        {[0, 0, 1.5]},
        _categoryPriority,
        [false, false, true, false, true]
    ] call ace_interact_menu_fnc_createAction;

    [_npc, 0, ["ACE_MainActions", "DZ_Shop"], _catAction] call ace_interact_menu_fnc_addActionToObject;
    _categoryActions set [_categoryId, true];
} forEach [
    ["vehicles",  "Транспорт",         5],
    ["crates",    "Медицинские грузы", 4],
    ["equipment", "Оборудование",      3]
];

private _catalogLen = count _catalog;
{
    _x params ["_category", "_itemId", "_displayName", "_price", "_classCandidates"];
    private _itemIndex = _forEachIndex;

    private _resolvedClass = [_classCandidates] call _resolveClass;
    if (_resolvedClass == "") then {
        diag_log format ["[DZ_QM] Skipping item '%1' — no class found in: %2", _itemId, _classCandidates];
    } else {
        private _label = format ["%1 (%2₽)", _displayName, _price];

        private _itemPriority = (_catalogLen - _itemIndex);

        private _itemAction = [
            format ["DZ_Shop_Item_%1", _itemId],
            _label,
            "",
            {
                params ["_target", "_player", "_args"];
                _args params ["_id", "_class", "_cost"];

                private _actualPlayer = [ACE_player, player] select (isNull ACE_player);
                [_id, _class, _cost, _actualPlayer] remoteExecCall ["DZ_fnc_purchaseItem", 2];
            },
            { true },
            {},
            [_itemId, _resolvedClass, _price],
            {[0, 0, 1.5]},
            _itemPriority,
            [false, false, true, false, true]
        ] call ace_interact_menu_fnc_createAction;

        private _parentPath = ["ACE_MainActions", "DZ_Shop", format ["DZ_Shop_Cat_%1", _category]];
        [_npc, 0, _parentPath, _itemAction] call ace_interact_menu_fnc_addActionToObject;
    };
} forEach _catalog;

diag_log format ["[DZ_QM] IDAP humanitarian aid hub initialized: %1 (%2 catalog entries)",
    _npc, count _catalog];

true
