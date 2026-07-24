/*
 * ChudoYudo unified UI.
 *
 * The HUD intentionally uses separate controls for operations, sector
 * capture, notifications and EW. No subsystem has to compete for the
 * engine's single hintSilent layer anymore.
 */

#define DZ_UI_BG            {0.018, 0.025, 0.030, 0.94}
#define DZ_UI_BG_SOFT       {0.035, 0.047, 0.052, 0.90}
#define DZ_UI_BG_HOVER      {0.075, 0.095, 0.102, 0.96}
#define DZ_UI_TEXT          {0.92, 0.95, 0.94, 1}
#define DZ_UI_MUTED         {0.58, 0.65, 0.64, 1}
#define DZ_UI_ACCENT        {0.95, 0.36, 0.12, 1}
#define DZ_UI_ACCENT_SOFT   {0.95, 0.36, 0.12, 0.22}
#define DZ_UI_GREEN         {0.28, 0.82, 0.52, 1}
#define DZ_UI_AMBER         {1.00, 0.72, 0.22, 1}
#define DZ_UI_RED           {0.96, 0.25, 0.22, 1}

class DZ_UI_Text
{
    access = 0;
    type = 0;
    idc = -1;
    style = 0;
    linespacing = 1;
    colorBackground[] = {0, 0, 0, 0};
    colorText[] = DZ_UI_TEXT;
    text = "";
    shadow = 0;
    font = "PuristaMedium";
    sizeEx = 0.032;
    fixedWidth = 0;
};

class DZ_UI_StructuredText
{
    access = 0;
    type = 13;
    idc = -1;
    style = 0;
    colorBackground[] = {0, 0, 0, 0};
    text = "";
    size = 0.032;
    shadow = 0;
    class Attributes
    {
        font = "PuristaMedium";
        color = "#EBF2F0";
        align = "left";
        valign = "top";
        shadow = 0;
    };
};

class DZ_UI_Button
{
    access = 0;
    type = 1;
    idc = -1;
    style = 2;
    text = "";
    font = "PuristaMedium";
    sizeEx = 0.029;
    shadow = 0;
    borderSize = 0;
    colorText[] = DZ_UI_TEXT;
    colorDisabled[] = {0.35, 0.40, 0.40, 1};
    colorBackground[] = DZ_UI_BG_SOFT;
    colorBackgroundDisabled[] = {0.025, 0.03, 0.035, 0.75};
    colorBackgroundActive[] = DZ_UI_BG_HOVER;
    colorFocused[] = DZ_UI_BG_HOVER;
    colorShadow[] = {0, 0, 0, 0};
    colorBorder[] = {0, 0, 0, 0};
    offsetX = 0;
    offsetY = 0;
    offsetPressedX = 0;
    offsetPressedY = 0;
    soundEnter[] = {"", 0.1, 1};
    soundPush[] = {"", 0.1, 1};
    soundClick[] = {"", 0.1, 1};
    soundEscape[] = {"", 0.1, 1};
};

class DZ_UI_ListBox
{
    access = 0;
    type = 5;
    idc = -1;
    style = 16;
    font = "PuristaMedium";
    sizeEx = 0.031;
    rowHeight = 0.052;
    colorText[] = DZ_UI_TEXT;
    colorScrollbar[] = DZ_UI_MUTED;
    colorDisabled[] = {0.35, 0.40, 0.40, 1};
    colorSelect[] = {1, 1, 1, 1};
    colorSelect2[] = {1, 1, 1, 1};
    colorPicture[] = DZ_UI_TEXT;
    colorPictureSelected[] = {1, 1, 1, 1};
    colorPictureDisabled[] = {0.35, 0.40, 0.40, 1};
    colorBackground[] = DZ_UI_BG_SOFT;
    colorSelectBackground[] = DZ_UI_ACCENT_SOFT;
    colorSelectBackground2[] = DZ_UI_ACCENT_SOFT;
    soundSelect[] = {"", 0.1, 1};
    period = 1;
    maxHistoryDelay = 1;
    autoScrollSpeed = -1;
    autoScrollDelay = 5;
    autoScrollRewind = 0;
    arrowEmpty = "";
    arrowFull = "";
    shadow = 0;
    class ListScrollBar
    {
        color[] = DZ_UI_MUTED;
        colorActive[] = DZ_UI_TEXT;
        colorDisabled[] = {0.20, 0.24, 0.24, 1};
        thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
        arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
        arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
        border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
        autoScrollEnabled = 1;
    };
};

