/*
 * DZ_fnc_uiTick
 * Renders the lightweight HUD from the latest snapshot.
 */

if (!hasInterface) exitWith {};

private _display = uiNamespace getVariable ["DZ_HudDisplay", displayNull];
if (isNull _display) exitWith {};

private _setVisible =
{
    params ["_ids", "_visible"];
    {
        (_display displayCtrl _x) ctrlShow _visible;
    } forEach _ids;
};

private _formatTime =
{
    params [["_seconds", 0]];
    _seconds = round (_seconds max 0);
    private _hours = floor (_seconds / 3600);
    private _minutes = floor ((_seconds mod 3600) / 60);
    private _secs = _seconds mod 60;
    private _minuteText = if (_minutes < 10) then { format ["0%1", _minutes] } else { str _minutes };
    private _secondText = if (_secs < 10) then { format ["0%1", _secs] } else { str _secs };
    if (_hours > 0) exitWith
    {
        format ["%1:%2:%3", _hours, _minuteText, _secondText]
    };
    format ["%1:%2", _minuteText, _secondText]
};

private _snapshot = uiNamespace getVariable ["DZ_uiSnapshot", []];
private _receivedAt = uiNamespace getVariable ["DZ_uiSnapshotReceivedAt", -100];
private _snapshotFresh = _snapshot isNotEqualTo [] && { (diag_tickTime - _receivedAt) < 5 };
private _tabletOpen = !isNull (uiNamespace getVariable ["DZ_TabletDisplay", displayNull]);

// Economy and campaign state live in the tablet; no permanent screen overlay.
[[95101, 95102, 95103], false] call _setVisible;

if (_snapshotFresh) then
{
    _snapshot params
    [
        ["_serverTime", 0],
        ["_economy", []],
        ["_mission", []],
        ["_sector", []]
    ];

    _economy params
    [
        ["_funds", 0],
        ["_supply", 0],
        ["_supplyCap", 1],
        ["_reputation", 50],
        ["_repLabel", "Нет данных"],
        ["_weather", "Нет данных"]
    ];

    (_display displayCtrl 95103) ctrlSetStructuredText parseText format
    [
        "<t color='#F45B1C'>ОКСВ</t><t color='#93A5A2'>  //  </t><t color='#ECF2F0'>%1₽</t><t color='#93A5A2'>  •  </t><t color='#ECF2F0'>%2/%3 снаб.</t><t color='#93A5A2'>  •  %4  •  %5</t>",
        _funds,
        _supply,
        _supplyCap,
        _repLabel,
        _weather
    ];

    _mission params
    [
        ["_active", false],
        ["_missionId", ""],
        ["_title", ""],
        ["_description", ""],
        ["_source", ""],
        ["_elapsedAtSnapshot", 0],
        ["_objective", ""],
        ["_progress", 0],
        ["_progressMax", 1],
        ["_deadline", 0],
        ["_rewardMoney", 0],
        ["_rewardSupply", 0],
        ["_location", ""]
    ];

    private _showMission = _active && { !_tabletOpen };
    [[95110, 95111, 95112, 95113, 95114, 95115, 95116], _showMission] call _setVisible;
    if (_active) then
    {
        private _liveDelta = diag_tickTime - _receivedAt;
        private _elapsed = _elapsedAtSnapshot + _liveDelta;
        private _remaining = if (_deadline > 0) then { (_deadline - (_serverTime + _liveDelta)) max 0 } else { -1 };
        private _timeText = if (_remaining >= 0) then
        {
            format ["ОСТАЛОСЬ %1", [_remaining] call _formatTime]
        }
        else
        {
            format ["В ОПЕРАЦИИ %1", [_elapsed] call _formatTime]
        };

        (_display displayCtrl 95113) ctrlSetText (toUpper _title);
        (_display displayCtrl 95114) ctrlSetStructuredText parseText format
        [
            "<t color='#ECF2F0'>%1</t><br/><t color='#93A5A2'>%2%3</t>",
            _objective,
            _timeText,
            if (_location == "") then { "" } else { format ["  •  КВ. %1", _location] }
        ];

        private _fraction = ((_progress / (_progressMax max 1)) max 0) min 1;
        (_display displayCtrl 95115) progressSetPosition _fraction;
        (_display displayCtrl 95116) ctrlSetText format ["%1 / %2", round _progress, round _progressMax];
    };

    _sector params
    [
        ["_sectorId", -1],
        ["_sectorName", ""],
        ["_ownerKey", "UNKNOWN"],
        ["_ownerLabel", ""],
        ["_sectorStatus", ""],
        ["_captureProgress", 0],
        ["_ourCount", 0],
        ["_enemyCount", 0],
        ["_frontline", false],
        ["_counter", false]
    ];

    private _sectorEventActive = _counter
        || { _ourCount > 0 && { _enemyCount > 0 } }
        || { _sectorStatus find "ЗАХВАТ" >= 0 }
        || { _sectorStatus find "ПЕРЕХВАТ" >= 0 };
    private _showSector = _sectorId >= 0 && { !_tabletOpen } && { _sectorEventActive };
    [[95120, 95121, 95122, 95123, 95124, 95125], _showSector] call _setVisible;

    if (_showSector) then
    {
        private _accent = switch (_ownerKey) do
        {
            case "EAST": { [0.95, 0.25, 0.16, 1] };
            case "WEST": { [0.20, 0.48, 0.95, 1] };
            case "GUER": { [0.28, 0.82, 0.52, 1] };
            default     { [0.55, 0.60, 0.60, 1] };
        };
        if (_counter || { _sectorStatus find "ОСПАР" >= 0 }) then { _accent = [1, 0.65, 0.12, 1]; };

        (_display displayCtrl 95121) ctrlSetBackgroundColor _accent;
        (_display displayCtrl 95122) ctrlSetText _sectorName;
        (_display displayCtrl 95123) ctrlSetStructuredText parseText format
        [
            "<t color='#93A5A2'>%1</t><t color='#586563'>  //  </t><t color='#ECF2F0'>%2</t><t color='#586563'>  //  </t><t color='#93A5A2'>СВОИ %3  ПРОТИВНИК %4</t>",
            _ownerLabel,
            _sectorStatus,
            _ourCount,
            _enemyCount
        ];
        (_display displayCtrl 95124) progressSetPosition _captureProgress;
        (_display displayCtrl 95125) ctrlSetText format ["%1%%", round (_captureProgress * 100)];
    };
}
else
{
    [[95110, 95111, 95112, 95113, 95114, 95115, 95116], false] call _setVisible;
    [[95120, 95121, 95122, 95123, 95124, 95125], false] call _setVisible;
};

