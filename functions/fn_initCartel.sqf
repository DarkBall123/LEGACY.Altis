/*
 * DZ_fnc_initCartel
 * Initializes the Pyrgos Cartel black-market broker. Smuggles scarce
 * military gear past the MEF blockade — heavy weapons, AT systems,
 * sniper kits, explosives. Both player factions (APD, Free Altis) may
 * purchase here; the trading zone is neutral and the broker is captive
 * (per the cartel "no fighting in the souk" rule).
 *
 * Eden setup:
 *   - Place a civilian NPC (any underworld-looking type, e.g.
 *     C_man_polo_5_F or a CUP/UK3CB criminal) at the cartel hub
 *   - Init field: [this] call DZ_fnc_initCartel;
 *   - Place a delivery pad object named `cartel_delivery_pad` nearby
 *
 * The broker and the pad must be on a different site than the IDAP
 * hub — the cartel zone is supposed to be deep, concealed, and the
 * approach routes are open ground (PvP-friendly).
 */

params [["_npc", objNull, [objNull]]];

if (isNull _npc) exitWith { false };

// ── Server-side: auto-register a synthetic delivery pad if mission.sqm
// doesn't already provide one named `cartel_delivery_pad`. Drops an
// invisible helipad 12m in front of the broker so vehicles bought from
// the Cartel have somewhere to spawn. Broadcast so clients see it.
//
// If the mission designer places an explicit `cartel_delivery_pad` in
// Eden, that one wins (it'll already be set in missionNamespace by
// engine init before this function runs).
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
    // ── Изделия Синдиката (Cartel-made) ────────────────────────────
    ["cartel_made",   "cm_hilux",              "Toyota Hilux",                                            800, ["UK3CB_FIA_I_Offroad"]],
    ["cartel_made",   "cm_hilux_armor",        "Toyota Hilux (с усиленной броней)",                      1400, ["I_Tura_Offroad_armor_lxWS"]],
    ["cartel_made",   "cm_hilux_armor_armed",  "Toyota Hilux (с усиленной броней, вооруженный)",         2000, ["I_Tura_Offroad_armor_armed_lxWS"]],
    ["cartel_made",   "cm_hilux_armor_at",     "Toyota Hilux (с усиленной броней, противотанковый)",     2500, ["I_Tura_Offroad_armor_AT_lxWS"]],
    ["cartel_made",   "cm_hilux_armor_aa",     "Toyota Hilux (с усиленной броней, зенитный)",            3000, ["I_Tura_Offroad_armor_AA_lxWS"]],
    ["cartel_made",   "cm_dshkm_high",         "ДШКМ (высокий)",                                          800, ["UK3CB_AAF_I_DSHKM"]],
    ["cartel_made",   "cm_dshkm_low",          "ДШКМ (низкий)",                                           800, ["UK3CB_AAF_I_DSHkM_Mini_TriPod"]],
    ["cartel_made",   "cm_crate_ak47",         "Ящик с АК-47",                                            500, ["UK3CB_AK47_Equipbox_Indfor"]],
    ["cartel_made",   "cm_crate_m16a3",        "Ящик с М16A3",                                            800, ["UK3CB_M16A3_Equipbox_Blufor"]],
    ["cartel_made",   "cm_crate_svd",          "Ящик с СВД",                                              800, ["UK3CB_SVD_OLD_Equipbox_Opfor"]],
    ["cartel_made",   "cm_crate_launchers",    "Ящик с пусковыми установками",                           5000, ["rhs_launcher_crate"]],
    // ── Трофеи AAF (captured / smuggled stock) ─────────────────────
    ["aaf_captured",  "aaf_landrover_armed",   "Land Rover (вооруженный)",                               1400, ["UK3CB_AAF_I_LR_SF_WMIK_M240_M240"]],
    ["aaf_captured",  "aaf_dingo",             "Динго (МРАП)",                                           1600, ["UK3CB_AAF_B_Dingo"]],
    ["aaf_captured",  "aaf_warrior",           "Вориор (БМП)",                                           5000, ["I_APC_tracked_03_cannon_F"]],
    ["aaf_captured",  "aaf_mh9_benches",       "MH-9 (транспортный, скамейки)",                          3000, ["UK3CB_AAF_B_Benches_MH9"]],
    ["aaf_captured",  "aaf_aw159",             "AW159 (ударный)",                                        5000, ["I_Heli_light_03_dynamicLoadout_Globe"]],
    ["aaf_captured",  "aaf_crate_wps",         "Ящик с основным оружием AAF",                            1000, ["Box_IND_Wps_F"]],
    ["aaf_captured",  "aaf_crate_demo",        "Ящик со взрывчаткой AAF",                                1000, ["Box_IND_AmmoOrd_F"]],
    ["aaf_captured",  "aaf_crate_ammo",        "Ящик с основными боеприпасами AAF",                       100, ["Box_IND_Ammo_F"]]
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
    "Чёрный рынок",
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
    ["cartel_made",  "Товары Синдиката", 5],
    ["aaf_captured", "Трофеи AAF",       4]
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
                // Route delivery to the cartel pad and show the "Чёрный рынок" hint title.
                [_id, _class, _cost, _actualPlayer, "cartel_delivery_pad", "Чёрный рынок"]
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

diag_log format ["[DZ_CARTEL] Pyrgos Cartel broker initialized: %1 (%2 catalog entries)",
    _npc, count _catalog];

true