class DZ_UI_Progress
{
    access = 0;
    type = 8;
    idc = -1;
    style = 0;
    colorFrame[] = {0.16, 0.20, 0.21, 1};
    colorBar[] = DZ_UI_ACCENT;
    texture = "#(argb,8,8,3)color(1,1,1,1)";
};

class DZ_UI_Picture
{
    access = 0;
    type = 0;
    idc = -1;
    style = 2096;
    colorBackground[] = {0, 0, 0, 0};
    colorText[] = {1, 1, 1, 1};
    font = "PuristaMedium";
    sizeEx = 0;
    lineSpacing = 0;
    text = "";
    fixedWidth = 0;
    shadow = 0;
};

class RscTitles
{
    class DZ_HUD
    {
        idd = 95100;
        duration = 1e+10;
        fadeIn = 0.2;
        fadeOut = 0.2;
        movingEnable = 0;
        enableSimulation = 1;
        onLoad = "uiNamespace setVariable ['DZ_HudDisplay', _this # 0];";
        onUnload = "uiNamespace setVariable ['DZ_HudDisplay', displayNull];";

        class controls
        {
            class StatusBackground: DZ_UI_Text
            {
                idc = 95101;
                show = 0;
                x = "safeZoneX + 0.018 * safeZoneW";
                y = "safeZoneY + 0.025 * safeZoneH";
                w = "0.320 * safeZoneW";
                h = "0.047 * safeZoneH";
                colorBackground[] = DZ_UI_BG;
            };
            class StatusAccent: DZ_UI_Text
            {
                idc = 95102;
                show = 0;
                x = "safeZoneX + 0.018 * safeZoneW";
                y = "safeZoneY + 0.025 * safeZoneH";
                w = "0.0035 * safeZoneW";
                h = "0.047 * safeZoneH";
                colorBackground[] = DZ_UI_ACCENT;
            };
            class StatusText: DZ_UI_StructuredText
            {
                idc = 95103;
                show = 0;
                x = "safeZoneX + 0.029 * safeZoneW";
                y = "safeZoneY + 0.030 * safeZoneH";
                w = "0.300 * safeZoneW";
                h = "0.038 * safeZoneH";
                size = "0.026 * safeZoneH";
            };

            class MissionBackground: DZ_UI_Text
            {
                idc = 95110;
                x = "safeZoneX + 0.705 * safeZoneW";
                y = "safeZoneY + 0.105 * safeZoneH";
                w = "0.275 * safeZoneW";
                h = "0.158 * safeZoneH";
                colorBackground[] = DZ_UI_BG;
            };
            class MissionAccent: DZ_UI_Text
            {
                idc = 95111;
                x = "safeZoneX + 0.705 * safeZoneW";
                y = "safeZoneY + 0.105 * safeZoneH";
                w = "0.004 * safeZoneW";
                h = "0.158 * safeZoneH";
                colorBackground[] = DZ_UI_ACCENT;
            };
            class MissionKicker: DZ_UI_Text
            {
                idc = 95112;
                text = "АКТИВНАЯ ОПЕРАЦИЯ";
                x = "safeZoneX + 0.720 * safeZoneW";
                y = "safeZoneY + 0.116 * safeZoneH";
                w = "0.24 * safeZoneW";
                h = "0.025 * safeZoneH";
                sizeEx = "0.020 * safeZoneH";
                colorText[] = DZ_UI_ACCENT;
            };
            class MissionTitle: DZ_UI_Text
            {
                idc = 95113;
                x = "safeZoneX + 0.720 * safeZoneW";
                y = "safeZoneY + 0.141 * safeZoneH";
                w = "0.24 * safeZoneW";
                h = "0.032 * safeZoneH";
                sizeEx = "0.026 * safeZoneH";
            };
            class MissionObjective: DZ_UI_StructuredText
            {
                idc = 95114;
                x = "safeZoneX + 0.720 * safeZoneW";
                y = "safeZoneY + 0.175 * safeZoneH";
                w = "0.24 * safeZoneW";
                h = "0.047 * safeZoneH";
                size = "0.021 * safeZoneH";
            };
            class MissionProgress: DZ_UI_Progress
            {
                idc = 95115;
                x = "safeZoneX + 0.720 * safeZoneW";
                y = "safeZoneY + 0.231 * safeZoneH";
                w = "0.145 * safeZoneW";
                h = "0.008 * safeZoneH";
            };
            class MissionProgressText: DZ_UI_Text
            {
                idc = 95116;
                style = 1;
                x = "safeZoneX + 0.872 * safeZoneW";
                y = "safeZoneY + 0.219 * safeZoneH";
                w = "0.088 * safeZoneW";
                h = "0.030 * safeZoneH";
                sizeEx = "0.020 * safeZoneH";
                colorText[] = DZ_UI_MUTED;
            };

