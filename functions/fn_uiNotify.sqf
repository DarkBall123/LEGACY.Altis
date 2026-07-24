/*
 * DZ_fnc_uiNotify
 * Adds a non-blocking notification to the unified HUD and its history.
 */

params
[
    ["_title", "", [""]],
    ["_body", "", [""]],
    ["_kind", "info", [""]],
    ["_duration", 6, [0]]
];

if (!hasInterface) exitWith { false };
if (_title == "" && { _body == "" }) exitWith { false };

private _now = diag_tickTime;
private _queue = uiNamespace getVariable ["DZ_uiNotifications", []];
private _history = uiNamespace getVariable ["DZ_uiNotificationHistory", []];
private _entry = [_now + (_duration max 2), _title, _body, toLower _kind, _now];

private _queueDuplicate = _queue findIf
{
    (_x # 1) == _title
    && { (_x # 2) == _body }
    && { (_x # 3) == toLower _kind }
};

if (_queueDuplicate >= 0) then
{
    _queue set [_queueDuplicate, _entry];
}
else
{
    _queue pushBack _entry;
};

if ((count _queue) > 8) then
{
    _queue deleteRange [0, (count _queue) - 8];
};

private _lastHistory = if (_history isEqualTo []) then
{
    []
}
else
{
    _history # ((count _history) - 1)
};
private _sameAsLast = _lastHistory isNotEqualTo []
    && { (_lastHistory # 1) == _title }
    && { (_lastHistory # 2) == _body }
    && { (_lastHistory # 3) == toLower _kind };

if (_sameAsLast) then
{
    _history set [(count _history) - 1, [_now, _title, _body, toLower _kind]];
}
else
{
    _history pushBack [_now, _title, _body, toLower _kind];
};

if ((count _history) > 40) then
{
    _history deleteRange [0, (count _history) - 40];
};

uiNamespace setVariable ["DZ_uiNotifications", _queue];
uiNamespace setVariable ["DZ_uiNotificationHistory", _history];

true
