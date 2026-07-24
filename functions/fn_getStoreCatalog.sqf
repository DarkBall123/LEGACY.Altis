/*
 * DZ_fnc_getStoreCatalog
 * Returns a server-authoritative store catalog.
 *
 * Result entries:
 *   [categoryId, itemId, displayName, moneyCost, supplyCost,
 *    resolvedClass, storeId, deliveryPad, storeName]
 */

params [["_storeId", "", [""]]];

private _definition = switch (toLower _storeId) do
{
    case "gru":
    {
        [
            "vehicle_delivery_pad",
            "СНАБЖЕНИЕ (ГРУ)",
            [
                ["trucks",  "qm_maz_refuel",   "МАЗ-543 (Топливный)", 1500, 100, ["UK3CB_CW_SOV_O_LATE_MAZ_543_Refuel"]],
                ["trucks",  "qm_maz_recovery", "МАЗ-543 (Тягач)",     1500, 100, ["UK3CB_CW_SOV_O_LATE_MAZ_543_Recovery"]],
                ["armor",   "qm_brdm2um",      "БРДМ-2УМ",            1500, 120, ["UK3CB_CW_SOV_O_LATE_BRDM2_UM"]],
                ["armor",   "qm_brdm2",        "БРДМ-2",              2000, 150, ["UK3CB_CW_SOV_O_LATE_BRDM2"]],
                ["cars",    "qm_uaz_closed",   "УАЗ-3151 (Крытый)",    600,  40, ["UK3CB_CW_SOV_LATE_UAZ_Closed"]],
                ["statics", "qm_pkm",          "ПКМ",                  250,  20, ["UK3CB_CW_SOV_O_Late_PKM_High"]],
                ["statics", "qm_2b14",         "2Б14 «Поднос»",        500,  30, ["UK3CB_CW_SOV_O_Late_2b14_82mm"]]
            ]
        ]
    };

    case "vdv":
    {
        [
            "cartel_delivery_pad",
            "СНАБЖЕНИЕ (ВДВ)",
            [
                ["helos",  "heli_mi8amt",       "Ми-8АМТ",              1500, 150, ["UK3CB_CW_SOW_O_LATE_Mi8AMT", "UK3CB_CW_SOV_O_LATE_Mi8AMT"]],
                ["helos",  "heli_mi8amtsh",     "Ми-8АМТШ",             2500, 200, ["UK3CB_CW_SOV_O_LATE_Mi8AMTSh"]],
                ["helos",  "heli_mi24p",        "Ми-24П",               3500, 250, ["UK3CB_CW_SOV_O_LATE_Mi_24P"]],
                ["trucks", "truck_gaz66_ammo",  "ГАЗ-66 (Боеприпасы)",  1500, 100, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Ammo"]],
                ["trucks", "truck_gaz66_rep",   "ГАЗ-66 (Ремонтный)",   1500,  80, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Repair"]],
                ["trucks", "truck_gaz66_med",   "ГАЗ-66 (Медицинский)", 1000,  60, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Med"]],
                ["trucks", "truck_gaz66_radio", "ГАЗ-66 (Связь)",       1500,  80, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Radio"]],
                ["trucks", "truck_gaz66_open",  "ГАЗ-66 (Открытый)",    1000,  60, ["UK3CB_CW_SOV_LATE_VDV_Gaz66_Open"]],
                ["cars",   "car_uaz_open",      "УАЗ-3151 (Открытый)",   600,  40, ["UK3CB_CW_SOV_LATE_VDV_UAZ_Open"]],
                ["cars",   "car_uaz_mg",        "УАЗ-3151 (ДШКМ)",      1000,  60, ["UK3CB_CW_SOV_LATE_VDV_UAZ_MG"]]
            ]
        ]
    };

    default { ["", "", []] };
};

_definition params ["_deliveryPad", "_storeName", "_rawCatalog"];

private _result = [];
{
    _x params ["_category", "_itemId", "_displayName", "_price", "_supplyCost", "_classCandidates"];

    private _resolvedClass = "";
    {
        if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith
        {
            _resolvedClass = _x;
        };
    } forEach _classCandidates;

    if (_resolvedClass != "") then
    {
        _result pushBack
        [
            _category,
            _itemId,
            _displayName,
            _price,
            _supplyCost,
            _resolvedClass,
            toLower _storeId,
            _deliveryPad,
            _storeName
        ];
    };
} forEach _rawCatalog;

_result