            class SectorBackground: DZ_UI_Text
            {
                idc = 95120;
                x = "safeZoneX + 0.355 * safeZoneW";
                y = "safeZoneY + 0.830 * safeZoneH";
                w = "0.290 * safeZoneW";
                h = "0.105 * safeZoneH";
                colorBackground[] = DZ_UI_BG;
            };
            class SectorAccent: DZ_UI_Text
            {
                idc = 95121;
                x = "safeZoneX + 0.355 * safeZoneW";
                y = "safeZoneY + 0.830 * safeZoneH";
                w = "0.290 * safeZoneW";
                h = "0.004 * safeZoneH";
                colorBackground[] = DZ_UI_ACCENT;
            };
            class SectorTitle: DZ_UI_Text
            {
                idc = 95122;
                style = 2;
                x = "safeZoneX + 0.370 * safeZoneW";
                y = "safeZoneY + 0.842 * safeZoneH";
                w = "0.260 * safeZoneW";
                h = "0.030 * safeZoneH";
                sizeEx = "0.025 * safeZoneH";
            };
            class SectorStatus: DZ_UI_StructuredText
            {
                idc = 95123;
                x = "safeZoneX + 0.370 * safeZoneW";
                y = "safeZoneY + 0.873 * safeZoneH";
                w = "0.260 * safeZoneW";
                h = "0.027 * safeZoneH";
                size = "0.020 * safeZoneH";
                class Attributes
                {
                    font = "PuristaMedium";
                    color = "#94A5A3";
                    align = "center";
                    valign = "middle";
                    shadow = 0;
                };
            };
            class SectorProgress: DZ_UI_Progress
            {
                idc = 95124;
                x = "safeZoneX + 0.370 * safeZoneW";
                y = "safeZoneY + 0.906 * safeZoneH";
                w = "0.205 * safeZoneW";
                h = "0.009 * safeZoneH";
            };
            class SectorProgressText: DZ_UI_Text
            {
                idc = 95125;
                style = 1;
                x = "safeZoneX + 0.580 * safeZoneW";
                y = "safeZoneY + 0.894 * safeZoneH";
                w = "0.050 * safeZoneW";
                h = "0.030 * safeZoneH";
                sizeEx = "0.020 * safeZoneH";
                colorText[] = DZ_UI_MUTED;
            };

            class Notification0: DZ_UI_StructuredText
            {
                idc = 95130;
                x = "safeZoneX + 0.350 * safeZoneW";
                y = "safeZoneY + 0.035 * safeZoneH";
                w = "0.300 * safeZoneW";
                h = "0.055 * safeZoneH";
                size = "0.022 * safeZoneH";
                colorBackground[] = DZ_UI_BG;
            };
            class Notification1: Notification0
            {
                idc = 95131;
                y = "safeZoneY + 0.095 * safeZoneH";
            };
            class Notification2: Notification0
            {
                idc = 95132;
                y = "safeZoneY + 0.155 * safeZoneH";
            };

