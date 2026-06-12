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
    ["_itemId",   "",                       [""]],
    ["_class",    "",                       [""]],
    ["_cost",     0,                        [0]],
    ["_buyer",    objNull,                  [objNull]],
    ["_padName",  "vehicle_delivery_pad",   [""]],   // IDAP default; Cartel passes "cartel_delivery_pad"
    ["_shopName", "Магазин",                [""]]    // hint title — "Магазин" / "Чёрный рынок"
];

private _replyTarget = [owner _buyer, 0] select (isNull _buyer);
private _playerSides = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
private _buyerSide   = if (isNull _buyer) then { sideUnknown } else { side _buyer };

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

[
    _shopName,
    format ["Покупка совершена: %1. Цена: %2₽. Баланс %3: %4₽. Заказ доставлен на пункт выдачи.",
        _class, _cost, _factionLabel, _newBalance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];

[
    format ["%1 заказал на базу: %2 (-%3₽). Баланс %4: %5₽.",
        name _buyer, _itemId, _cost, _factionLabel, _newBalance],
    _buyerSide
] remoteExecCall ["DZ_fnc_sideMessage", 0];
