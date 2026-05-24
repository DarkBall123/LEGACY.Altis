/*
 * DZ_fnc_initQuartermaster
 * Adds an ACE supply shop menu to a quartermaster NPC.
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

    ["vehicles", "kamaz",           "КАМАЗ (транспортный)",                  500,  ["rhs_kamaz5350_open_msv"]],
    ["vehicles", "ural_fuel",       "Урал-4320 (бензовоз)",                  500,  ["RHS_Ural_Fuel_MSV_01"]],
    ["vehicles", "ural_repair",     "Урал-4320 (ремонтный)",                 500,  ["RHS_Ural_Repair_MSV_01"]],
    ["vehicles", "tigr",            "Тигр (бронированный)",                1000, ["RHS_Tigr_MSV", "RHS_Tigr_3camo_msv"]],
    ["vehicles", "ural_gantrack",   "Урал-4320 (гантрак)",                  1500, ["RHS_Ural_Zu23_MSV_01"]],
    ["vehicles", "btr",             "БТР-80",                              1500, ["rhs_btr80_msv"]],
    ["vehicles", "bmp",             "БМП-2К",                              2000, ["rhs_bmp2k_msv"]],
    ["vehicles", "heli_transport",  "Ми-8 (транспортный)",                2000, ["RHS_Mi8AMT_vvsc"]],
    ["vehicles", "heli_gunship",    "Ми-24 (ударный)",                     2500, ["SAFP_Mi24VM_RUAF"]],
    ["vehicles", "jet_su25",        "Су-25СМ3 (штурмовик)",                3500, ["FIR_Su25SM3_Camo_VVSVer"]],


    ["crates",   "crate_medical",   "Медицинский ящик",                     250, ["ACE_medicalSupplyCrate_advanced"]],


    ["statics",  "static_mg",       "Станковый пулемёт",                    250, ["rhs_KORD_high_MSV"]],
    ["statics",  "static_spg9",     "СПГ-9М",                               250, ["rhs_SPG9M_MSV"]]
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
    "Магазин снабжения",
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
    5,
    [false, false, true, false, true]
] call ace_interact_menu_fnc_createAction;

[_npc, 0, ["ACE_MainActions", "DZ_Shop"], _balanceAction] call ace_interact_menu_fnc_addActionToObject;


private _categoryActions = createHashMap;

{
    _x params ["_categoryId", "_categoryLabel"];
    private _catAction = [
        format ["DZ_Shop_Cat_%1", _categoryId],
        _categoryLabel,
        "",
        {},
        { true },
        {},
        [],
        {[0, 0, 1.5]},
        5,
        [false, false, true, false, true]
    ] call ace_interact_menu_fnc_createAction;

    [_npc, 0, ["ACE_MainActions", "DZ_Shop"], _catAction] call ace_interact_menu_fnc_addActionToObject;
    _categoryActions set [_categoryId, true];
} forEach [
    ["vehicles", "Транспорт"],
    ["crates",   "Ящики снабжения"],
    ["statics",  "Стационарное оружие"]
];


{
    _x params ["_category", "_itemId", "_displayName", "_price", "_classCandidates"];


    private _resolvedClass = [_classCandidates] call _resolveClass;
    if (_resolvedClass == "") then {
        diag_log format ["[DZ_QM] Skipping item '%1' — no class found in: %2", _itemId, _classCandidates];
    } else {
        private _label = format ["%1 (%2₽)", _displayName, _price];

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
            5,
            [false, false, true, false, true]
        ] call ace_interact_menu_fnc_createAction;

        private _parentPath = ["ACE_MainActions", "DZ_Shop", format ["DZ_Shop_Cat_%1", _category]];
        [_npc, 0, _parentPath, _itemAction] call ace_interact_menu_fnc_addActionToObject;
    };
} forEach _catalog;

diag_log format ["[DZ_QM] Quartermaster initialized: %1 (%2 catalog entries)",
    _npc, count _catalog];

true
