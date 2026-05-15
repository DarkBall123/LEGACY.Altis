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


private _catalog = call DZ_fnc_getQuartermasterCatalog;

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
