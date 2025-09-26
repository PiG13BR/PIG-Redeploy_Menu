/*
	File: fn_redeployManager.sqf
	Author: PiG13BR (https://github.com/PiG13BR)
	Date: 07/10/2024
	Updated: 25/09/2025
	License: MIT License - http://www.opensource.org/licenses/MIT

	Description:
		Function for handling the redeploy menu. It should run on each client separately.

	Parameters:
		_player - player unit [OBJECT, defaults to player]
		_dist - distance to detect enemies nearby [NUMBER, defaults to 100]

	Return:
		-
*/

createDialog "PiG_RscRedeployMenu";


// On redeploy, don't close dialog with ESC button
_display = findDisplay 2000;
_display displayAddEventHandler ["KeyDown", {(_this # 1) isEqualTo 1}];


params[
	["_player", player, [objNull]],
	["_dist", 100, [0]]
];

#define CAM_DIST 20

// Get player side
PIG_REDEPLOY_iconColor = [1,1,1,1];
switch (side _player) do {
	case west : {
		PIG_REDEPLOY_iconColor = [0, 0.3, 0.6, 1]
	};
	case east : {
		PIG_REDEPLOY_iconColor = [0.5, 0, 0, 1]
	};
	case independent : {
		PIG_REDEPLOY_iconColor = [0, 0.5, 0, 1]
	};
	case civilian : {
		PIG_REDEPLOY_iconColor = [0.4, 0, 0.5, 1]
	}
};

if (PIG_REDEPLOY_redeployList isEqualTo []) exitWith {};

private _redeployMenuDisplay = findDisplay 8800;
private _redeployListBox = displayCtrl 88210;
private _redeployMap = displayCtrl 8851;
private _redeployButton = displayCtrl 88160;
_redeployMenuDisplay setVariable ["PIG_REDEPLOY_playerObject", _player];

if (isNil "PIG_REDEPLOY_playerInRedeploy") then {
	PIG_REDEPLOY_playerInRedeploy = [];
	publicVariable "PIG_REDEPLOY_playerInRedeploy"
};

PIG_REDEPLOY_playerInRedeploy pushBackUnique _player;
publicVariable "PIG_REDEPLOY_playerInRedeploy";

// Create the camera using the player pos
PIG_REDEPLOY_camera = "camera" camCreate (getposATL _player);
camUseNVG false;
showCinemaBorder false;

lbClear _redeployListBox;
{
    _x params ["", "_name"];
    _redeployListBox lbAdd _name;
	_redeployListBox lbSetData [_forEachIndex, _name];
}forEach PIG_REDEPLOY_redeployList;

if (lbCurSel _redeployListBox == -1) then {
	// Force select the first element of the list box
	_redeployListBox lbSetCurSel 0;
};

PIG_REDEPLOY_object = (PIG_REDEPLOY_redeployList # (lbCurSel _redeployListBox)) # 0;
// Map focus
(displayCtrl 8851) ctrlMapAnimAdd [0.7, 0.1, (getPosWorld PIG_REDEPLOY_object) vectorAdd [75, 0, 0]];
ctrlMapAnimCommit (displayCtrl 8851);

// Set camera target
PIG_REDEPLOY_camera camSetTarget PIG_REDEPLOY_object;
PIG_REDEPLOY_camera cameraEffect ["internal","back"];
PIG_REDEPLOY_camera camSetPos [(getpos PIG_REDEPLOY_object # 0) - CAM_DIST , (getpos PIG_REDEPLOY_object # 1) + CAM_DIST , (getpos PIG_REDEPLOY_object # 2) + CAM_DIST ];
PIG_REDEPLOY_camera camcommit 0;
PIG_REDEPLOY_camera camSetPos [(getpos PIG_REDEPLOY_object # 0) - CAM_DIST , (getpos PIG_REDEPLOY_object # 1) - CAM_DIST , (getpos PIG_REDEPLOY_object # 2) + CAM_DIST ];
PIG_REDEPLOY_camera camcommit 60;

_redeployListBox ctrlAddEventHandler ["LBSelChanged", {
	params ["_control", "_lbCurSel", "_lbSelection"];

	PIG_REDEPLOY_object = (PIG_REDEPLOY_redeployList select _lbCurSel) # 0;
	// Map focus
    (displayCtrl 8851) ctrlMapAnimAdd [0.7, 0.1, (getPosWorld PIG_REDEPLOY_object) vectorAdd [75, 0, 0]];
    ctrlMapAnimCommit (displayCtrl 8851);

	// Don't update camera if it's the same object
	//if (_control getVariable ["PIG_REDEPLOY_lastSelRedeploy", objNull] isEqualTo PIG_REDEPLOY_object) exitWith {};
	//_control setVariable ["PIG_REDEPLOY_lastSelRedeploy", PIG_REDEPLOY_object];

	// Set camera target
	PIG_REDEPLOY_camera camSetTarget PIG_REDEPLOY_object;
	PIG_REDEPLOY_camera cameraEffect ["internal","back"];
	PIG_REDEPLOY_camera camSetPos [(getpos PIG_REDEPLOY_object # 0) - CAM_DIST , (getpos PIG_REDEPLOY_object # 1) + CAM_DIST , (getpos PIG_REDEPLOY_object # 2) + CAM_DIST ];
	PIG_REDEPLOY_camera camcommit 0;
	PIG_REDEPLOY_camera camSetPos [(getpos PIG_REDEPLOY_object # 0) - CAM_DIST , (getpos PIG_REDEPLOY_object # 1) - CAM_DIST , (getpos PIG_REDEPLOY_object # 2) + CAM_DIST ];
	PIG_REDEPLOY_camera camcommit 60;
}];

_redeployButton ctrlAddEventHandler ["ButtonClick", {
	params ["_control"];
	private _player = (displayCtrl 8800) getVariable ["PIG_REDEPLOY_playerObject", player];
	
	private _pos = [[[getPosATL PIG_REDEPLOY_object, 10]], [], {(nearestObjects [_this, [], 3, true]) isEqualTo []}] call BIS_fnc_randomPos;
	_player setposATL _pos;
	
	// Modify player's stance if redeploy point is human
	if (PIG_REDEPLOY_object isKindOf "Man") then {
		_stance = unitPos PIG_REDEPLOY_object;
		switch _stance do {
			case "Up" : {
				_player playAction "PlayerStand";
			};
			case "Middle" : {
				_player playAction "PlayerCrouch";
			};
			case "Down" : {
				_player playAction "PlayerProne";
			};
		}
	};
	closeDialog 0;
	
	_player hideObjectGlobal false;
	_player allowDamage true;
	_player enableSimulationGlobal true;
}];

// Loop to check for enemies nearby and update the list
PIG_REDEPLOY_pfhandle = [
	{
		params["_args"];
		_args params ["_dist", "_player"];

		private _redeployButton = displayCtrl 88160;
		// Check for enemies nearby
		if ((PIG_REDEPLOY_object isKindOf "landVehicle") || {PIG_REDEPLOY_object isKindOf "Man"}) then {
		private _nearE = (PIG_REDEPLOY_object nearEntities [["Man","Landvehicle"], _dist]) select {[side _player, side _x] call BIS_fnc_sideIsEnemy}; 

			if ({alive _x} count _nearE >= 1) then {
				PIG_REDEPLOY_object setVariable ["PIG_REDEPLOY_canSpawn", false, true];
				_redeployButton ctrlSetText localize "STR_REDEPLOY_MENU_DEPLOY_NOT_AVAILABLE";
				_redeployButton ctrlEnable false;
			} else {
				PIG_REDEPLOY_object setVariable ["PIG_REDEPLOY_canSpawn", true, true];
				_redeployButton ctrlSetText localize "STR_REDEPLOY_MENU_DEPLOY";
				_redeployButton ctrlEnable true;
			}
		// Not a mobile/human redeploy
		} else {
			_redeployButton ctrlSetText localize "STR_REDEPLOY_MENU_DEPLOY";
			_redeployButton ctrlEnable true;
		};
	}, 0.1, 
	[_dist, _player]
] call CBA_fnc_addPerFrameHandler;

_redeployMap ctrlAddEventHandler ["Draw", {
	private _iconbackGround = "\a3\ui_f\data\map\respawn\respawn_background_ca.paa";

	if ((isNull PIG_REDEPLOY_object) || {!alive PIG_REDEPLOY_object}) then {continue};
	// Took from BIS respawn function (map draw)
   (_this # 0) drawIcon [
		_iconbackGround,
		[0.00, 0.50, 0.00, 1.00],
		getPosWorld PIG_REDEPLOY_object,
		36,
		36,
		0,
		"",
		false
	]; 
	
	if (PIG_REDEPLOY_object getVariable ["PIG_REDEPLOY_canSpawn", false]) then {
		private _iconSelected = "selector_selectedMission" call bis_fnc_textureMarker;
		(_this # 0) drawIcon [
			_iconSelected,
			[1,1,1,1],
			getPosWorld PIG_REDEPLOY_object,
			48,
			48,
			time * 60,
			"",
			1
		];
	} else {
		private _iconDisabled = "\a3\ui_f\data\map\respawn\respawn_disabled_ca.paa";
		(_this # 0) drawIcon [
			_iconDisabled,
			[1,1,1,1],
			getPosWorld PIG_REDEPLOY_object,
			36,
			36,
			0,
			"",
			false
		];
	};

	private _respawnName = (displayCtrl 88210) lbData (lbCurSel (displayCtrl 88210));

	(_this # 0) drawIcon [		//text (with invisible texture)
		"#(argb,8,8,3)color(0,0,0,0)",
		[1,1,1,1],
		getPosWorld PIG_REDEPLOY_object,
		48,
		48,
		0,
		_respawnName,	//text
		2,	//shadow
		0.07,	//text size
		'RobotoCondensed',	//font, TahomaB
		'right'	//align
	];
}];

// Closing dialog
_redeployMenuDisplay displayAddEventHandler ["Unload", {
	params["_display"];

	[PIG_REDEPLOY_pfhandle] call CBA_fnc_removePerFrameHandler;
	PIG_REDEPLOY_camera cameraEffect ["Terminate","back"];
	camDestroy PIG_REDEPLOY_camera;

	private _player = _display getVariable ["PIG_REDEPLOY_playerObject", objNull];
	PIG_REDEPLOY_playerInRedeploy deleteAt (PIG_REDEPLOY_playerInRedeploy find _player);
	publicVariable "PIG_REDEPLOY_playerInRedeploy";

	PIG_REDEPLOY_iconColor = nil;
}];

[] call PIG_fnc_updateRedeployListBox;