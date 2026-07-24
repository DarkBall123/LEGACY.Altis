/*
 * DZ_fnc_uiRefreshTablet
 * Renders every tablet tab from the latest server snapshot.
 */

disableSerialization;

params [["_forceList", false, [false]]];

private _display = uiNamespace getVariable ["DZ_TabletDisplay", displayNull];
if (isNull _display) exitWith {};

private _snapshot = uiNamespace getVariable ["DZ_uiSnapshot", []];
if (_snapshot isEqualTo []) exitWith
{
    (_display displayCtrl 96021) ctrlSetText "СИНХРОНИЗАЦИЯ";
    (_display displayCtrl 96022) ctrlSetStructuredText parseText "<t color='#93A5A2'>Получение данных полевой сети...</t>";
    (_display displayCtrl 96030) ctrlEnable false;
    (_display displayCtrl 96031) ctrlEnable false;
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

private _resolvePreviewClass =
{
    params [["_candidates", [], [[]]]];

    private _className = "";
    {
        if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith
        {
            _className = _x;
        };
    } forEach _candidates;

    if (_className == "") exitWith { ["", ""] };
    [
        _className,
        getText (configFile >> "CfgVehicles" >> _className >> "model")
    ]
};

private _previewScaleForClass =
{
    params [["_className", ""]];
    if (_className == "") exitWith { 0.08 };

    switch (true) do
    {
        case (_className isKindOf "Air"):          { 0.027 };
        case (_className isKindOf "Tank"):         { 0.042 };
        case (_className isKindOf "Car"):          { 0.052 };
        case (_className isKindOf "StaticWeapon"): { 0.115 };
        case (_className isKindOf "CAManBase"):    { 0.105 };
        case (_className isKindOf "ReammoBox_F"):  { 0.155 };
        default                                    { 0.155 };
    }
};

_snapshot params
[
    ["_serverTime", 0],
    ["_economy", []],
    ["_mission", []],
    ["_sector", []],
    ["_campaign", []],
    ["_logistics", []],
    ["_fireSupport", []],
    ["_missionCatalog", []]
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
_mission params
[
    ["_missionActive", false],
    ["_activeMissionId", ""],
    ["_activeMissionTitle", ""],
    ["_activeMissionDescription", ""],
    ["_missionSource", ""],
    ["_missionElapsed", 0],
    ["_activeObjective", ""],
    ["_activeProgress", 0],
    ["_activeProgressMax", 1],
    ["_missionDeadline", 0],
    ["_activeRewardMoney", 0],
    ["_activeRewardSupply", 0],
    ["_missionLocation", ""]
];
_sector params
[
    ["_sectorId", -1],
    ["_sectorName", "ВНЕ СЕКТОРА"],
    ["_sectorOwnerKey", "UNKNOWN"],
    ["_sectorOwnerLabel", "Нет данных"],
    ["_sectorStatus", "ВНЕ СЕКТОРА"],
    ["_sectorProgress", 0],
    ["_ourCount", 0],
    ["_enemyCount", 0],
    ["_frontline", false],
    ["_counterattack", false]
];
_campaign params
[
    ["_ownedSectors", 0],
    ["_totalSectors", 1],
    ["_incomePerTick", 0],
    ["_nextIncome", 0],
    ["_nodes", []]
];
_logistics params
[
    ["_baseSupply", 0],
    ["_baseCap", 1],
    ["_spawnCost", 20],
    ["_baseRespawnReady", false],
    ["_containers", []]
];
_fireSupport params
[
    ["_isForwardObserver", false],
    ["_supportRange", 2500],
    ["_supportDelay", 15],
    ["_supportOptions", []]
];

(_display displayCtrl 96004) ctrlSetStructuredText parseText format
[
    "<t color='#F45B1C'>%1₽</t><t color='#586563'>  //  </t><t color='#ECF2F0'>СКЛАД %2/%3</t><t color='#586563'>  //  </t><t color='#ECF2F0'>РЕПУТАЦИЯ %4 (%5)</t><t color='#586563'>  //  </t><t color='#93A5A2'>ПОГОДА: %6</t>",
    _funds,
    _supply,
    _supplyCap,
    (_reputation toFixed 1),
    toUpper _repLabel,
    toUpper _weather
];

private _tab = uiNamespace getVariable ["DZ_uiTabletTab", "overview"];
private _selection = uiNamespace getVariable ["DZ_uiTabletSelection", 0];
private _terminalKind = uiNamespace getVariable ["DZ_uiTerminalKind", "field"];
private _terminalContext = uiNamespace getVariable ["DZ_uiTerminalContext", ""];
private _terminalObject = uiNamespace getVariable ["DZ_uiTerminalObject", objNull];

if (
    _terminalKind != "field"
    && { !isNull _terminalObject }
    && { player distance _terminalObject > 10 }
) exitWith
{
    closeDialog 0;
    ["СВЯЗЬ С ТЕРМИНАЛОМ ПОТЕРЯНА", "Подойдите ближе и откройте интерфейс снова.", "warning", 4] call DZ_fnc_uiNotify;
};

private _list = _display displayCtrl 96020;

{
    private _button = _display displayCtrl (_x # 0);
    private _selected = (_x # 1) == _tab;
    _button ctrlSetBackgroundColor ([ [0.035, 0.047, 0.052, 0.90], [0.76, 0.22, 0.07, 1] ] select _selected);
} forEach
[
    [96010, "overview"],
    [96011, "operations"],
    [96012, "front"],
    [96013, "logistics"],
    [96014, "support"],
    [96015, "store"]
];

private _history = uiNamespace getVariable ["DZ_uiNotificationHistory", []];
private _storeCatalog = if (_terminalKind == "store") then
{
    [_terminalContext] call DZ_fnc_getStoreCatalog
}
else
{
    []
};

private _sourceCount = switch (_tab) do
{
    case "overview":   { count _history };
    case "operations": { count _missionCatalog };
    case "front":      { count _nodes };
    case "logistics":  { 1 + count _containers };
    case "support":    { count _supportOptions };
    case "store":      { count _storeCatalog };
    default            { 0 };
};
private _sourceVersion = switch (_tab) do
{
    case "overview":
    {
        if (_history isEqualTo []) then { 0 } else { (_history # ((count _history) - 1)) # 0 }
    };
    case "front":
    {
        str (_nodes apply { _x # 4 })
    };
    case "logistics":
    {
        str (_containers apply { [_x # 0, _x # 3, _x # 5] })
    };
    default { "" };
};
private _listKey = format ["%1:%2:%3:%4", _tab, _sourceCount, _terminalContext, _sourceVersion];
private _oldListKey = uiNamespace getVariable ["DZ_uiTabletListKey", ""];

if (_forceList || { _oldListKey != _listKey }) then
{
    uiNamespace setVariable ["DZ_uiTabletListUpdating", true];
    lbClear _list;

    switch (_tab) do
    {
        case "overview":
        {
            private _reverseHistory = [];
            for "_i" from ((count _history) - 1) to 0 step -1 do
            {
                _reverseHistory pushBack (_history # _i);
            };
            {
                private _bodyPreview = _x # 2;
                if ((count _bodyPreview) > 34) then
                {
                    _bodyPreview = (_bodyPreview select [0, 31]) + "...";
                };
                private _rowText = toUpper (_x # 1);
                if (_bodyPreview != "") then { _rowText = _rowText + " // " + _bodyPreview; };
                private _idx = _list lbAdd _rowText;
                _list lbSetData [_idx, str _forEachIndex];
            } forEach _reverseHistory;
            if (_reverseHistory isEqualTo []) then { _list lbAdd "ЖУРНАЛ ПУСТ"; };
        };

        case "operations":
        {
            {
                private _idx = _list lbAdd (toUpper (_x # 1));
                _list lbSetData [_idx, _x # 0];
            } forEach _missionCatalog;
        };

        case "front":
        {
            {
                private _ownerKey = _x # 4;
                private _prefix = switch (_ownerKey) do
                {
                    case "EAST": { "● " };
                    case "WEST": { "◆ " };
                    default     { "○ " };
                };
                private _idx = _list lbAdd (_prefix + toUpper (_x # 1));
                _list lbSetData [_idx, _x # 0];
            } forEach _nodes;
            if (_nodes isEqualTo []) then { _list lbAdd "НЕТ РЕСУРСНЫХ ТОЧЕК"; };
        };

        case "logistics":
        {
            private _baseIndex = _list lbAdd "БАЗОВЫЙ СКЛАД";
            _list lbSetData [_baseIndex, "base"];
            {
                private _idx = _list lbAdd format ["%1  //  %2 М", toUpper (_x # 1), _x # 0];
                _list lbSetData [_idx, str (_forEachIndex + 1)];
            } forEach _containers;
        };

        case "support":
        {
            {
                private _idx = _list lbAdd (toUpper (_x # 1));
                _list lbSetData [_idx, _x # 0];
            } forEach _supportOptions;
        };

        case "store":
        {
            {
                private _idx = _list lbAdd format ["%1  //  %2₽", toUpper (_x # 2), _x # 3];
                _list lbSetData [_idx, _x # 1];
            } forEach _storeCatalog;
            if (_storeCatalog isEqualTo []) then { _list lbAdd "КАТАЛОГ НЕДОСТУПЕН"; };
        };
    };

    _selection = (_selection max 0) min (((lbSize _list) - 1) max 0);
    uiNamespace setVariable ["DZ_uiTabletSelection", _selection];
    uiNamespace setVariable ["DZ_uiTabletListKey", _listKey];
    _list lbSetCurSel _selection;
    uiNamespace setVariable ["DZ_uiTabletListUpdating", false];
};

_selection = (lbCurSel _list) max 0;
uiNamespace setVariable ["DZ_uiTabletSelection", _selection];

private _contentTitle = "";
private _content = "";
private _footer = "";
private _progressFraction = 0;
private _progressVisible = true;
private _primaryText = "";
private _primaryVisible = false;
private _primaryEnabled = false;
private _secondaryText = "";
private _secondaryVisible = false;
private _secondaryEnabled = false;
private _mapVisible = _tab in ["overview", "operations", "front", "logistics"];
private _previewVisible = false;
private _previewModel = "";
private _previewClass = "";
private _previewScale = 0.08;
private _previewCaption = "";

switch (_tab) do
{
    case "overview":
    {
        _contentTitle = "ОПЕРАТИВНАЯ СВОДКА";
        private _missionLine = if (_missionActive) then
        {
            format ["<t color='#F45B1C'>%1</t><br/>%2", toUpper _activeMissionTitle, _activeObjective]
        }
        else
        {
            "<t color='#93A5A2'>Активной операции нет. Ожидайте приказа или используйте штабной терминал.</t>"
        };
        private _sectorLine = if (_sectorId >= 0) then
        {
            format ["%1 // %2 // %3", _sectorName, _sectorOwnerLabel, _sectorStatus]
        }
        else
        {
            "Вы находитесь вне активного сектора."
        };
        private _historyIndex = (count _history) - 1 - _selection;
        private _selectedEvent = if (_historyIndex >= 0) then { _history param [_historyIndex, []] } else { [] };
        private _historyLine = if (_selectedEvent isEqualTo []) then
        {
            "<t color='#586563'>Сообщений пока нет.</t>"
        }
        else
        {
            _selectedEvent params ["_eventTime", "_eventTitle", "_eventBody", "_eventKind"];
            format ["<t color='#ECF2F0'>%1</t><br/>%2", toUpper _eventTitle, _eventBody]
        };

        _content = format
        [
            "<t color='#93A5A2' size='0.78'>ТЕКУЩАЯ ОПЕРАЦИЯ</t><br/>%1<br/><br/><t color='#93A5A2' size='0.78'>ТАКТИЧЕСКАЯ ОБСТАНОВКА</t><br/>%2<br/><br/><t color='#93A5A2' size='0.78'>КАМПАНИЯ</t><br/>Под контролем ОКСВ: <t color='#ECF2F0'>%3 из %4 секторов</t><br/>Доход ресурсной сети: <t color='#48D184'>+%5₽</t> каждые 30 минут<br/>Следующее начисление через <t color='#ECF2F0'>%6</t><br/><br/><t color='#93A5A2' size='0.78'>ВЫБРАННОЕ СООБЩЕНИЕ</t><br/>%7",
            _missionLine,
            _sectorLine,
            _ownedSectors,
            _totalSectors,
            _incomePerTick,
            [_nextIncome] call _formatTime,
            _historyLine
        ];
        _progressFraction = _ownedSectors / (_totalSectors max 1);
        _footer = "Левая колонка содержит историю последних сообщений полевой сети.";
        _primaryText = "ОБНОВИТЬ ДАННЫЕ";
        _primaryVisible = true;
        _primaryEnabled = true;

        if (_terminalKind in ["hq", "fob"]) then
        {
            _secondaryText = "ПРОМОТАТЬ НОЧЬ";
            _secondaryVisible = true;
            _secondaryEnabled = true;
        };
    };

    case "operations":
    {
        private _entry = _missionCatalog param [_selection, []];
        if (_entry isEqualTo []) then
        {
            _contentTitle = "ОПЕРАЦИИ";
            _content = "<t color='#93A5A2'>Каталог операций недоступен.</t>";
        }
        else
        {
            _entry params ["_id", "_title", "_description", "_rewardMoney", "_rewardSupply", "_cooldown", "_manualEnabled"];
            private _visualSpec = switch (_id) do
            {
                case "interdiction":
                {
                    [["UK3CB_WEI_B_Hilux_M2", "UK3CB_WEI_B_LR_Softtop_Transport_Open", "O_MRAP_02_hmg_F"], 0.052, "КОНВОЙ ХУНТЫ"]
                };
                case "assassination":
                {
                    [["UK3CB_WEI_B_OFF", "O_officer_F"], 0.105, "ОФИЦЕР ХУНТЫ"]
                };
                case "destroy_cache":
                {
                    [["Box_East_Wps_F", "Box_East_AmmoOrd_F", "Box_East_Support_F", "Land_PaperBox_open_full_F"], 0.155, "СКЛАД ВООРУЖЕНИЯ"]
                };
                case "artillery_hunt":
                {
                    [["UK3CB_WEI_B_2b14_82mm", "RHS_Podnos_MSV", "Mortar_01_F", "I_Mortar_01_F"], 0.115, "МИНОМЁТНАЯ ПОЗИЦИЯ"]
                };
                case "downed_pilot":
                {
                    [["UK3CB_CW_SOV_O_LATE_JET_PILOT", "I_pilot_F", "B_Pilot_F", "C_man_1"], 0.105, "СБИТЫЙ ПИЛОТ"]
                };
                case "humanitarian_aid":
                {
                    [["Land_PaperBox_01_small_closed_brown_food_F", "Land_PaperBox_closed_F"], 0.180, "ГУМАНИТАРНЫЙ ГРУЗ"]
                };
                case "eod":
                {
                    [["IEDLandSmall_F", "IEDLandBig_F", "IEDUrbanSmall_F", "IEDUrbanBig_F"], 0.260, "САМОДЕЛЬНОЕ ВЗРЫВНОЕ УСТРОЙСТВО"]
                };
                case "idap_repair":
                {
                    [["UK3CB_CHC_C_S1203_Amb", "C_Van_01_box_F", "C_Van_01_transport_F", "C_Offroad_01_F"], 0.052, "ТРАНСПОРТ КРАСНОГО КРЕСТА"]
                };
                case "air_defense":
                {
                    [["UK3CB_LDF_I_T810_ZU23", "UK3CB_LDF_I_Igla_AA_pod", "O_APC_Tracked_02_AA_F"], 0.045, "ПОЗИЦИЯ ПВО"]
                };
                case "defend_informant":
                {
                    [["C_man_1", "C_Man_casual_1_F", "C_man_polo_1_F", "C_Man_casual_4_F"], 0.105, "ИНФОРМАТОР"]
                };
                case "heli_intercept":
                {
                    [["rhs_uh1h_hidf_gunship", "O_Heli_Light_02_dynamicLoadout_F"], 0.027, "УДАРНЫЙ ВЕРТОЛЁТ"]
                };
                default
                {
                    [["Land_MapBoard_F"], 0.120, "ОПЕРАЦИОННЫЙ МАКЕТ"]
                };
            };
            _visualSpec params ["_visualClasses", "_visualScale", "_visualLabel"];
            private _resolvedVisual = [_visualClasses] call _resolvePreviewClass;
            _previewClass = _resolvedVisual # 0;
            _previewModel = _resolvedVisual # 1;
            _previewScale = _visualScale;
            _previewCaption = "3D-МАКЕТ // " + _visualLabel;
            _previewVisible = _previewModel != "";

            private _availability = switch (true) do
            {
                case _missionActive:        { "<t color='#FFB938'>ДРУГАЯ ОПЕРАЦИЯ АКТИВНА</t>" };
                case (_cooldown > 0):       { format ["<t color='#FFB938'>ВОССТАНОВЛЕНИЕ %1</t>", [_cooldown] call _formatTime] };
                case (!_manualEnabled):     { "<t color='#F44336'>РУЧНОЙ ЗАПУСК ЗАКРЫТ</t>" };
                default                    { "<t color='#48D184'>ГОТОВО К ЗАПУСКУ</t>" };
            };
            private _activeBlock = if (_missionActive) then
            {
                format
                [
                    "<br/><br/><t color='#93A5A2' size='0.78'>ТЕКУЩАЯ ОПЕРАЦИЯ</t><br/><t color='#F45B1C'>%1</t><br/>%2",
                    toUpper _activeMissionTitle,
                    _activeObjective
                ]
            }
            else
            {
                ""
            };

            _contentTitle = toUpper _title;
            _content = format
            [
                "%1<br/><br/><t color='#93A5A2'>НАГРАДА</t><br/><t color='#ECF2F0'>%2₽</t>  •  <t color='#ECF2F0'>%3 снабжения</t><br/><br/><t color='#93A5A2'>СТАТУС</t><br/>%4%5",
                _description,
                _rewardMoney,
                _rewardSupply,
                _availability,
                _activeBlock
            ];
            _progressFraction = if (_missionActive && { _activeMissionId == _id }) then
            {
                _activeProgress / (_activeProgressMax max 1)
            }
            else
            {
                0
            };
            _footer = if (_terminalKind == "field") then
            {
                "Полевой планшет работает в режиме просмотра. Запуск доступен у ноутбука штаба."
            }
            else
            {
                format ["Канал: %1", toUpper _terminalKind]
            };

            if (_terminalKind == "hq") then
            {
                _primaryText = "НАЧАТЬ ОПЕРАЦИЮ";
                _primaryVisible = true;
                _primaryEnabled = !_missionActive && { _cooldown <= 0 } && { _manualEnabled };
            };
            if (_terminalKind == "fob") then
            {
                _primaryText = "ЗАПРОСИТЬ КОНТРАКТ";
                _primaryVisible = true;
                _primaryEnabled = !_missionActive;
            };
            if (_terminalKind in ["hq", "fob"]) then
            {
                _secondaryText = "ПРЕРВАТЬ ОПЕРАЦИЮ";
                _secondaryVisible = true;
                _secondaryEnabled = _missionActive;
            };
        };
    };

    case "front":
    {
        private _node = _nodes param [_selection, []];
        if (_node isEqualTo []) then
        {
            _contentTitle = "КАРТА ФРОНТА";
            _content = "Ресурсные объекты не зарегистрированы.";
        }
        else
        {
            _node params ["_nodeId", "_nodeName", "_nodeType", "_nodeIncome", "_ownerKey", "_ownerLabel", "_nodePool", "_nodeCap"];
            private _ownerColor = if (_ownerKey == "EAST") then { "#48D184" } else { "#5D8FF0" };
            _contentTitle = toUpper _nodeName;
            _content = format
            [
                "<t color='#93A5A2'>ТИП ОБЪЕКТА</t><br/>%1<br/><br/><t color='#93A5A2'>КОНТРОЛЬ</t><br/><t color='%2'>%3</t><br/><br/><t color='#93A5A2'>ЭКОНОМИКА</t><br/>Доход: <t color='#48D184'>+%4₽</t> за цикл<br/>Накоплено снабжения: <t color='#ECF2F0'>%5/%6</t><br/><br/>Следующий общий расчёт через <t color='#ECF2F0'>%7</t>",
                toUpper _nodeType,
                _ownerColor,
                _ownerLabel,
                _nodeIncome,
                _nodePool,
                _nodeCap,
                [_nextIncome] call _formatTime
            ];
            _progressFraction = _nodePool / (_nodeCap max 1);
        };
        _footer = format ["Территория ОКСВ: %1/%2 секторов. Доход: +%3₽ за цикл.", _ownedSectors, _totalSectors, _incomePerTick];
    };

    case "logistics":
    {
        if (_selection == 0) then
        {
            _contentTitle = "БАЗОВЫЙ СКЛАД";
            private _respawnStatus = if (_baseRespawnReady) then
            {
                "<t color='#48D184'>ВОЗРОЖДЕНИЕ ДОСТУПНО</t>"
            }
            else
            {
                "<t color='#F44336'>ВОЗРОЖДЕНИЕ ПРИОСТАНОВЛЕНО</t>"
            };
            _content = format
            [
                "<t color='#93A5A2'>ЗАПАС</t><br/><t size='1.55' color='#ECF2F0'>%1</t> / %2<br/><br/>%3<br/><br/>Одно возрождение расходует <t color='#F45B1C'>%4 снабжения</t>.<br/>При исчерпании склада базовая точка возрождения автоматически отключается.",
                _baseSupply,
                _baseCap,
                _respawnStatus,
                _spawnCost
            ];
            _progressFraction = _baseSupply / (_baseCap max 1);
        }
        else
        {
            private _container = _containers param [_selection - 1, []];
            if (_container isEqualTo []) then
            {
                _contentTitle = "ЛОГИСТИКА";
                _content = "Контейнер недоступен.";
            }
            else
            {
                _container params ["_distance", "_label", "_kind", "_cargo", "_cargoMax", "_deployed"];
                private _stateText = if (_kind == "kshm") then
                {
                    if (_deployed) then { "<t color='#48D184'>РАЗВЁРНУТА</t>" } else { "<t color='#FFB938'>В ПОХОДНОМ ПОЛОЖЕНИИ</t>" }
                }
                else
                {
                    "МОБИЛЬНЫЙ КОНТЕЙНЕР"
                };
                _contentTitle = toUpper _label;
                _content = format
                [
                    "<t color='#93A5A2'>РАССТОЯНИЕ</t><br/>%1 м<br/><br/><t color='#93A5A2'>СОСТОЯНИЕ</t><br/>%2<br/><br/><t color='#93A5A2'>СНАБЖЕНИЕ</t><br/><t size='1.55'>%3</t> / %4<br/><br/>Погрузка и разгрузка доступны через ACE-взаимодействие с собой рядом с ресурсной точкой или складом.",
                    _distance,
                    _stateText,
                    _cargo,
                    _cargoMax
                ];
                _progressFraction = _cargo / (_cargoMax max 1);
            };
        };
        _footer = "В списке показываются десять ближайших логистических машин.";
    };

    case "support":
    {
        private _option = _supportOptions param [_selection, []];
        if (_option isEqualTo []) then
        {
            _contentTitle = "ОГНЕВАЯ ПОДДЕРЖКА";
            _content = "Канал поддержки недоступен.";
        }
        else
        {
            _option params ["_supportId", "_supportName", "_moneyCost", "_supplyCost", "_cooldown"];
            private _roleStatus = if (_isForwardObserver) then
            {
                "<t color='#48D184'>КОРРЕКТИРОВЩИК ПОДТВЕРЖДЁН</t>"
            }
            else
            {
                "<t color='#F44336'>ТРЕБУЕТСЯ КОРРЕКТИРОВЩИК</t>"
            };
            private _readyStatus = if (_cooldown <= 0) then
            {
                "<t color='#48D184'>БАТАРЕЯ ГОТОВА</t>"
            }
            else
            {
                format ["<t color='#FFB938'>ПЕРЕЗАРЯДКА %1</t>", [_cooldown] call _formatTime]
            };

            _contentTitle = toUpper _supportName;
            _content = format
            [
                "%1<br/><br/>%2<br/><br/><t color='#93A5A2'>ПАРАМЕТРЫ ВЫЗОВА</t><br/>Стоимость: <t color='#ECF2F0'>%3₽ + %4 снаб.</t><br/>Максимальная дальность: <t color='#ECF2F0'>%5 м</t><br/>Подлёт боеприпасов: <t color='#ECF2F0'>~%6 с</t><br/><br/>После подтверждения откроется карта. Одиночный клик указывает цель.",
                _roleStatus,
                _readyStatus,
                _moneyCost,
                _supplyCost,
                _supportRange,
                _supportDelay
            ];
            _progressVisible = false;
            _primaryText = "ПЕРЕЙТИ К ЦЕЛЕУКАЗАНИЮ";
            _primaryVisible = true;
            _primaryEnabled = _isForwardObserver && { _cooldown <= 0 } && { _funds >= _moneyCost } && { _supply >= _supplyCost };
            _footer = "Сервер повторно проверит роль, дальность, бюджет, снабжение и перезарядку.";
        };
        _mapVisible = false;
    };

    case "store":
    {
        private _entry = _storeCatalog param [_selection, []];
        if (_entry isEqualTo []) then
        {
            _contentTitle = "СНАБЖЕНИЕ";
            _content = "Доступных позиций нет. Проверьте набор модификаций сервера.";
        }
        else
        {
            _entry params ["_category", "_itemId", "_displayName", "_moneyCost", "_supplyCost", "_className", "_storeId", "_deliveryPad", "_storeName"];
            private _categoryLabel = switch (_category) do
            {
                case "helos":   { "ВЕРТОЛЁТЫ" };
                case "trucks":  { "ГРУЗОВИКИ" };
                case "armor":   { "БРОНЕТЕХНИКА" };
                case "cars":    { "МАШИНЫ" };
                case "statics": { "СТАТИЧНОЕ ВООРУЖЕНИЕ" };
                default        { toUpper _category };
            };
            private _canAfford = _funds >= _moneyCost && { _supply >= _supplyCost };
            private _affordText = if (_canAfford) then
            {
                "<t color='#48D184'>ЗАКАЗ ДОСТУПЕН</t>"
            }
            else
            {
                "<t color='#F44336'>НЕДОСТАТОЧНО РЕСУРСОВ</t>"
            };
            _contentTitle = toUpper _displayName;
            private _resolvedVisual = [[_className]] call _resolvePreviewClass;
            _previewClass = _resolvedVisual # 0;
            _previewModel = _resolvedVisual # 1;
            _previewScale = [_previewClass] call _previewScaleForClass;
            _previewCaption = "3D-ПРОФИЛЬ // " + _categoryLabel;
            _previewVisible = _previewModel != "";

            private _vehicleCfg = configFile >> "CfgVehicles" >> _className;
            private _maxSpeed = round (getNumber (_vehicleCfg >> "maxSpeed"));
            private _passengers = getNumber (_vehicleCfg >> "transportSoldier");
            private _specLine = format
            [
                "Скорость: <t color='#ECF2F0'>%1 км/ч</t>  •  Пассажиров: <t color='#ECF2F0'>%2</t>",
                _maxSpeed,
                _passengers
            ];

            _content = format
            [
                "<t color='#93A5A2'>КАТЕГОРИЯ</t><br/>%1<br/>%6<br/><br/><t color='#93A5A2'>СТОИМОСТЬ</t><br/><t size='1.45' color='#ECF2F0'>%2₽</t>  +  <t size='1.45' color='#ECF2F0'>%3 снаб.</t><br/><br/>%4<br/><br/><t color='#93A5A2'>КЛАСС ПОСТАВКИ</t><br/><t size='0.82'>%5</t><br/><br/>После подтверждения техника будет создана на площадке выдачи и добавлена в постоянное хранилище кампании.",
                _categoryLabel,
                _moneyCost,
                _supplyCost,
                _affordText,
                _className,
                _specLine
            ];
            _progressFraction = ((_funds / (_moneyCost max 1)) min 1);
            _primaryText = "ПОДТВЕРДИТЬ ЗАКАЗ";
            _primaryVisible = true;
            _primaryEnabled = _canAfford;
            _secondaryText = "ОБНОВИТЬ БАЛАНС";
            _secondaryVisible = true;
            _secondaryEnabled = true;
            _footer = _storeName + " // Цены и класс повторно проверяются сервером.";
        };
        _mapVisible = false;
    };
};

(_display displayCtrl 96021) ctrlSetText _contentTitle;
private _contentControl = _display displayCtrl 96022;
_contentControl ctrlSetStructuredText parseText _content;

private _previewBackground = _display displayCtrl 96025;
private _previewControl = _display displayCtrl 96026;
private _previewCaptionControl = _display displayCtrl 96027;
private _previewAccent = _display displayCtrl 96028;
_previewBackground ctrlShow _previewVisible;
_previewControl ctrlShow _previewVisible;
_previewCaptionControl ctrlShow _previewVisible;
_previewAccent ctrlShow _previewVisible;
_previewControl ctrlSetText "#(argb,1024,512,1)r2t(dzuipreviewrt,1.5)";
_previewCaptionControl ctrlSetText _previewCaption;

if (_previewVisible) then
{
    if (
        (uiNamespace getVariable ["DZ_uiPreviewClass", ""]) != _previewClass
        || { isNull (uiNamespace getVariable ["DZ_uiPreviewObject", objNull]) }
        || { isNull (uiNamespace getVariable ["DZ_uiPreviewCamera", objNull]) }
    ) then
    {
        [_previewClass] call DZ_fnc_uiPreviewSetClass;
    };

    _contentControl ctrlSetPosition
    [
        safeZoneX + 0.365 * safeZoneW,
        safeZoneY + 0.332 * safeZoneH,
        0.280 * safeZoneW,
        0.405 * safeZoneH
    ];
}
else
{
    if ((uiNamespace getVariable ["DZ_uiPreviewClass", ""]) != "") then
    {
        [] call DZ_fnc_uiPreviewDestroy;
    };

    _contentControl ctrlSetPosition
    [
        safeZoneX + 0.365 * safeZoneW,
        safeZoneY + 0.332 * safeZoneH,
        0.510 * safeZoneW,
        0.405 * safeZoneH
    ];
};
_contentControl ctrlCommit 0;

(_display displayCtrl 96023) ctrlShow _progressVisible;
(_display displayCtrl 96023) progressSetPosition ((_progressFraction max 0) min 1);
(_display displayCtrl 96024) ctrlSetStructuredText parseText format ["<t color='#93A5A2'>%1</t>", _footer];

private _primary = _display displayCtrl 96030;
_primary ctrlShow _primaryVisible;
_primary ctrlEnable _primaryEnabled;
_primary ctrlSetText _primaryText;

private _secondary = _display displayCtrl 96031;
_secondary ctrlShow _secondaryVisible;
_secondary ctrlEnable _secondaryEnabled;
_secondary ctrlSetText _secondaryText;

(_display displayCtrl 96032) ctrlShow _mapVisible;
