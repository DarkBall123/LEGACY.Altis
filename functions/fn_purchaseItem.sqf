/*
 * DZ_fnc_purchaseItem
 * Validates a quartermaster purchase, deducts funds, and spawns the bought item.
 */

if (!isServer) exitWith {};

params [
    ["_itemId", "", [""]],
    ["_class", "", [""]],
    ["_cost", 0, [0]],
    ["_buyer", objNull, [objNull]]
];

private _replyTarget = [owner _buyer, 0] select (isNull _buyer);

if (_class == "") exitWith {
    ["Магазин", "Ошибка: предмет не определён."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (!isClass (configFile >> "CfgVehicles" >> _class)) exitWith {
    diag_log format ["[DZ_PURCHASE] Class %1 doesn't exist in config.", _class];
    ["Магазин", "Ошибка: эта позиция недоступна в текущем списке."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};


if !([_cost] call DZ_fnc_squadFundsHasEnough) exitWith {
    private _balance = missionNamespace getVariable ["DZ_squadFundsBalance", 0];
    [
        "Магазин",
        format ["Недостаточно средств. Баланс: %1₽. Цена: %2₽.", _balance, _cost]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};


private _padPos = missionNamespace getVariable ["vehicle_delivery_pad", objNull];
if (isNull _padPos) exitWith {
    diag_log "[DZ_PURCHASE] vehicle_delivery_pad object not found in mission.";
    [
        "Магазин",
        "Ошибка: пункт выдачи не настроен. Сообщите администратору."
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};


private _newBalance = [(0 - _cost), format ["Purchase: %1 by %2", _itemId, name _buyer]] call DZ_fnc_squadFundsAdjust;


private _padPosATL = getPosATL _padPos;
private _spawnPos = _padPosATL vectorAdd [(random 6) - 3, (random 6) - 3, 0];

private _item = createVehicle [_class, _spawnPos, [], 0, "NONE"];
_item setPosATL _spawnPos;
_item setDir (random 360);
_item setDamage 0;


_item setVariable ["DZ_noCleanup", true, true];
_item setVariable ["DZ_purchasedItem", true, true];
_item setVariable ["DZ_purchasedBy", name _buyer, true];

_item setVariable ["DZ_persist", true, true];
missionNamespace setVariable ["DZ_assetsDirty", true];
[true] call DZ_fnc_saveAssets;

diag_log format ["[DZ_PURCHASE] %1 bought by %2 for %3₽. Spawned at %4. New balance: %5₽.",
    _itemId, name _buyer, _cost, _spawnPos, _newBalance];


[
    "Магазин",
    format ["Покупка совершена: %1. Цена: %2₽. Баланс: %3₽. Заказ доставлен на пункт выдачи.",
        _class, _cost, _newBalance]
] remoteExecCall ["DZ_fnc_showHint", _replyTarget];


[
    format ["%1 заказал на базу: %2 (-%3₽). Баланс: %4₽.",
        name _buyer, _itemId, _cost, _newBalance],
    east
] remoteExecCall ["DZ_fnc_sideMessage", 0];
