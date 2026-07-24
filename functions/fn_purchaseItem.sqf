/*
 * DZ_fnc_purchaseItem
 * Validates a quartermaster purchase, deducts from the buyer's faction
 * wallet, and spawns the bought item at the requested delivery pad.
 *
 * Per-side wallets (Wave 2): the buyer's side determines which wallet
 * is charged. Cross-faction purchases are rejected.
 */

if (!isServer) exitWith {};

params [
    ["_itemId",     "",                       [""]],
    ["_class",      "",                       [""]],
    ["_cost",       0,                        [0]],
    ["_supplyCost", 0,                        [0]],
    ["_buyer",      objNull,                  [objNull]],
    ["_padName",    "vehicle_delivery_pad",   [""]],
    ["_shopName",   "Магазин",                [""]],
    ["_terminal",   objNull,                   [objNull]]
];

private _replyTarget = [owner _buyer, 0] select (isNull _buyer);
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [east]];
private _buyerSide   = if (isNull _buyer) then { sideUnknown } else { side _buyer };

if (isRemoteExecuted && { owner _buyer != remoteExecutedOwner }) exitWith {};

private _storeId = switch (_padName) do
{
    case "vehicle_delivery_pad": { "gru" };
    case "cartel_delivery_pad":  { "vdv" };
    default                      { "" };
};

if (
    isRemoteExecuted
    && {
        isNull _terminal
        || { _buyer distance _terminal > 8 }
        || { (_terminal getVariable ["DZ_uiStoreId", ""]) != _storeId }
    }
) exitWith
{
    diag_log format ["[DZ_PURCHASE] Rejected invalid or remote terminal for %1.", name _buyer];
    [_shopName, "Терминал магазина не прошёл проверку. Подойдите к снабженцу."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _catalog = [_storeId] call DZ_fnc_getStoreCatalog;
private _catalogIndex = _catalog findIf { (_x # 1) == _itemId };
if (_catalogIndex < 0) exitWith
{
    diag_log format ["[DZ_PURCHASE] Rejected unknown item '%1' for store '%2'.", _itemId, _storeId];
    [_shopName, "Ошибка проверки каталога. Позиция недоступна."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _validated = _catalog # _catalogIndex;
_validated params
[
    "_category",
    "_validatedId",
    "_displayName",
    "_validatedCost",
    "_validatedSupplyCost",
    "_validatedClass",
    "_validatedStore",
    "_validatedPad",
    "_validatedShop"
];

_itemId = _validatedId;
_class = _validatedClass;
_cost = _validatedCost;
_supplyCost = _validatedSupplyCost;
_padName = _validatedPad;
_shopName = _validatedShop;

if (!isNull _terminal && { _buyer distance _terminal > 8 }) exitWith
{
    [_shopName, "Соединение с терминалом потеряно. Подойдите ближе."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (_class == "") exitWith {
    [_shopName, "Ошибка: предмет не определён."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (!isClass (configFile >> "CfgVehicles" >> _class)) exitWith {
    diag_log format ["[DZ_PURCHASE] Class %1 doesn't exist in config.", _class];
    [_shopName, "Ошибка: эта позиция недоступна в текущем списке."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if !(_buyerSide in _playerSides) exitWith {
    diag_log format ["[DZ_PURCHASE] Rejected — buyer %1 on non-player side %2.", name _buyer, _buyerSide];
    [_shopName, "Ошибка: эта сторона не имеет общего бюджета."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _factionLabel = [_buyerSide] call DZ_fnc_squadFundsSideLabel;

if !([_cost, _buyerSide] call DZ_fnc_squadFundsHasEnough) exitWith {
    private _balance = [_buyerSide] call DZ_fnc_squadFundsGetBalance;
    [
        _shopName,
        format ["Недостаточно средств у %1. Баланс: %2₽. Цена: %3₽.",
            _factionLabel, _balance, _cost]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (_supplyCost > 0 && { !isNil "DZ_fnc_supplyHasEnough" } && { !(["base", _supplyCost] call DZ_fnc_supplyHasEnough) }) exitWith {
    private _haveSup = round (["base"] call DZ_fnc_supplyGet);
    [
        _shopName,
        format ["Машина на складе есть, но не хватает снабжения для снаряжения и доставки. Нужно: %1, на складе базы: %2.",
            _supplyCost, _haveSup]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _padPos = missionNamespace getVariable [_padName, objNull];
if (isNull _padPos) exitWith {
    diag_log format ["[DZ_PURCHASE] Delivery pad '%1' not found in mission.", _padName];
    [
        _shopName,
        "Ошибка: пункт выдачи не настроен. Сообщите администратору."
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _newBalance = [
    (0 - _cost),
    format ["Purchase: %1 by %2 (%3)", _itemId, name _buyer, _factionLabel],
    _buyerSide
] call DZ_fnc_squadFundsAdjust;

private _baseSupplyAfter = -1;
if (_supplyCost > 0 && { !isNil "DZ_fnc_supplyAdjust" }) then {
    _baseSupplyAfter = ["base", 0 - _supplyCost, format ["Purchase prep: %1", _itemId]] call DZ_fnc_supplyAdjust;
};

private _padPosATL = getPosATL _padPos;
private _spawnPos  = _padPosATL vectorAdd [(random 6) - 3, (random 6) - 3, 0];

private _item = createVehicle [_class, _spawnPos, [], 0, "NONE"];
_item setPosATL _spawnPos;
_item setDir (random 360);
_item setDamage 0;

_item setVariable ["DZ_noCleanup", true, true];
_item setVariable ["DZ_purchasedItem", true, true];
_item setVariable ["DZ_purchasedBy", name _buyer, true];
_item setVariable ["DZ_purchasedSide", _buyerSide, true];

[_item] call DZ_fnc_markPersistent;
[true] call DZ_fnc_saveAssets;

diag_log format ["[DZ_PURCHASE] %1 bought by %2 (%3) for %4₽. Spawned at %5. New balance: %6₽.",
    _itemId, name _buyer, _factionLabel, _cost, _spawnPos, _newBalance];

private _supplySuffix = if (_supplyCost > 0) then {
    format [" Снабжение: -%1 (склад базы: %2).", _supplyCost, round _baseSupplyAfter]
} else { "" };

[
    _shopName,
    format ["Покупка совершена: %1. Цена: %2₽. Баланс %3: %4₽.%5 Заказ доставлен на пункт выдачи.",
        _class, _cost, _factionLabel, _newBalance, _supplySuffix]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];

private _supplyTag = if (_supplyCost > 0) then { format [", -%1 снаб.", _supplyCost] } else { "" };

[
    format ["%1 заказал на базу: %2 (-%3₽%4). Баланс %5: %6₽.",
        name _buyer, _itemId, _cost, _supplyTag, _factionLabel, _newBalance],
    _buyerSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];
