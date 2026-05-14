/*
 * DZ_fnc_initQuartermaster
 *
 * Initializes a Quartermaster NPC at base. Adds an ACE shop menu
 * with categorized items (vehicles, ammo crates, special equipment).
 *
 * Eden setup:
 *   - Place an OPFOR or civilian NPC near the vehicle delivery pad
 *   - Set variable name: quartermaster (or anything else, doesn't matter)
 *   - Init field: [this] call DZ_fnc_initQuartermaster;
 *
 * The shop menu hierarchy:
 *   ACE Main Actions
 *     └─ Магазин снабжения (Supply Shop)
 *          ├─ Баланс: NNNN₽         <- shows current balance
 *          ├─ Транспорт >            <- vehicles category
 *          │    ├─ УАЗ (500₽)
 *          │    ├─ УАЗ с ПКМ (1000₽)
 *          │    └─ ...
 *          ├─ Ящики снабжения >      <- ammo crates category
 *          │    └─ ...
 *          └─ Стационарное оружие >  <- statics category
 *               └─ ...
 */

params [["_npc", objNull, [objNull]]];

if (isNull _npc) exitWith { false };
if (!hasInterface) exitWith { true };
if (_npc getVariable ["dz_quartermaster_added", false]) exitWith { true };
_npc setVariable ["dz_quartermaster_added", true, false];

// Make NPC stand still and not engage
_npc disableAI "MOVE";
_npc disableAI "PATH";
_npc disableAI "AUTOTARGET";
_npc disableAI "TARGET";
_npc disableAI "FSM";
_npc setBehaviour "CARELESS";
_npc allowDamage false;
_npc setCaptive true;

// ── Shop catalog ─────────────────────────────────────────
//
// Each entry: ["category", "id", "Display Name", price, "ClassName"]
// Categories: "vehicles", "crates", "statics"
//
// Class fallback works the same as missions — first-found is used.
// Use arrays of class candidates for cross-modset compatibility.

private _catalog = [
    // ── Vehicles ────────────────────────────────────────
    ["vehicles", "kamaz",           "КАМАЗ (транспортный)",                  500,  ["rhs_kamaz5350_msv"]],
    ["vehicles", "tigr",            "Тигр (бронированный)",                1000, ["RHS_Tigr_MSV", "RHS_Tigr_3camo_msv"]],
    ["vehicles", "btr",             "БТР-70",                              1500, ["RHS_BTR70_MSV", "RHS_BTR60_MSV", "RHS_BTR80_MSV"]],
    ["vehicles", "bmp",             "БМП-2",                               2000, ["RHS_BMP2_MSV", "RHS_BMP1_MSV"]],
    ["vehicles", "tank",            "Т-72",                                2000, ["RHS_T72BA_MSV", "RHS_T72B_TV", "RHS_T80U"]],
    ["vehicles", "heli_transport",  "Ми-8 (ударный)",                 2000, ["RHS_Mi8mt_vmf", "RHS_Mi8MTV3_vvsc"]],
    ["vehicles", "heli_gunship",    "Ми-24 (ударный)",                     2500, ["RHS_Mi24P_vvsc", "RHS_Mi24V_vvsc"]],

    // ── Ammo crates ─────────────────────────────────────
    ["crates",   "crate_medical",   "Медицинский ящик",                     250, ["ACE_medicalSupplyCrate_advanced"]],

    // ── Static weapons ──────────────────────────────────
    ["statics",  "static_mg",       "Станковый пулемёт",                    250, ["RHS_NSV_TriPod_MSV", "RHS_KORD_MSV"]]  
];

// Helper to filter a class candidate array down to the first that exists
private _resolveClass = {
    params ["_candidates"];
    private _result = "";
    {
        if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith { _result = _x; };
    } forEach _candidates;
    _result
};

// ── Top-level "Shop" parent action ───────────────────────
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

// ── Balance display action (no purchase, just info) ──────
private _balanceAction = [
    "DZ_Shop_Balance",
    "Узнать баланс",
    "",
    {
        params ["_target", "_player"];
        private _actualPlayer = ACE_player;
        if (isNull _actualPlayer) then { _actualPlayer = player };
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

// ── Category parent actions ──────────────────────────────
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

// ── Item actions in each category ────────────────────────
{
    _x params ["_category", "_itemId", "_displayName", "_price", "_classCandidates"];

    // Resolve class — skip item if no class found in modset
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

                private _actualPlayer = ACE_player;
                if (isNull _actualPlayer) then { _actualPlayer = player };

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
