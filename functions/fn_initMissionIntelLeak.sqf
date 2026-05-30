/*
 * DZ_fnc_initMissionIntelLeak
 * Wave 4 cross-faction intel leak. When one player faction starts a
 * mission, the OTHER faction gets a vague hint about what their rival
 * is up to. APD's recon spots Free Altis movement; Free Altis's
 * street network whispers what the cops are mobilising for.
 *
 * The leak is intentionally vague — region, not coordinates. It tells
 * the other side "your rivals are busy with X near Y" so they can
 * decide whether to intervene, race them, or let them burn fuel.
 *
 * Listens to the DZ_missionStarted CBA event emitted by
 * fn_prepareMissionState.sqf (signature [_missionId, _source, _title, _side]).
 */

if (!isServer) exitWith {};
if (missionNamespace getVariable ["DZ_missionIntelLeakInitDone", false]) exitWith {};
missionNamespace setVariable ["DZ_missionIntelLeakInitDone", true];

// ── Vague region tag lookup keyed by mission id ──────────────────────
// Each entry is [vague-hint-template] where %1 will be filled with
// the leaking faction's nickname (the "other guys").
private _intelLines = createHashMapFromArray [
    ["interdiction",     "Радиоперехват: %1 разворачивают силы на одной из основных дорог. Возможно, охота на конвой."],
    ["assassination",    "Слухи в порту: %1 ищут одного из офицеров MEF. Кто-то умрёт сегодня."],
    ["destroy_cache",    "Информаторы шепчут: %1 готовят диверсию на складах захватчиков."],
    ["artillery_hunt",   "На частотах MEF — паника. %1, похоже, выдвинулись на контрбатарейную работу."],
    ["downed_pilot",     "Перехват: %1 фиксируют сигнал SOS пилота AAF и собирают спасательную группу."],
    ["humanitarian_aid", "В районе сообщают: %1 двигают конвой IDAP. Гуманитарная миссия."],
    ["eod",              "По дорогам пошёл слух: %1 расчищают мины. Где-то нашли минное поле."],
    ["idap_repair",      "В рации MEF — крик о подкреплении. %1 пытаются прорваться к застрявшей машине IDAP."],
    ["air_defense",      "С радиочастот: %1 готовят удар по объектам ПВО MEF. Скоро будет жарко."],
    ["defend_informant", "Сообщения от местных: %1 кого-то прикрывают в захваченном секторе. Высокая ценность."],
    ["heli_intercept",   "В небе наблюдатель замечает охоту: %1 пытаются сбить вражеский вертолёт."]
];

missionNamespace setVariable ["DZ_missionIntelLeakLines", _intelLines];

["DZ_missionStarted", {
    params [
        ["_missionId", "", [""]],
        ["_source",    "", [""]],
        ["_title",     "", [""]],
        ["_starterSide", sideUnknown]
    ];

    if (_starterSide isEqualTo sideUnknown) exitWith {};

    private _playerSides   = missionNamespace getVariable ["DZ_playerSides", [west, resistance]];
    private _otherSides    = _playerSides - [_starterSide];
    if (_otherSides isEqualTo []) exitWith {};

    private _intelLines    = missionNamespace getVariable ["DZ_missionIntelLeakLines", createHashMap];
    private _template      = _intelLines getOrDefault [_missionId, "%1 что-то затевают. Подробностей нет."];

    // Nickname the LEAKING side from the OTHER side's perspective.
    private _leakerLabel = switch (true) do {
        case (_starterSide isEqualTo west):       { "APD" };
        case (_starterSide isEqualTo resistance): { "силы Свободного Алтиса" };
        default { str _starterSide };
    };

    private _line = format [_template, _leakerLabel];

    {
        private _otherSide  = _x;
        private _otherLabel = [_otherSide] call DZ_fnc_missionSideLabel;
        diag_log format ["[INTEL_LEAK] %1 → %2 hint: %3 / %4 / %5",
            _leakerLabel, _otherLabel, _missionId, _source, _title];

        [
            format ["[Разведка %1] %2", _otherLabel, _line],
            _otherSide
        ] remoteExecCall ["DZ_fnc_sideMessage", 0];
    } forEach _otherSides;
}] call CBA_fnc_addEventHandler;

diag_log "[INTEL_LEAK] Cross-faction mission intel leak initialized.";

true
