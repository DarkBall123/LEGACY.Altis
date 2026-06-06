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
    case (_callerSide isEqualTo west):       { "APD" };
    case (_callerSide isEqualTo resistance): { "Free Altis" };
    default { str _callerSide };
};

private _cooldown       = missionNamespace getVariable ["DZ_nightSkipCooldown",     1800];  // 30 min cooldown
private _lastSkipTime   = missionNamespace getVariable ["DZ_nightSkipLastTime",     -1e9];
private _nightStartHour = missionNamespace getVariable ["DZ_nightSkipNightStart",   20];    // 20:00 = night begins
private _nightEndHour   = missionNamespace getVariable ["DZ_nightSkipNightEnd",     6];     // 06:00 = night ends
private _dawnHour       = missionNamespace getVariable ["DZ_nightSkipDawnHour",     6];     // skip to 06:00
private _playerSides    = missionNamespace getVariable ["DZ_playerSides",           [west, resistance]];

// ── Gate 1: cooldown ─────────────────────────────────────────────────
if ((time - _lastSkipTime) < _cooldown) exitWith {
    private _waitMin = ceil ((_cooldown - (time - _lastSkipTime)) / 60);
    [
        "Штаб",
        format ["Промотка уже выполнялась недавно. Следующая доступна через ~%1 мин.", _waitMin]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

// ── Gate 2: must be night ────────────────────────────────────────────
private _now    = date;
_now params ["_y", "_mo", "_d", "_h", "_min"];
private _curHourFloat = _h + (_min / 60);

// Night window: hour >= start OR hour < end (wraps across midnight)
private _isNight = (_curHourFloat >= _nightStartHour) || (_curHourFloat < _nightEndHour);
if (!_isNight) exitWith {
    [
        "Штаб",
        format ["Сейчас день (%1:%2). Промотка возможна только ночью (после %3:00 или до %4:00).",
            _h, if (_min < 10) then { format ["0%1", _min] } else { str _min },
            _nightStartHour, _nightEndHour]
    ] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

// ── Gate 3: in-progress lock ─────────────────────────────────────────
if (missionNamespace getVariable ["DZ_nightSkipInProgress", false]) exitWith {
    ["Штаб", "Промотка уже выполняется. Подождите."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};
missionNamespace setVariable ["DZ_nightSkipInProgress", true, true];

// ── Compute hours to skip to reach dawn ──────────────────────────────
private _hoursToSkip = if (_curHourFloat >= _nightStartHour) then {
    // Late night (e.g. 22:00) → skip to next day's 06:00
    (24 - _curHourFloat) + _dawnHour
} else {
    // Early morning (e.g. 03:00) → skip to today's 06:00
    _dawnHour - _curHourFloat
};

// Sanity clamp — shouldn't fire but defensive
if (_hoursToSkip <= 0 || { _hoursToSkip > 24 }) exitWith {
    missionNamespace setVariable ["DZ_nightSkipInProgress", false, true];
    diag_log format ["[DZ_NIGHTSKIP] Refused: computed _hoursToSkip=%1 (curHour=%2, dawnHour=%3, nightStart=%4)",
        _hoursToSkip, _curHourFloat, _dawnHour, _nightStartHour];
    ["Штаб", "Ошибка расчёта времени. Сообщите администратору."] remoteExecCall ["DZ_fnc_showHint", _replyTarget];
};

// ── Do the skip — global, all clients sync via setDate ───────────────
skipTime _hoursToSkip;

// Bookkeeping
missionNamespace setVariable ["DZ_nightSkipLastTime", time, true];
missionNamespace setVariable ["DZ_nightSkipInProgress", false, true];

diag_log format ["[DZ_NIGHTSKIP] %1 (%2) skipped %3h. New time: %4",
    name _caller, _factionLabel, _hoursToSkip toFixed 2, date];

// ── Announce to BOTH sides so neither faction is surprised ───────────
{
    [
        format ["[Сервер] %1 промотали ночь. Доброе утро.", _factionLabel],
        _x
    ] remoteExecCall ["DZ_fnc_sideMessage", 0];
} forEach _playerSides;
