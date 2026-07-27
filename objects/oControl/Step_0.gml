
if (spawnPlayer > 0){
	spawnPlayer--;
	if (spawnPlayer == 1){
		
		var _count = photon_realtime_get_player_count();
		for (var i = 0; i < _count; i++) {
			
			var _nr = photon_realtime_get_player_number_by_index(i);
			if (_nr != photon_realtime_get_local_player_number()){
				var _newPlayer = instance_create_depth(x, 480,0,oOtherPlayer);
					_newPlayer.myID = _nr
					_newPlayer.x = photon_realtime_player_properties_get_remote_i32(_nr, "xx");
			}
		}
		
		
		var b = buffer_create(64, buffer_grow, 1);
		buffer_seek(b, buffer_seek_start, 0);
	
		buffer_write(b, buffer_u16, photon_realtime_player_properties_get_local_i32("xx"));
		buffer_write(b, buffer_u16, 480);
		buffer_write(b, buffer_u16, photon_realtime_get_local_player_number());
	
		instance_create_depth(photon_realtime_player_properties_get_local_i32("xx"), 480,0,oPlayer)
		show_debug_message("spawning player at "+string(photon_realtime_player_properties_get_local_i32("xx")));
	
		photon_realtime_operation_raise_event_buffer(true, b, buffer_tell(b), 100);
	
		buffer_delete(b)
		
		
	}
}else{
	var _count = photon_realtime_get_player_count();
		for (var i = 0; i < _count; i++) {
			
			var _nr = photon_realtime_get_player_number_by_index(i);
			if (instance_exists(oOtherPlayer)){
				with(oOtherPlayer){
					if (myID == _nr){
						x = photon_realtime_player_properties_get_remote_i32(_nr, "xx");
					}
				}
			}
		}
	if (instance_exists(oPlayer)){

			//show_debug_message("changing xx..");
			photon_realtime_player_properties_set_local_i32("xx", oPlayer.x);
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
	
		var _playerSpawn = instance_create_depth(_x,_y,0,oOtherPlayer)
			_playerSpawn.myID = _myID;
	}

	buffer_delete(recv)
}


