/*
 * DZ_fnc_initQuartermaster
 * Initializes the СНАБЖЕНИЕ (ГРУ) supply hub. Sells Soviet trucks,
 * armour, cars, and static weapons. The NPC is captive/protected.
 *
 * Eden setup:
 *   - Place a civilian NPC at the hub
 *   - Init field: [this] call DZ_fnc_initQuartermaster;
 *   - Place a `vehicle_delivery_pad`-named object on the apron
 */

params [["_npc", objNull, [objNull]]];

if (isNull _npc) exitWith { false };
_npc setVariable ["DZ_uiStoreId", "gru", true];
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

if (!isNil "DZ_fnc_uiOpenTablet") exitWith
{
    private _terminalAction =
    [
        "DZ_GruStoreTerminal",
        "Открыть терминал снабжения ГРУ",
        "",
        {
            params ["_target"];
            ["store", "store", _target, "gru"] call DZ_fnc_uiOpenTablet;
        },
        { true },
        {},
        [],
        {[0, 0, 1.5]},
        6,
        [false, false, true, false, true]
    ] call ace_interact_menu_fnc_createAction;

    [_npc, 0, ["ACE_MainActions"], _terminalAction] call ace_interact_menu_fnc_addActionToObject;
    true
};

private _catalog = [

    ["trucks",  "qm_maz_refuel",   "МАЗ-543 (Топливный)", 1500, 100, ["UK3CB_CW_SOV_O_LATE_MAZ_543_Refuel"]],
    ["trucks",  "qm_maz_recovery", "МАЗ-543 (Тягач)",     1500, 100, ["UK3CB_CW_SOV_O_LATE_MAZ_543_Recovery"]],

    ["armor",   "qm_brdm2um",      "БРДМ-2УМ",            1500, 120, ["UK3CB_CW_SOV_O_LATE_BRDM2_UM"]],
    ["armor",   "qm_brdm2",        "БРДМ-2",              2000, 150, ["UK3CB_CW_SOV_O_LATE_BRDM2"]],

    ["cars",    "qm_uaz_closed",   "УАЗ-3151 (Крытый)",    600,  40, ["UK3CB_CW_SOV_LATE_UAZ_Closed"]],

    ["statics", "qm_pkm",          "ПКМ",                  250,  20, ["UK3CB_CW_SOV_O_Late_PKM_High"]],
    ["statics", "qm_2b14",         "2Б14 Поднос",          500,  30, ["UK3CB_CW_SOV_O_Late_2b14_82mm"]]
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
    "СНАБЖЕНИЕ (ГРУ)",
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
    ["trucks",  "Грузовики",        5],
    ["armor",   "Бронемашины",      4],
    ["cars",    "Машины",           3],
    ["statics", "Статичное оружие", 2]
];

private _catalogLen = count _catalog;
{
    _x params ["_category", "_itemId", "_displayName", "_price", "_supplyCost", "_classCandidates"];
    private _itemIndex = _forEachIndex;

    private _resolvedClass = [_classCandidates] call _resolveClass;
    if (_resolvedClass == "") then {
        diag_log format ["[DZ_QM] Skipping item '%1' — no class found in: %2", _itemId, _classCandidates];
    } else {
        private _label = format ["%1 (%2₽ + %3 снаб.)", _displayName, _price, _supplyCost];

        private _itemPriority = (_catalogLen - _itemIndex);

        private _itemAction = [
            format ["DZ_Shop_Item_%1", _itemId],
            _label,
            "",
            {
                params ["_target", "_player", "_args"];
                _args params ["_id", "_class", "_cost", "_supplyCost"];

                private _actualPlayer = [ACE_player, player] select (isNull ACE_player);
                [_id, _class, _cost, _supplyCost, _actualPlayer, "vehicle_delivery_pad", "СНАБЖЕНИЕ (ГРУ)", _target]
                    remoteExecCall ["DZ_fnc_purchaseItem", 2];
            },
            { true },
            {},
            [_itemId, _resolvedClass, _price, _supplyCost],
            {[0, 0, 1.5]},
            _itemPriority,
            [false, false, true, false, true]
        ] call ace_interact_menu_fnc_createAction;

        private _parentPath = ["ACE_MainActions", "DZ_Shop", format ["DZ_Shop_Cat_%1", _category]];
        [_npc, 0, _parentPath, _itemAction] call ace_interact_menu_fnc_addActionToObject;
    };
} forEach _catalog;

diag_log format ["[DZ_QM] СНАБЖЕНИЕ (ГРУ) hub initialized: %1 (%2 catalog entries)",
    _npc, count _catalog];

true
