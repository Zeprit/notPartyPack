/*
draw_set_font(fnt_gm_15);
draw_set_valign(fa_left);
draw_set_halign(fa_left);

draw_text(10, 50, "menuState: " + menuState);

draw_text(10, 500, "State: " + game_state);

var ready = photon_realtime_player_properties_get_local_bool("ready");
//draw_text(10, 520, "You: " + (ready ? "READY" : "NOT READY"));

draw_text_transformed(10, 540, "----PLAYERS----", 0.5, 0.5, 0);
var _count = photon_realtime_get_player_count();
for (var i = 0; i < _count; i++) {
    var _nr     = photon_realtime_get_player_number_by_index(i);
    var _name   = photon_realtime_player_get_name(_nr);
    var _uid    = photon_realtime_player_get_user_id(_nr);
    var _master = photon_realtime_player_is_master_client(_nr);
    draw_text_transformed(10,560+i*20,$"Player {_nr}: {_uid} | master={_master}", 0.5, 0.5, 0);
}


if (game_state == "count down") or (game_state == "go"){
	var _countTxt = "";
	var _remaining = timeRemaining;
	if (_remaining >= 1700){ _countTxt = "3"; }
	else if (_remaining >= 800){ _countTxt = "2"; }
	else if (_remaining > 0){ _countTxt = "1"; }
	else if (_remaining > -400){ _countTxt = "go!"; }
	else{ _countTxt = ""; }
	draw_text_transformed(xxt, (yyt) - 100, _countTxt, 3, 3, 0);
}

//*/