//check JIP player is spawning for the first time
if (serverTime-joinTime < 30 && didJIP) exitWith {diag_log "Player is JIP, not executing onPlayerKilled.sqf"};
private ["_timeleft","_waveLeft","_minutes","_seconds","_respawnIn", "_explanation"];

//keep player from respawning
setPlayerRespawnTime 9999;
sleep 2;

//declare/define variables =====================================================
_rule = parseText "<t align='center'><t color='#708090'>-----------------------------------------------------<br /></t></t>";
_lineBreak = parseText "<br />";
_timeleft = RESPAWNTIME;
_waitCondition = {};
_playersLeft = {};
_waveTimeLeft = {};
_freeRespawn = {};
_waveSize = {};

if (originalSide == "WEST") then {
  _waitCondition = compile "!WAVERESPAWNBLU";
  _playersLeft = {WAVERESPAWNPLAYERSLEFTBLU};
  _waveTimeLeft = {WAVERESPAWNTIMELEFTBLU};
  _waveSize = BLUFORWAVESIZE;
  diag_log "onPlayerKilled - player side is WEST";
};
if (originalSide == "EAST") then {
  _waitCondition = compile "!WAVERESPAWNOPF";
  _playersLeft = {WAVERESPAWNPLAYERSLEFTOPF};
  _waveTimeLeft = {WAVERESPAWNTIMELEFTOPF};
  _waveSize = OPFORWAVESIZE;
  diag_log "onPlayerKilled - player side is EAST";
};
if (originalSide == "GUER") then {
  _waitCondition = compile "!WAVERESPAWNIND";
  _playersLeft = {WAVERESPAWNPLAYERSLEFTIND};
  _waveTimeLeft = {WAVERESPAWNTIMELEFTIND};
  _waveSize = INDEPWAVESIZE;
  diag_log "onPlayerKilled - player side is GUER";
};


//respawn countdown ============================================================
while {_timeleft > 0} do {
  //countdown
  _timeleft = _timeleft - 1;
  _minutes = str (floor (_timeleft/60));
  _seconds = floor (_timeleft mod 60);
  if (_seconds<10) then {_seconds = "0" + str _seconds} else {_seconds = str _seconds};
  _respawnIn = parseText format ["<t align='center' size='1.4'>Spieler: <t color='#ffff00'>%1:%2</t></t>", _minutes, _seconds];

  //wave
  _minutes = str (floor (call _waveTimeLeft/60));
  _seconds = floor (call _waveTimeLeft mod 60);
  if (_seconds<10) then {_seconds = "0" + str _seconds} else {_seconds = str _seconds};
  _waveTimeStr = format ["%1:%2", _minutes, _seconds];
  _waveLeft = parseText format ["<t align='center' size='1.4'>Welle: <t color='%3'>%1/%2</t> - <t color ='%4'>%5</t></t>", _waveSize -(call _playersLeft), _waveSize, if (call _playersLeft == 0) then {"#00ff00"} else {"#ffff00"},if (call _waveTimeLeft <= 0) then {"#00ff00"} else {"#ffff00"},_waveTimeStr];

  //explanation
  _explanation = parseText "<t align ='center' size='1.4'>Warte auf Spieler-Countdown.</t>";

  //compose hint
  hint composeText [_rule, _respawnIn, _lineBreak, _waveLeft, _lineBreak, _explanation, _lineBreak, _rule];

  sleep 1;
};

//send command to server to add player to wave array ===========================
[profileName, originalSide] remoteExec ["mcd_fnc_addDeadPlayerToWave",2,false];


//wait until enough players in wave ============================================
while _waitCondition do {
  _respawnIn = parseText format ["<t align='center' size='1.4'>Spieler <t color='#00ff00'>bereit</t></t>"];
  _minutes = str (floor (call _waveTimeLeft/60));
  _seconds = floor (call _waveTimeLeft mod 60);
  if (_seconds<10) then {_seconds = "0" + str _seconds} else {_seconds = str _seconds};
  _waveTimeStr = format ["%1:%2", _minutes, _seconds];
  _waveLeft = parseText format ["<t align='center' size='1.4'>Welle: <t color='%3'>%1/%2</t> - <t color ='%4'>%5</t></t>", _waveSize-(call _playersLeft), _waveSize, if (call _playersLeft == 0) then {"#00ff00"} else {"#ffff00"},if (call _waveTimeLeft <= 0) then {"#00ff00"} else {"#ffff00"},_waveTimeStr];
  if (call _waveTimeLeft > 0) then {
    _explanation = parseText "<t align='center' size='1.4'>Warte auf Wellen-Countdown.</t>";
  } else {
    _explanation = parseText "<t align='center' size='1.4'>Warte auf weitere Spieler.</t>";
  };
  hint composeText [_rule, _respawnIn, _lineBreak, _waveLeft, _lineBreak, _explanation, _lineBreak, _rule];

  sleep 1;
};

//respawn ======================================================================

//respawn hint
_respawning = parseText format ["<t align='center' color='#00ff00' size='1.4'>Respawning...</t>"];
hint composeText [_rule, _respawning, _lineBreak, _rule];
//respawn player
setPlayerRespawnTime 0;
forceRespawn player;

//close hint
sleep 4;
hint "";

//make sure player doesn't instantly respawn next time
sleep 6;
setPlayerRespawnTime 9999;
