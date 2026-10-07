
draw_set_font(global.fntNormal);

if (room == rmMenu){
	
	switch(menuState){
		case "main":

			var _txt = $"username: {global.userName}";
			var _txtScale = 2;
			var _txtWidth = (string_width(_txt)*_txtScale), _txtHeight = (string_height(_txt)*_txtScale);
			draw_text_transformed((WIDTH/2) - (_txtWidth/2), (HEIGHT/2.5), _txt, _txtScale, _txtScale, 0);
			//draw_text_transformed((WIDTH/2) - (_txtWidth/2), (HEIGHT/2.5) + _txtHeight, global.userName, _txtScale, _txtScale, 0);

			if (global.userName != ""){
				var _txt = "press enter to connect!";
				var _txtScale = 2;
				var _txtWidth = (string_width(_txt)*_txtScale);
				draw_text_transformed((WIDTH/2) - (_txtWidth/2), (HEIGHT/1.8), _txt, _txtScale, _txtScale, 0);
			}

		break;
		case "connect to lobby":

			var _txt = "connecting to lobby...";
			var _txtScale = 0.5;
			var _txtWidth = (string_width(_txt)*_txtScale);
			draw_text_transformed((WIDTH/12), (HEIGHT/2), _txt, _txtScale, _txtScale, 0);

		break;
		case "lobby":

			var _txt = "Lobby";
			var _txtScale = 3;
			var _txtWidth = (string_width(_txt)*_txtScale), _txtHeight = (string_height(_txt)*_txtScale);
			draw_text_transformed((WIDTH/12), (HEIGHT/8), _txt, _txtScale, _txtScale, 0);
			
			for (var i = 0; i < 3; i++){
				var _txt = $"{roomInfo[i].name}  {roomInfo[i].playerCount}/{roomInfo[i].playerMax} players";
				var _txtScale = 1.4 + (0.15*selectBounce[i]);
				var _txtHeight = (string_height(_txt)*_txtScale) + 8;
				var _txtBlend = c_white;
				var _txtAlpha = 0.85 + (0.15*selectAlpha[i]);
				draw_text_transformed_colour((WIDTH/11) + (10*selectBounce[i]), (HEIGHT/2.5)+(_txtHeight*i), _txt, _txtScale, _txtScale, 0, _txtBlend, _txtBlend, _txtBlend, _txtBlend, _txtAlpha);
			}

		break;
	}
}

if (room == rmLevel){
	//draw_text_transformed(WIDTH/12, HEIGHT/6, $"Room Name: {photon_realtime_get_current_room_name()}", 0.75, 0.75, 0);
	//draw_text_transformed(WIDTH/12, HEIGHT/6 + 22, $"Players: {photon_realtime_get_room_player_count()}", 0.75, 0.75, 0);
}

#region STARTALPHA
if (startAlpha > 0){
	draw_sprite_stretched_ext(sWhite, 0, -1, -1, WIDTH+2, HEIGHT+2, global.startAlphaColor, startAlpha);
}
#endregion