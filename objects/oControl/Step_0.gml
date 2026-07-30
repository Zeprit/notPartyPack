
if (startAlpha > 0)
&& (menuState != "connect to game"){
	startAlpha -= 0.01;
}

if (keyboard_check_pressed(ord("F"))){
	if !(window_get_fullscreen()){
		window_set_fullscreen(true);
	}else{
		window_set_fullscreen(false);
	}
}
if (keyboard_check_pressed(vk_escape)){ game_end(); }

#region camera

//ZOOM
if (((zoomTo) + -zoomSpd) > zoom){
	zoom += zoomSpd/2;
}else if (((zoomTo) + zoomSpd) < zoom){
	zoom -= zoomSpd/2;
}

//FOLLOW PLAYER
if (instance_exists(oPlayer)){
	var _target = oPlayer;
	with(oPlayer){
		if (isPlayer){ _target = self; }
	}
	xTo = ((_target.x + _target.x + 1504) / 3) + ((_target.cSpd + (_target.dragonSpdExtra*-_target.angleDir))*20) + 20;
	yTo = _target.y - 270;
}

//CAMERA SMOOTHENER
xxt += ((xTo - xxt) * .1);
yyt += ((yTo - yyt) * .1);

//SHAKE EFFECT
if (global.shake > 0.01){ global.shake *= .94; }
else{ global.shake = 0; }

//CAMERA POSITIONS
camera_set_view_pos(CAMERA, xxt - ((WIDTH/2) * zooms) + (random_range(-global.shake,global.shake)), (yyt) - ((HEIGHT/2) * zooms) + (random_range(-global.shake, global.shake)));
camera_set_view_size(CAMERA, zooms * WIDTH, zooms * HEIGHT);

//AUDIO LISTENER
audio_listener_position(xxt, yyt, 0);
audio_listener_orientation(0, 1, 0, 0, 0, 1);

#endregion
#region effects

	#region select
	
	for (var i = 0; i < 100; i++){
		if (select == i){
			selectAlpha[i] += ((1 - selectAlpha[i]) * 0.2);
		
			if (selectBounceIndex[i] < 46){
				selectBounceIndex[i]++;
			}
			selectBounce[i] = Bounce(selectBounceIndex[i], 0, 1, 46);
		
		}else{
			selectBounceIndex[i] = 0;
			selectAlpha[i] += ((0 - selectAlpha[i]) * 0.2);
			selectBounce[i] += ((0 - selectBounce[i]) * 0.2);
		}

	}
	
	#endregion
	
#endregion
#region menu