            class EwBackground: DZ_UI_Text
            {
                idc = 95140;
                x = "safeZoneX + 0.018 * safeZoneW";
                y = "safeZoneY + 0.080 * safeZoneH";
                w = "0.178 * safeZoneW";
                h = "0.043 * safeZoneH";
                colorBackground[] = {0.10, 0.025, 0.025, 0.94};
            };
            class EwText: DZ_UI_StructuredText
            {
                idc = 95141;
                x = "safeZoneX + 0.028 * safeZoneW";
                y = "safeZoneY + 0.087 * safeZoneH";
                w = "0.158 * safeZoneW";
                h = "0.031 * safeZoneH";
                size = "0.021 * safeZoneH";
            };
        };
    };
};

class DZ_TabletDisplay
{
    idd = 96000;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "uiNamespace setVariable ['DZ_TabletDisplay', _this # 0]; uiNamespace setVariable ['DZ_uiPreviewKey', '']; [] call DZ_fnc_uiTabletOnLoad;";
    onUnload = "uiNamespace setVariable ['DZ_TabletDisplay', displayNull]; uiNamespace setVariable ['DZ_uiPreviewKey', '']; [] call DZ_fnc_uiPreviewDestroy;";

    class controlsBackground
    {
        class Dim: DZ_UI_Text
        {
            x = "safeZoneX";
            y = "safeZoneY";
            w = "safeZoneW";
            h = "safeZoneH";
            colorBackground[] = {0, 0, 0, 0.72};
        };
        class Body: DZ_UI_Text
        {
            x = "safeZoneX + 0.065 * safeZoneW";
            y = "safeZoneY + 0.055 * safeZoneH";
            w = "0.870 * safeZoneW";
            h = "0.890 * safeZoneH";
            colorBackground[] = DZ_UI_BG;
        };
        class Header: DZ_UI_Text
        {
            x = "safeZoneX + 0.065 * safeZoneW";
            y = "safeZoneY + 0.055 * safeZoneH";
            w = "0.870 * safeZoneW";
            h = "0.078 * safeZoneH";
            colorBackground[] = {0.045, 0.060, 0.064, 1};
        };
        class HeaderAccent: DZ_UI_Text
        {
            x = "safeZoneX + 0.065 * safeZoneW";
            y = "safeZoneY + 0.055 * safeZoneH";
            w = "0.008 * safeZoneW";
            h = "0.078 * safeZoneH";
            colorBackground[] = DZ_UI_ACCENT;
        };
        class SummaryBackground: DZ_UI_Text
        {
            x = "safeZoneX + 0.065 * safeZoneW";
            y = "safeZoneY + 0.133 * safeZoneH";
            w = "0.870 * safeZoneW";
            h = "0.052 * safeZoneH";
            colorBackground[] = {0.025, 0.034, 0.038, 1};
        };
        class ContentBackground: DZ_UI_Text
        {
            x = "safeZoneX + 0.340 * safeZoneW";
            y = "safeZoneY + 0.252 * safeZoneH";
            w = "0.570 * safeZoneW";
            h = "0.570 * safeZoneH";
            colorBackground[] = DZ_UI_BG_SOFT;
        };
        class ContentAccent: DZ_UI_Text
        {
            x = "safeZoneX + 0.340 * safeZoneW";
            y = "safeZoneY + 0.252 * safeZoneH";
            w = "0.004 * safeZoneW";
            h = "0.570 * safeZoneH";
            colorBackground[] = DZ_UI_ACCENT;
        };
        class PreviewBackground: DZ_UI_Text
        {
            idc = 96025;
            show = 0;
            x = "safeZoneX + 0.665 * safeZoneW";
            y = "safeZoneY + 0.342 * safeZoneH";
            w = "0.215 * safeZoneW";
            h = "0.300 * safeZoneH";
            colorBackground[] = {0.010, 0.014, 0.016, 0.98};
        };
        class PreviewAccent: DZ_UI_Text
        {
            idc = 96028;
            show = 0;
            x = "safeZoneX + 0.665 * safeZoneW";
            y = "safeZoneY + 0.342 * safeZoneH";
            w = "0.215 * safeZoneW";
            h = "0.0035 * safeZoneH";
            colorBackground[] = DZ_UI_ACCENT;
        };
    };

