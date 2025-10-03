/*
	File: fn_setRedeployPosition.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 16/09/2025
	Updated: 25/09/2025
    License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Set the object as redeploy position for the PIG's redeploy menu
        [this "My Redeploy"] call PIG_fnc_setRedeployPosition

	Parameters:
		_redeployObject - Redeploy object, can be any object / entity [OBJECT, defauls to objNull]
        _redeployName - The name of the redeploy that will show in the redeploy menu [STRING, defaults to ""]

	Return:
		-
*/

params[["_redeployObject", objNull, [objNull]], ["_redeployName", "", [""]]];

if (isNull _redeployObject) exitWith {["[REDEPLOY MENU] Object is null"] call BIS_fnc_error};
if ((_redeployName isEqualTo "") && {isClass(configFile >> "cfgVehicles" >> typeOf _redeployObject)}) then {
    // If no name is given, take the config name
    _redeployName = (getText(ConfigFile >> "cfgVehicles" >> typeOf _redeployObject >> "displayName"));
};

// If it's man, get its name instead (this will overwrite the _redeployName)
if (_redeployObject isKindOf "Man") then {
    _redeployName = name _redeployObject; // Get profile name or the name of the entity if it's an AI
};

if (_redeployName isEqualTo "") then {_redeployName = "<NO NAME>"};

if (isNil "PIG_REDEPLOY_redeployList") then {
    PIG_REDEPLOY_redeployList = [];
    publicVariable "PIG_REDEPLOY_redeployList"
};

PIG_REDEPLOY_redeployList pushBackUnique [_redeployObject, _redeployName];
publicVariable "PIG_REDEPLOY_redeployList";

_redeployObject addEventHandler ["Deleted", {
	params ["_entity"];

	[_entity] call PIG_fnc_removeRedeployPosition;
}];

_redeployObject addEventHandler ["Killed", {
	params ["_entity", "_killer", "_instigator", "_useEffects"];

	[_entity] call PIG_fnc_removeRedeployPosition;
}];

// Update list box
if (!isNil "PIG_REDEPLOY_playerInRedeploy") then {
	[] remoteExecCall ["PIG_fnc_updateRedeployListBox", PIG_REDEPLOY_playerInRedeploy];
};

_redeployObject setVariable ["PIG_REDEPLOY_canSpawn", true, true]