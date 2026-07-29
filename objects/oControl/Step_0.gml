#region camera
if (((zoomTo) + -zoomSpd) > zoom){
	zoom += zoomSpd/2;
}else if (((zoomTo) + zoomSpd) < zoom){
	zoom -= zoomSpd/2;
}

if (instance_exists(oPlayer)){
	var _target = oPlayer;
	with(oPlayer){
		if (isPlayer){ _target = self; }
	}
	xTo = _target.x + ((_target.cSpd + (_target.dragonSpdExtra*-_target.angleDir))*20) + 20;
	yTo = _target.y - 270;
	
	xxt += ((xTo - xxt) * .1);
	yyt += ((yTo - yyt) * .1);
}

if (global.shake > 0.01){
	global.shake *= .94;
}else{
	global.shake = 0;
}

camera_set_view_pos(CAMERA, xxt - ((WIDTH/2) * zooms) + (random_range(-global.shake,global.shake)), (yyt) - ((HEIGHT/2) * zooms) + (random_range(-global.shake, global.shake)));
camera_set_view_size(CAMERA, zooms * WIDTH, zooms * HEIGHT);

audio_listener_position(xxt, yyt, 0);
audio_listener_orientation(0, 1, 0, 0, 0, 1);
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
	
		var _realPlayer =  instance_create_depth(photon_realtime_player_properties_get_local_i32("xx"), 576, 0, oPlayer);
			_realPlayer.isPlayer = true;
			_realPlayer.myID = photon_realtime_get_local_player_number();
		show_debug_message("spawning player at "+string(photon_realtime_player_properties_get_local_i32("xx")));
	
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