if (room == rmMenu){
	
	switch(menuState){
		case "main":
			
			if (SPACE_PRESSED){
				menuState = "connect to lobby";
				menuProgress = 0;
			}
			
		break;
		
		#region CONNECT TO LOBBY
		case "connect to lobby":
		if (menuProgress == 0){
			show_debug_message("connecting to lobby...");
			
			//force a server region:
			photon_realtime_select_region("eu");

			//return call of a connection:
			photon_realtime_set_callback_connected(function(_error_code, _error_string, _region) {
				show_debug_message($"[REALTIME CONNECT] code={_error_code} error={_error_string} region={_region}");

				if (_error_code == PhotonRealtimeAppErrorCode.Ok){
					//if we connected succesfully:
					show_debug_message("...connected!");
					menuProgress = 0;
					select = 0;
					menuState = "lobby";
					photon_realtime_operation_join_lobby("default", PhotonRealtimeLobbyType.Default);

				}
			})

			//return call when we disconnect:
			photon_realtime_set_callback_disconnected(function() {
				show_debug_message("[REALTIME] Disconnected");
				room_goto(rmMenu);
			})

			//return call when we get a connection error:
			photon_realtime_set_callback_connection_error(function(_error_code) {
				show_debug_message($"[REALTIME] Connection error: {_error_code}");
				//debugError = _error_code;
			})


			//the actual connecting:
			var _photonConnectOptions = new PhotonRealtimeConnectOptions();
			var _photonAuthenticationValues = new PhotonRealtimeAuthenticationValues();

			_photonConnectOptions.authentication_values = _photonAuthenticationValues;

			var _appId = extension_get_option_value("GMPhoton", "appIdRealtime");
			photon_realtime_connect(_appId, "1.0", _photonConnectOptions);
			
			
			menuProgress++;
		}
		break;
		#endregion
		#region LOBBY
		case "lobby":
		

		
		if (menuProgress == 0){

			
			if (UP_PRESSED){
				select--;
			}
			if (DOWN_PRESSED){
				select++;
			}
			if (select > 2){ select = 2; }
			if (select < 0){ select = 0; }
		
			if (SPACE_PRESSED){
			
				show_debug_message("joining room...");
			
				//create the room options:
				var _photonRoomOptions = new PhotonRealtimeRoomOptions()
					_photonRoomOptions.max_players = roomInfo[select].playerMax;
					_photonRoomOptions.is_visible = true;
					_photonRoomOptions.is_open = true;
					_photonRoomOptions.lobby_name = "default";
					_photonRoomOptions.lobby_type = PhotonRealtimeLobbyType.Default;
					_photonRoomOptions.lobby_keys = ["mode", "build", "party_size", "skill_bucket"];
					_photonRoomOptions.expected_users = [];

				var custom_props = {
					};

				//create or join the room
				photon_realtime_operation_join_or_create_room(roomInfo[select].name,_photonRoomOptions,custom_props,undefined,function(_error_code2, _error_string, _room_name, _player_number){
					show_debug_message($"on join_or_create_room_return {{_error_code2, _error_string, _room_name, _player_number}}")
					if(_error_code2 == PhotonRealtimeAppErrorCode.Ok){
						//if we created or joined the room good
						show_debug_message("...joined room!");
						menuState = "connect to game";
					
					}
				});
			}
			
		}
		
		break;
		#endregion
		#region CONNECT TO GAME
		case "connect to game":
		
		if (startAlpha < 1){ startAlpha += 0.1; }else{
			room_goto(rmLevel);
		}
		
		break;
		#endregion

	}
	
	
	exit;
}

#endregion

if (spawnPlayer > 0){
	spawnPlayer--;
	if (spawnPlayer == 1){
		
		var _count = photon_realtime_get_player_count();
		for (var i = 0; i < _count; i++) {
			
			var _nr = photon_realtime_get_player_number_by_index(i);
			if (_nr != photon_realtime_get_local_player_number()){
				var _newPlayer = instance_create_depth(x, 576,0,oPlayer);
					_newPlayer.myID = _nr;
					_newPlayer.x = photon_realtime_player_properties_get_remote_i32(_nr, "xx");
					_newPlayer.king = photon_realtime_player_properties_get_remote_bool(_nr, "king");
					_newPlayer.isPlayer = false;
			}
		}
		
		
		var b = buffer_create(64, buffer_grow, 1);
		buffer_seek(b, buffer_seek_start, 0);
	
		buffer_write(b, buffer_u16, photon_realtime_player_properties_get_local_i32("xx"));
		buffer_write(b, buffer_u16, 576);
		buffer_write(b, buffer_u16, photon_realtime_get_local_player_number());
	
		var _realPlayerX = photon_realtime_player_properties_get_local_i32("xx");
		var _realPlayer =  instance_create_depth(_realPlayerX, 576, 0, oPlayer);
			_realPlayer.isPlayer = true;
			_realPlayer.myID = photon_realtime_get_local_player_number();
		show_debug_message("spawning player at "+string(_realPlayerX));
		xxt = _realPlayerX; yyt = 576-270;
	
		photon_realtime_operation_raise_event_buffer(true, b, buffer_tell(b), 100);
	
		buffer_delete(b)
		
		
	}
}else{
	if (extraCheck > 0){ extraCheck--; }
	else{
		extraCheck = 30;
		var _count = photon_realtime_get_player_count();
		for (var i = 0; i < _count; i++){
			
			var _nr = photon_realtime_get_player_number_by_index(i);
			if (_nr != photon_realtime_get_local_player_number()){
				if (instance_exists(oPlayer)){
					with(oPlayer){
						if !(isPlayer) && (myID == _nr){
							xxTo =			photon_realtime_player_properties_get_remote_i32(_nr, "xx");
							headAngle =		photon_realtime_player_properties_get_remote_i32(_nr, "headAngle");
							neckAngle =		photon_realtime_player_properties_get_remote_i32(_nr, "neckAngle");
							pressSpace =	photon_realtime_player_properties_get_remote_i32(_nr, "pressSpace");
							pressLeft =		photon_realtime_player_properties_get_remote_i32(_nr, "pressLeft");
							pressRight =	photon_realtime_player_properties_get_remote_i32(_nr, "pressRight");
							angleDir =		photon_realtime_player_properties_get_remote_i32(_nr, "angleDir");
							king =			photon_realtime_player_properties_get_remote_bool(_nr, "king");
						}
					}
				}
			}
		}
	}
	if (instance_exists(oPlayer)){
		with(oPlayer){
			if (isPlayer){
				photon_realtime_player_properties_set_local_i32("xx", x);
				photon_realtime_player_properties_set_local_i32("headAngle", headAngle);
				photon_realtime_player_properties_set_local_i32("neckAngle", neckAngle);
				photon_realtime_player_properties_set_local_i32("pressSpace", pressSpace);
				photon_realtime_player_properties_set_local_i32("pressLeft", pressLeft);
				photon_realtime_player_properties_set_local_i32("pressRight", pressRight);
				photon_realtime_player_properties_set_local_i32("angleDir", angleDir);
			}
		}
	}
}