    class controls
    {
        class Brand: DZ_UI_Text
        {
            idc = 96001;
            text = "ОКСВ // ПОЛЕВАЯ СЕТЬ";
            x = "safeZoneX + 0.090 * safeZoneW";
            y = "safeZoneY + 0.071 * safeZoneH";
            w = "0.330 * safeZoneW";
            h = "0.045 * safeZoneH";
            sizeEx = "0.031 * safeZoneH";
        };
        class HeaderContext: DZ_UI_Text
        {
            idc = 96002;
            style = 1;
            text = "ТЕРМИНАЛ";
            x = "safeZoneX + 0.575 * safeZoneW";
            y = "safeZoneY + 0.075 * safeZoneH";
            w = "0.285 * safeZoneW";
            h = "0.037 * safeZoneH";
            sizeEx = "0.021 * safeZoneH";
            colorText[] = DZ_UI_MUTED;
        };
        class Close: DZ_UI_Button
        {
            idc = 96003;
            text = "×";
            x = "safeZoneX + 0.875 * safeZoneW";
            y = "safeZoneY + 0.070 * safeZoneH";
            w = "0.038 * safeZoneW";
            h = "0.042 * safeZoneH";
            sizeEx = "0.032 * safeZoneH";
            colorBackground[] = {0.18, 0.045, 0.04, 0.75};
            colorBackgroundActive[] = {0.55, 0.08, 0.05, 1};
            onButtonClick = "closeDialog 0;";
        };
        class Summary: DZ_UI_StructuredText
        {
            idc = 96004;
            x = "safeZoneX + 0.090 * safeZoneW";
            y = "safeZoneY + 0.144 * safeZoneH";
            w = "0.820 * safeZoneW";
            h = "0.032 * safeZoneH";
            size = "0.023 * safeZoneH";
        };

        class TabOverview: DZ_UI_Button
        {
            idc = 96010;
            text = "СВОДКА";
            x = "safeZoneX + 0.090 * safeZoneW";
            y = "safeZoneY + 0.198 * safeZoneH";
            w = "0.130 * safeZoneW";
            h = "0.040 * safeZoneH";
            onButtonClick = "['overview'] call DZ_fnc_uiSetTabletTab;";
        };
        class TabOperations: TabOverview
        {
            idc = 96011;
            text = "ОПЕРАЦИИ";
            x = "safeZoneX + 0.226 * safeZoneW";
            onButtonClick = "['operations'] call DZ_fnc_uiSetTabletTab;";
        };
        class TabFront: TabOverview
        {
            idc = 96012;
            text = "ФРОНТ";
            x = "safeZoneX + 0.362 * safeZoneW";
            onButtonClick = "['front'] call DZ_fnc_uiSetTabletTab;";
        };
        class TabLogistics: TabOverview
        {
            idc = 96013;
            text = "ЛОГИСТИКА";
            x = "safeZoneX + 0.498 * safeZoneW";
            onButtonClick = "['logistics'] call DZ_fnc_uiSetTabletTab;";
        };
        class TabSupport: TabOverview
        {
            idc = 96014;
            text = "ПОДДЕРЖКА";
            x = "safeZoneX + 0.634 * safeZoneW";
            onButtonClick = "['support'] call DZ_fnc_uiSetTabletTab;";
        };
        class TabStore: TabOverview
        {
            idc = 96015;
            text = "СНАБЖЕНИЕ";
            x = "safeZoneX + 0.770 * safeZoneW";
            w = "0.140 * safeZoneW";
            onButtonClick = "['store'] call DZ_fnc_uiSetTabletTab;";
        };

