#region camera

view_enabled = true;
view_visible[0] = true;

xxt = 0;
yyt = 0;
xTo = 0;
yTo = 0;
global.shake = 0;
zooms = 0.8;
zoom = zooms;
zoomTo = zooms;
zoomSpd = 0.01;

#endregion


game_state = "waiting";
extraCheck = 10;

// Every player starts NOT ready
photon_realtime_player_properties_set_local_bool("ready", false);
photon_realtime_player_properties_set_local_bool("king", false);
var _xx = 30 + irandom(170);
photon_realtime_player_properties_set_local_i32("xx", _xx);
show_debug_message("start x = "+string(_xx));

// Master initializes room state
if (photon_realtime_get_master_client_number() == photon_realtime_get_local_player_number())
{
    photon_realtime_room_properties_set_string("game_state", "waiting");
}

photon_realtime_set_callback_available_regions(function(_regions, _servers) {
    show_debug_message("on available regions: " + string(_regions) + " / " + string(_servers));
});

photon_realtime_set_callback_disconnected(function() {
    show_debug_message("on disconnected");
    room_goto(rmStart);
});

photon_realtime_set_callback_connection_error(function(_code) {
    var str = "on connection_error: " + string(_code);
    show_debug_message(str);
});

photon_realtime_set_callback_client_error(function(_code) {
    show_debug_message("on client_error: " + string(_code));
});

photon_realtime_set_callback_server_error(function(_code) {
    show_debug_message("on server_error: " + string(_code));
});

photon_realtime_set_callback_warning(function(_code) {
    show_debug_message("on warning: " + string(_code));
});

photon_realtime_set_callback_join_room_event(function(_joining_player_number, _player_number, _player_name, _user_id_cb, _is_inactive, _is_master_client) {
    show_debug_message(
        "on join_room_event: " +
        "joining=" + string(_joining_player_number) +
        ", player=" + string(_player_number) +
        ", name=" + string(_player_name) +
        ", user_id=" + string(_user_id_cb) +
        ", inactive=" + string(_is_inactive) +
        ", master=" + string(_is_master_client)
    );
});

photon_realtime_set_callback_leave_room_event(function(_playerNumber, _is_inactive) {
    show_debug_message(
        "on leave_room_event: " +
        "player=" + string(_playerNumber) +
        ", inactive=" + string(_is_inactive)
    );
	if (instance_exists(oPlayer)){
		with(oPlayer){
			if (myID == _playerNumber){
				instance_destroy();
			}
		}
	}
});

photon_realtime_set_callback_custom_event(function(_player_number, _event_code, _payload) {
    show_debug_message(
        "on custom_event: " +
        "player=" + string(_player_number) +
        ", event_code=" + string(_event_code) +
        ", payload=" + string(_payload)
    );
});

function func_updated_room(_game_state)
{
    game_state = _game_state;
	if (_game_state == "resetting"){
		var me = photon_realtime_get_local_player_number();
		var master = photon_realtime_get_master_client_number();
		
		if (me != master){
			photon_realtime_player_properties_set_local_bool("ready", false);
			photon_realtime_player_properties_set_local_bool("king", false);
			var _xx = 30 + irandom(170);
			photon_realtime_player_properties_set_local_i32("xx", _xx);
			if (instance_exists(oPlayer)){
				with(oPlayer){
					if (isPlayer){
						king = false;
						x = _xx;
						resetTimer = room_speed;
					}
				}
			}
			extraCheck = 0;
		}
		
	}
}

photon_realtime_set_callback_room_properties_change(function(properties) {
    show_debug_message("on room_properties_change: " + string(properties));

    if (variable_struct_exists(properties, "game_state"))
    {
        // We should update locally, because if we update it ourselves we don't receive the callback.
        func_updated_room(properties.game_state);
    }
});

resetTimer = room_speed;

function func_updated_player()
{
    var me = photon_realtime_get_local_player_number();
    var master = photon_realtime_get_master_client_number();

    if (me != master) return;

    var count = photon_realtime_get_room_player_count();

    if (count < 2)
    {
        //photon_realtime_room_properties_set_string("game_state", "waiting");
        //func_updated_room("waiting");
        return;
    }

    var all_ready = true;

    for (var i = 1; i <= count; i++){
        var ready;

        if (i == me){
            ready = photon_realtime_player_properties_get_local_bool("ready");
        }
        else{
            ready = photon_realtime_player_properties_get_remote_bool(i, "ready");
        }

        if !(ready){
            all_ready = false;
            break;
        }
    }

    if (all_ready){
        show_debug_message("game_state: go");
        photon_realtime_room_properties_set_string("game_state", "go");
        func_updated_room("go");
		zoomTo = 1;
		global.shake = 4;
    }else{
        //show_debug_message("game_state: waiting");
        //photon_realtime_room_properties_set_string("game_state", "waiting");
        //func_updated_room("waiting");
    }
}


photon_realtime_set_callback_player_properties_change(function(_playerNumber, properties) {
    show_debug_message(
        "on player_properties_change: player=" +
        string(_playerNumber) +
        ", properties=" +
        string(properties)
    );

    if (variable_struct_exists(properties, "ready")){
        // We should update locally, because if we update it ourselves we don't receive the callback.
        func_updated_player();
    }
	

	if (_playerNumber != photon_realtime_get_local_player_number()){
		if (instance_exists(oPlayer)){
			with(oPlayer){
				if !(isPlayer) && (myID == _playerNumber){
					if (variable_struct_exists(properties, "xx")){			xxTo =			photon_realtime_player_properties_get_remote_i32(_playerNumber, "xx"); }
					if (variable_struct_exists(properties, "headAngle")){	headAngle =		photon_realtime_player_properties_get_remote_i32(_playerNumber, "headAngle"); }
					if (variable_struct_exists(properties, "neckAngle")){	neckAngle =		photon_realtime_player_properties_get_remote_i32(_playerNumber, "neckAngle"); }
					if (variable_struct_exists(properties, "pressSpace")){	pressSpace =	photon_realtime_player_properties_get_remote_i32(_playerNumber, "pressSpace"); }
					if (variable_struct_exists(properties, "pressLeft")){	pressLeft =		photon_realtime_player_properties_get_remote_i32(_playerNumber, "pressLeft"); }
					if (variable_struct_exists(properties, "pressRight")){	pressRight =	photon_realtime_player_properties_get_remote_i32(_playerNumber, "pressRight"); }
					if (variable_struct_exists(properties, "angleDir")){	angleDir =		photon_realtime_player_properties_get_remote_i32(_playerNumber, "angleDir"); }
				}
			}
		}
	}
	
	
});


spawnPlayer = 5;