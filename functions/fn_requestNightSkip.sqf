/*
 * DZ_fnc_requestNightSkip
 * Server-side handler for the "skip night" laptop action used by both
 * the APD HQ laptop (west) and Free Altis FOB laptop (resistance).
 *
 * Concurrency model — both sides may press at the same moment:
 *   - In-progress lock prevents two simultaneous requests from
 *     compounding the skip (you wouldn't want both pressing → 48h forward).
 *   - GLOBAL cooldown after a successful skip means whichever side
 *     pressed first wins the window; the other side gets "Подождите".
 *     This is intentional — one skip per cooldown regardless of side.
 *
 * Other gates:
 *   - Only works during the night window (DZ_nightSkipNightStart …
 *     DZ_nightSkipNightEnd).
 *   - Announces to BOTH player sides so neither faction is surprised.
 */

if (!isServer) exitWith {};

params [
    ["_caller", objNull, [objNull]]
];

if (isNull _caller) exitWith {};
if (isRemoteExecuted && { owner _caller != remoteExecutedOwner }) exitWith {};

private _replyTarget = owner _caller;
private _callerSide  = side _caller;

private _factionLabel = switch (true) do {
    case (_callerSide isEqualTo east):       { "ОКСВ" };
    default { str _callerSide };
};

private _cooldown       = missionNamespace getVariable ["DZ_nightSkipCooldown",     1800];
private _lastSkipTime   = missionNamespace getVariable ["DZ_nightSkipLastTime",     -1e9];
private _nightStartHour = missionNamespace getVariable ["DZ_nightSkipNightStart",   20];
private _nightEndHour   = missionNamespace getVariable ["DZ_nightSkipNightEnd",     6];
private _dawnHour       = missionNamespace getVariable ["DZ_nightSkipDawnHour",     6];
private _cost           = missionNamespace getVariable ["DZ_nightSkipCost",         1000];
private _playerSides    = missionNamespace getVariable ["DZ_playerSides",           [west, resistance]];

if ((time - _lastSkipTime) < _cooldown) exitWith {
    private _waitMin = ceil ((_cooldown - (time - _lastSkipTime)) / 60);
    [
        "Штаб",
        format ["Промотка уже выполнялась недавно. Следующая доступна через ~%1 мин.", _waitMin]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

private _now    = date;
_now params ["_y", "_mo", "_d", "_h", "_min"];
private _curHourFloat = _h + (_min / 60);

private _isNight = (_curHourFloat >= _nightStartHour) || (_curHourFloat < _nightEndHour);
if (!_isNight) exitWith {
    [
        "Штаб",
        format ["Сейчас день (%1:%2). Промотка возможна только ночью (после %3:00 или до %4:00).",
            _h, if (_min < 10) then { format ["0%1", _min] } else { str _min },
            _nightStartHour, _nightEndHour]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if !(_callerSide in _playerSides) exitWith {
    ["Штаб", "Эта сторона не имеет общего бюджета."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};
if !([_cost, _callerSide] call DZ_fnc_squadFundsHasEnough) exitWith {
    private _balance = [_callerSide] call DZ_fnc_squadFundsGetBalance;
    [
        "Штаб",
        format ["Недостаточно средств у %1. Цена промотки: %2₽. Баланс: %3₽.",
            _factionLabel, _cost, _balance]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

if (missionNamespace getVariable ["DZ_nightSkipInProgress", false]) exitWith {
    ["Штаб", "Промотка уже выполняется. Подождите."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};
missionNamespace setVariable ["DZ_nightSkipInProgress", true, true];

[(0 - _cost), format ["Night skip by %1", name _caller], _callerSide] call DZ_fnc_squadFundsAdjust;

private _hoursToSkip = if (_curHourFloat >= _nightStartHour) then {

    (24 - _curHourFloat) + _dawnHour
} else {

    _dawnHour - _curHourFloat
};

if (_hoursToSkip <= 0 || { _hoursToSkip > 24 }) exitWith {
    [_cost, format ["Refund: night skip math error (%1h)", _hoursToSkip], _callerSide] call DZ_fnc_squadFundsAdjust;
    missionNamespace setVariable ["DZ_nightSkipInProgress", false, true];
    diag_log format ["[DZ_NIGHTSKIP] Refused (refunded %1₽): computed _hoursToSkip=%2 (curHour=%3, dawnHour=%4, nightStart=%5)",
        _cost, _hoursToSkip, _curHourFloat, _dawnHour, _nightStartHour];
    ["Штаб", "Ошибка расчёта времени. Средства возвращены. Сообщите администратору."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

skipTime _hoursToSkip;

missionNamespace setVariable ["DZ_nightSkipLastTime", time, true];
missionNamespace setVariable ["DZ_nightSkipInProgress", false, true];

diag_log format ["[DZ_NIGHTSKIP] %1 (%2) skipped %3h for %4₽. New time: %5",
    name _caller, _factionLabel, _hoursToSkip toFixed 2, _cost, date];

private _payerBalance = [_callerSide] call DZ_fnc_squadFundsGetBalance;
{
    private _side = _x;
    private _msg = if (_side isEqualTo _callerSide) then {
        format ["[Сервер] %1 промотали ночь за %2₽. Баланс: %3₽. Доброе утро.",
            _factionLabel, _cost, _payerBalance]
    } else {
        format ["[Сервер] %1 промотали ночь. Доброе утро.", _factionLabel]
    };
    [_msg, _side] remoteExecCall ["DZ_fnc_sideMessage", 0];
} forEach _playerSides;