        class ContextList: DZ_UI_ListBox
        {
            idc = 96020;
            x = "safeZoneX + 0.090 * safeZoneW";
            y = "safeZoneY + 0.252 * safeZoneH";
            w = "0.235 * safeZoneW";
            h = "0.570 * safeZoneH";
            onLBSelChanged = "_this call DZ_fnc_uiTabletOnSelect;";
        };
        class ContentTitle: DZ_UI_Text
        {
            idc = 96021;
            x = "safeZoneX + 0.365 * safeZoneW";
            y = "safeZoneY + 0.275 * safeZoneH";
            w = "0.510 * safeZoneW";
            h = "0.048 * safeZoneH";
            sizeEx = "0.032 * safeZoneH";
        };
        class Content: DZ_UI_StructuredText
        {
            idc = 96022;
            x = "safeZoneX + 0.365 * safeZoneW";
            y = "safeZoneY + 0.332 * safeZoneH";
            w = "0.510 * safeZoneW";
            h = "0.405 * safeZoneH";
            size = "0.025 * safeZoneH";
        };
        class PreviewImage: DZ_UI_Picture
        {
            idc = 96026;
            show = 0;
            x = "safeZoneX + 0.675 * safeZoneW";
            y = "safeZoneY + 0.355 * safeZoneH";
            w = "0.195 * safeZoneW";
            h = "0.235 * safeZoneH";
            text = "#(argb,1024,512,1)r2t(dzuipreviewrt,1.5)";
        };
        class PreviewCaption: DZ_UI_Text
        {
            idc = 96027;
            show = 0;
            style = 2;
            x = "safeZoneX + 0.675 * safeZoneW";
            y = "safeZoneY + 0.600 * safeZoneH";
            w = "0.195 * safeZoneW";
            h = "0.030 * safeZoneH";
            sizeEx = "0.019 * safeZoneH";
            colorText[] = DZ_UI_MUTED;
        };
        class ContentProgress: DZ_UI_Progress
        {
            idc = 96023;
            x = "safeZoneX + 0.365 * safeZoneW";
            y = "safeZoneY + 0.758 * safeZoneH";
            w = "0.510 * safeZoneW";
            h = "0.012 * safeZoneH";
        };
        class Footer: DZ_UI_StructuredText
        {
            idc = 96024;
            x = "safeZoneX + 0.365 * safeZoneW";
            y = "safeZoneY + 0.780 * safeZoneH";
            w = "0.510 * safeZoneW";
            h = "0.030 * safeZoneH";
            size = "0.020 * safeZoneH";
        };

        class Primary: DZ_UI_Button
        {
            idc = 96030;
            text = "ВЫПОЛНИТЬ";
            x = "safeZoneX + 0.590 * safeZoneW";
            y = "safeZoneY + 0.846 * safeZoneH";
            w = "0.180 * safeZoneW";
            h = "0.055 * safeZoneH";
            colorBackground[] = {0.76, 0.22, 0.07, 1};
            colorBackgroundActive[] = DZ_UI_ACCENT;
            onButtonClick = "[] call DZ_fnc_uiTabletPrimary;";
        };
        class Secondary: DZ_UI_Button
        {
            idc = 96031;
            text = "ДОПОЛНИТЕЛЬНО";
            x = "safeZoneX + 0.385 * safeZoneW";
            y = "safeZoneY + 0.846 * safeZoneH";
            w = "0.190 * safeZoneW";
            h = "0.055 * safeZoneH";
            onButtonClick = "[] call DZ_fnc_uiTabletSecondary;";
        };
        class OpenMap: DZ_UI_Button
        {
            idc = 96032;
            text = "ОТКРЫТЬ КАРТУ";
            x = "safeZoneX + 0.180 * safeZoneW";
            y = "safeZoneY + 0.846 * safeZoneH";
            w = "0.190 * safeZoneW";
            h = "0.055 * safeZoneH";
            onButtonClick = "closeDialog 0; openMap true;";
        };
    };
};

#undef DZ_UI_BG
#undef DZ_UI_BG_SOFT
#undef DZ_UI_BG_HOVER
#undef DZ_UI_TEXT
#undef DZ_UI_MUTED
#undef DZ_UI_ACCENT
#undef DZ_UI_ACCENT_SOFT
#undef DZ_UI_GREEN
#undef DZ_UI_AMBER
#undef DZ_UI_RED
