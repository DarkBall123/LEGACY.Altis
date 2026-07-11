/*
 * DZ_fnc_initCartel
 * Initializes the СНАБЖЕНИЕ (ВДВ) supply broker. Sells VDV airborne
 * vehicles — helicopters, GAZ-66 trucks, UAZ jeeps. The broker is
 * captive and the trading zone is neutral.
 *
 * Eden setup:
 *   - Place a civilian NPC at the SNAB hub
 *   - Init field: [this] call DZ_fnc_initCartel;
 *   - Place a delivery pad object named `cartel_delivery_pad` nearby
 *     (or skip it — one is auto-created 12m in front of the broker).
 */

params [["_npc", objNull, [objNull]]];

if (isNull _npc) exitWith { false };

if (isServer && { isNull (missionNamespace getVariable ["cartel_delivery_pad", objNull]) }) then {
    private _brokerPos = getPosATL _npc;
    private _brokerDir = getDir _npc;
    private _padPos    = _brokerPos getPos [12, _brokerDir];
    _padPos set [2, 0];

    private _pad = "Land_HelipadEmpty_F" createVehicle _padPos;
    _pad setPosATL _padPos;
    _pad setVariable ["dz_cartel_synth_pad", true, true];

    missionNamespace setVariable ["cartel_delivery_pad", _pad, true];

    diag_log format ["[DZ_CARTEL] Auto-registered cartel_delivery_pad at %1 (12m in front of broker %2)",
        _padPos, _npc];
};

if (!hasInterface) exitWith { true };
if (_npc getVariable ["dz_cartel_added", false]) exitWith { true };
_npc setVariable ["dz_cartel_added", true, false];

_npc disableAI "MOVE";
_npc disableAI "PATH";
_npc disableAI "AUTOTARGET";
_npc disableAI "TARGET";
_npc disableAI "FSM";
_npc setBehaviour "CARELESS";
_npc allowDamage false;
_npc setCaptive true;

private _catalog = [

    ["helos",  "heli_mi8amt",       "Ми-8АМТ",              1500, ["UK3CB_CW_SOW_O_LATE_Mi8AMT", "UK3CB_CW_SOV_O_LATE_Mi8AMT"]],
    ["helos",  "heli_mi8amtsh",     "Ми-8АМТШ",             2500, ["UK3CB_CW_SOV_O_LATE_Mi8AMTSh"]],
    ["helos",  "heli_mi24p",        "Ми-24П",               3500, ["UK3CB_CW_SOV_O_LATE_Mi_24P"]],

    ["trucks", "truck_gaz66_ammo",  "ГАЗ-66 (Боеприпасы)",  1500, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Ammo"]],
    ["trucks", "truck_gaz66_rep",   "ГАЗ-66 (Ремонтный)",   1500, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Repair"]],
    ["trucks", "truck_gaz66_med",   "ГАЗ-66 (Медицинский)", 1000, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Med"]],
    ["trucks", "truck_gaz66_radio", "ГАЗ-66 (Связь)",       1500, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Radio"]],
    ["trucks", "truck_gaz66_open",  "ГАЗ-66 (Открытый)",    1000, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Open"]],

    ["cars",   "car_uaz_open",      "УАЗ-3151 (Открытый)",   600, ["UK3CB_CW_SOV_LATE_VDV_UAZ_Open"]],
    ["cars",   "car_uaz_mg",        "УАЗ-3151 (ДШКМ)",      1000, ["UK3CB_CW_SOV_LATE_VDV_UAZ_MG"]]
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
    "DZ_Cartel",
    "СНАБЖЕНИЕ (ВДВ)",
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
    "DZ_Cartel_Balance",
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

[_npc, 0, ["ACE_MainActions", "DZ_Cartel"], _balanceAction] call ace_interact_menu_fnc_addActionToObject;

private _categoryActions = createHashMap;

{
    _x params ["_categoryId", "_categoryLabel", "_categoryPriority"];
    private _catAction = [
        format ["DZ_Cartel_Cat_%1", _categoryId],
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

    [_npc, 0, ["ACE_MainActions", "DZ_Cartel"], _catAction] call ace_interact_menu_fnc_addActionToObject;
    _categoryActions set [_categoryId, true];
} forEach [
    ["helos",  "Вертолеты", 5],
    ["trucks", "Грузовики", 4],
    ["cars",   "Машины",    3]
];

private _catalogLen = count _catalog;
{
    _x params ["_category", "_itemId", "_displayName", "_price", "_classCandidates"];
    private _itemIndex = _forEachIndex;

    private _resolvedClass = [_classCandidates] call _resolveClass;
    if (_resolvedClass == "") then {
        diag_log format ["[DZ_CARTEL] Skipping item '%1' — no class found in: %2", _itemId, _classCandidates];
    } else {
        private _label = format ["%1 (%2₽)", _displayName, _price];
        private _itemPriority = _catalogLen - _itemIndex;

        private _itemAction = [
            format ["DZ_Cartel_Item_%1", _itemId],
            _label,
            "",
            {
                params ["_target", "_player", "_args"];
                _args params ["_id", "_class", "_cost"];

                private _actualPlayer = [ACE_player, player] select (isNull ACE_player);

                [_id, _class, _cost, _actualPlayer, "cartel_delivery_pad", "СНАБЖЕНИЕ (ВДВ)"]
                    remoteExecCall ["DZ_fnc_purchaseItem", 2];
            },
            { true },
            {},
            [_itemId, _resolvedClass, _price],
            {[0, 0, 1.5]},
            _itemPriority,
            [false, false, true, false, true]
        ] call ace_interact_menu_fnc_createAction;

        private _parentPath = ["ACE_MainActions", "DZ_Cartel", format ["DZ_Cartel_Cat_%1", _category]];
        [_npc, 0, _parentPath, _itemAction] call ace_interact_menu_fnc_addActionToObject;
    };
} forEach _catalog;

diag_log format ["[DZ_CARTEL] SNAB broker initialized: %1 (%2 catalog entries)",
    _npc, count _catalog];

true