//photon_realtime_player_get_name()

repeat(photon_realtime_get_buffer_event_queue_count())
{
	var recv = buffer_create(256, buffer_fixed, 1);
	var r = photon_realtime_receive_one_event_buffer(recv, 256, 0);

	if (r.ok)
	{
	    buffer_seek(recv, buffer_seek_start, 0);

	    var _x = buffer_read(recv, buffer_u16);
	    var _y = buffer_read(recv, buffer_u16);
		var _myID = buffer_read(recv, buffer_u16);
	
		var _playerSpawn = instance_create_depth(_x,_y,0,oPlayer)
			_playerSpawn.myID = _myID;
			_playerSpawn.xxTo = _x;
			_playerSpawn.isPlayer = false;
	}

	buffer_delete(recv)
}

var _me = photon_realtime_get_local_player_number();
var _master = photon_realtime_get_master_client_number();
if (_me == _master){
	
	if (game_state == "waiting"){
		if (keyboard_check_pressed(ord("G"))){
			var _startTime = photon_realtime_get_server_time() + 3000;
			photon_realtime_room_properties_set_f64("raceStartTime", _startTime);
			photon_realtime_room_properties_set_string("game_state", "count down");
			raceStartTime = _startTime;
			game_state = "count down";
		}
	}
	
	if (keyboard_check_pressed(ord("R"))){
		show_debug_message("manual reset!");
		
		photon_realtime_player_properties_set_local_bool("ready", false);
		photon_realtime_player_properties_set_local_bool("king", false);
		var _xx = 30 + irandom(170);
		photon_realtime_player_properties_set_local_i32("xx", _xx);
		photon_realtime_room_properties_set_string("game_state", "resetting");
		game_state = "resetting";
		if (instance_exists(oPlayer)){
			with(oPlayer){
				if (isPlayer){
					king = false;
					x = _xx;
					resetTimer = room_speed;
				}
			}
		}
	}
	
	if (photon_realtime_room_properties_get_string("game_state") == "resetting"){
		if (resetTimer > 0){ resetTimer--; }
		else{
			photon_realtime_room_properties_set_string("game_state", "waiting");
			game_state = "waiting";
		}
	}
	
}


if (game_state == "count down"){
	timeRemaining = raceStartTime - photon_realtime_get_server_time();
	
	if (timeRemaining <= 0){
		game_state = "go";
		if (_me == _master){
			photon_realtime_room_properties_set_string("game_state", "go");
		}
	}
	
}