/*
	File: fn_updateRedeployListBox.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 17/09/2025
	Updated: 02/10/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Update redeploy's listbox. Remote executed to all clients in the redeploy menu.

	Parameters:
		_forceEH - force lbSelChanged to fire

	Return:
		-
*/

params[["_forceEH", true, [false]]];

if !((findDisplay 8800) getVariable ['PIG_REDEPLOY_MenuOpened', false]) exitWith {};

if ((count PIG_REDEPLOY_redeployList) == 0) exitWith {diag_log str ["[REDEPLOY MENU] No redeploy point provided or not available"]};

private _listBoxCtrl = displayCtrl 88210;

if (lbCurSel _listBoxCtrl == -1) then {
	// Force select the first element of the list box
	_listBoxCtrl lbSetSelected [0, true, _forceEH]
};

_curSelected = lbCurSel _listBoxCtrl;

lbClear _listBoxCtrl;
{
    _x params ["", "_name"];
    _listBoxCtrl lbAdd _name;
	_listBoxCtrl lbSetData [_forEachIndex, _name];
}forEach PIG_REDEPLOY_redeployList;

_listBoxCtrl lbSetSelected [_curSelected, true, _forceEH];

PIG_REDEPLOY_object = (PIG_REDEPLOY_redeployList # (lbCurSel _listBoxCtrl)) # 0;