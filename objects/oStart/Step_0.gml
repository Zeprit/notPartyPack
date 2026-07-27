if (state < 1){
	if (startAlpha > 0){ startAlpha -= 0.1; }
}

if (progress == 0){
	
	if (keyboard_check_pressed(vk_space)){
		progress++;
	}
	
}

if (progress == 1){
	#region CONNECTING
	
	if (time > 0){
		time--;
	}else{
		time = 30;
		if (state < 0){

			photon_realtime_select_region("eu");


			photon_realtime_set_callback_connected(function(_error_code, _error_string, _region) {
			    show_debug_message($"[REALTIME CONNECT] code={_error_code} error={_error_string} region={_region}");
				if (_error_code == PhotonRealtimeAppErrorCode.Ok){
					show_debug_message("connected!");
					state = 0;//we connected!
					time = 30;
				}
			})

			photon_realtime_set_callback_disconnected(function() {
			    show_debug_message("[REALTIME] Disconnected");
				room_goto(rmStart);
			})

			photon_realtime_set_callback_connection_error(function(_error_code) {
			    show_debug_message($"[REALTIME] Connection error: {_error_code}");
			})

			show_debug_message($"Connecting into region: {"eu"} - {"Europe — Amsterdam"}")

			var _photonConnectOptions = new PhotonRealtimeConnectOptions()
			var _photonAuthenticationValues = new PhotonRealtimeAuthenticationValues()
			//_photonAuthenticationValues.user_id = "user_" + string(irandom_range(1000000,9999999))

			_photonConnectOptions.authentication_values = _photonAuthenticationValues

			var _appId = extension_get_option_value("GMPhoton", "appIdRealtime")
			photon_realtime_connect(_appId, "1.0", _photonConnectOptions)
		}else if (state == 0){
		
			var _photonRoomOptions = new PhotonRealtimeRoomOptions()
			_photonRoomOptions.max_players = 8
			_photonRoomOptions.is_visible = true
			_photonRoomOptions.is_open = true
			_photonRoomOptions.lobby_name = "default"
			_photonRoomOptions.lobby_type = PhotonRealtimeLobbyType.Default
			_photonRoomOptions.lobby_keys = ["mode", "build", "party_size", "skill_bucket"]
			_photonRoomOptions.expected_users = []

			var custom_props = {
				};

			photon_realtime_operation_join_or_create_room("default",_photonRoomOptions,custom_props,undefined,function(_error_code2, _error_string, _room_name, _player_number){
					show_debug_message($"on join_or_create_room_return {{_error_code2, _error_string, _room_name, _player_number}}")
					if(_error_code2 == PhotonRealtimeAppErrorCode.Ok)
					{
						state = 1;
					
					}
				});
		
		}
	}
	if (state == 1){
		if (startAlpha < 1){ startAlpha += 0.1; }else{
			room_goto(rmLevel);
		}
	}
	
	#endregion
}