/*
	missionConfigFile >> "PiG_RscRedeployMenu"
*/

class PiG_RscRedeployMenu
{
	idd = 8800;
	movingEnable = false;
    controlsBackground[] = {};
	onLoad = "(_this # 0) setVariable ['PIG_REDEPLOY_MenuOpened', true]";
	onUnload = "(_this # 0) setVariable ['PIG_REDEPLOY_MenuOpened', false]";
	class controls
	{
		/*class Redeploy_Background: RedeployMenu_Frame_Base
		{
			idc = -1;
			style = ST_BACKGROUND;

			x = 0.709925 * safezoneW + safezoneX;
			y = 0.177928 * safezoneH + safezoneY;
			w = 0.282087 * safezoneW;
			h = 0.742166 * safezoneH;
			colorBackground[] = COLOR_DARK_BLUE_ALPHA;
		};*/
		class Redeploy_Frame_Map : RedeployMenu_Frame_Base
		{
			idc = -1;
			style = ST_BACKGROUND;
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.191931 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.509112 * safezoneH;
			colorBackground[] = {0.1,0.1,0.1,0.2};
		};
		class Redeploy_Map : RedeployMenu_Map_Base
		{
			idc = 8851;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.788647 * safezoneW + safezoneX;
			y = 0.471994 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.210047 * safezoneH;
		};
		/*class Redeploy_Background_Listbox: RedeployMenu_Frame_Base
		{
			idc = -1;
			style = ST_BACKGROUND;

			x = 0.782087 * safezoneW + safezoneX;
			y = 0.191931 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.266059 * safezoneH;
			colorBackground[] = COLOR_DARK_GRAY;
		};*/
		class Redeploy_Button: RedeployMenu_Button_Base
		{
			idc = 88160;
			action = "";
			colorDisabled[] = COLOR_LIGHTGRAY_ALPHA;
			colorBackgroundDisabled[] = COLOR_LIGHTGRAY_ALPHA;
			colorBackgroundActive[] = COLOR_DARK_GRAY;
			colorFocused[] = COLOR_LIGHTGRAY_ALPHA;

			text = $STR_REDEPLOY_MENU_DEPLOY;
			x = 0.814888 * safezoneW + safezoneX;
			y = 0.710047 * safezoneH + safezoneY;
			w = 0.0852822 * safezoneW;
			h = 0.0420094 * safezoneH;
			colorBackground[] = COLOR_DARK_BLUE_ALPHA;
		};
		class Redeploy_Text_Title: RedeployMenu_Text_Base
		{
			idc = -1;

			text = $STR_REDEPLOY_MENU_TITLE;
			style = ST_CENTER;
			x = 0.782087 * safezoneW + safezoneX;
			y = 0.135919 * safezoneH + safezoneY;
			w = 0.144324 * safezoneW;
			h = 0.0420094 * safezoneH;
			sizeEx = 0.05;
			colorBackground[] = COLOR_DARK_BLUE_ALPHA;
		};
		class Redeploy_Text_Select: RedeployMenu_Text_Base
		{
			idc = -1;

			text = $STR_REDEPLOY_MENU_SELECT;
			style = ST_CENTER;
			x = 0.788647 * safezoneW + safezoneX;
			y = 0.205934 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.0280062 * safezoneH;
			colorBackground[] = COLOR_DARK_BLUE_ALPHA;
			sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
		};
		class Redeploy_ListBox: RedeployMenu_ListBox_Base
		{
			idc = 88210;

			x = 0.788647 * safezoneW + safezoneX;
			y = 0.233941 * safezoneH + safezoneY;
			w = 0.131203 * safezoneW;
			h = 0.210047 * safezoneH;
		}
	}
}