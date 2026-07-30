if (time > 0){ time--; }
else{ room = rmMenu; }

if (state != ""){
	if (startAlpha > 0){ startAlpha -= 0.1; }
}

if (state == "main"){
	
	if (keyboard_check_pressed(vk_space)){
		state = "connect to lobby";
		progress = 0;
	}
	
}

if (state == "connect to lobby"){

	#region CONNECTING

	photon_realtime_select_region("eu");


	photon_realtime_set_callback_connected(function(_error_code, _error_string, _region) {
		show_debug_message($"[REALTIME CONNECT] code={_error_code} error={_error_string} region={_region}");
		debugOutput = $"[REALTIME CONNECT] code={_error_code} error={_error_string} region={_region}";
		if (_error_code == PhotonRealtimeAppErrorCode.Ok){
			show_debug_message("connected!");
			state = "lobby"; //we connected!
			time = 30;
		}
	})

	photon_realtime_set_callback_disconnected(function() {
		show_debug_message("[REALTIME] Disconnected");
		room_goto(rmStart);
	})

	photon_realtime_set_callback_connection_error(function(_error_code) {
		show_debug_message($"[REALTIME] Connection error: {_error_code}");
		debugError = _error_code;
	})

	show_debug_message($"Connecting into region: {"eu"} - {"Europe — Amsterdam"}")

	var _photonConnectOptions = new PhotonRealtimeConnectOptions()
	var _photonAuthenticationValues = new PhotonRealtimeAuthenticationValues()
	//_photonAuthenticationValues.user_id = "user_" + string(irandom_range(1000000,9999999))

	_photonConnectOptions.authentication_values = _photonAuthenticationValues

	var _appId = extension_get_option_value("GMPhoton", "appIdRealtime")
	photon_realtime_connect(_appId, "1.0", _photonConnectOptions)


	#endregion

	if (state == "lobby"){
		
		
		
	}
	if (state == 1){
		
	}
}