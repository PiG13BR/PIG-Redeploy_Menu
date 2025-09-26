/*
	File: fn_removeRedeployPosition.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 17/09/2025
	Updated: 20/09/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Remove the redeploy position from the main list

	Parameters:
		_redeployObject - Redeploy object that will be removed from the list [OBJECT, defauls to objNull]

	Return:
		-
*/

params[["_redeployObject", objNull, [objNull]]];

if (!isServer) exitWith {};
if (isNull _redeployObject) exitWith {["[REDEPLOY MENU] Object is null"] call BIS_fnc_error};

PIG_REDEPLOY_redeployList deleteAt (PIG_REDEPLOY_redeployList findIf {_x # 0 isEqualTo _redeployObject});
publicVariable "PIG_REDEPLOY_redeployList";

// Update list box
if (!isNil "PIG_REDEPLOY_playerInRedeploy") then {
    [] remoteExecCall ["PIG_fnc_updateRedeployListBox", PIG_REDEPLOY_playerInRedeploy];
};