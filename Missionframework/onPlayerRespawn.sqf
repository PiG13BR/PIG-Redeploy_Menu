params ["_newUnit", "_oldUnit"];

if !((localNamespace getVariable ['PIG_REDEPLOY_rscDisplay', displayNull]) isEqualTo displayNull) then {
    private _newRespawnDelay = PIG_REDEPLOY_trueRespawnDelay; 
    for "_i" from 0 to _newRespawnDelay do {
        _newRespawnDelay = _newRespawnDelay - 1;
        if (_newRespawnDelay isEqualTo 0) exitWith {};
        private _text = format[localize "STR_REDEPLOY_COUNTER", _newRespawnDelay]; 
        "PIG_REDEPLOY_RespawnText" cutText [["<t size='2.0'>" + _text + "</t>"] joinString "", "PLAIN DOWN", 1, false, true];
        sleep 1;
    };
};

// Fade out resources
"PIG_REDEPLOY_deathLayer" cutFadeOut 0.3;
"PIG_REDEPLOY_RespawnText" cutFadeOut 0.3;

// Call the respawn screen
[_newUnit, PIG_REDEPLOY_checkRespawnRadius] call PIG_fnc_redeployManager;