private _now = diag_tickTime;
private _notifications = (uiNamespace getVariable ["DZ_uiNotifications", []]) select { (_x # 0) > _now };
uiNamespace setVariable ["DZ_uiNotifications", _notifications];

for "_index" from 0 to 2 do
{
    private _control = _display displayCtrl (95130 + _index);
    private _notificationIndex = (count _notifications) - 1 - _index;
    if (_notificationIndex >= 0 && { !_tabletOpen }) then
    {
        private _entry = _notifications # _notificationIndex;
        _entry params ["_expires", "_title", "_body", "_kind"];
        private _color = switch (_kind) do
        {
            case "success": { "#48D184" };
            case "warning": { "#FFB938" };
            case "error":   { "#F44336" };
            default        { "#F45B1C" };
        };
        _control ctrlShow true;
        _control ctrlSetStructuredText parseText format
        [
            "<t color='%1' size='0.86'>%2</t><br/><t color='#ECF2F0' size='0.78'>%3</t>",
            _color,
            toUpper _title,
            _body
        ];
    }
    else
    {
        _control ctrlShow false;
    };
};

private _ewState = uiNamespace getVariable ["DZ_uiEwState", [0, ""]];
_ewState params [["_ewStrength", 0], ["_ewStatus", ""]];
private _ewVisible = _ewStrength > 0 && { !_tabletOpen };
[[95140, 95141], _ewVisible] call _setVisible;
if (_ewVisible) then
{
    (_display displayCtrl 95141) ctrlSetStructuredText parseText format
    [
        "<t color='#FF5A4E'>РЭБ // %1</t><t color='#C88A84'>  %2%%</t>",
        toUpper _ewStatus,
        round (_ewStrength * 100)
    ];
};

if (!isNull (uiNamespace getVariable ["DZ_TabletDisplay", displayNull])) then
{
    private _lastTabletRefresh = uiNamespace getVariable ["DZ_uiTabletLastRefresh", -1];
    if ((_now - _lastTabletRefresh) > 0.5) then
    {
        uiNamespace setVariable ["DZ_uiTabletLastRefresh", _now];
        [false] call DZ_fnc_uiRefreshTablet;
    };
};
