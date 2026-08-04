var _players = 0;
if (instance_exists(oPlayer)){
	with(oPlayer){
		if (x > other.x){ _players++; }
	}
}
players = _players;
if (maxPlayers < 2){ maxPlayers = 2; }

if (players >= maxPlayers){ on = true; }else{ on = false; }
if (on){
	onAlpha += (1 - onAlpha)*0.25;
}else{
	onAlpha += (0 - onAlpha)*0.25;
}

image_blend = merge_color(#7CB25B, merge_color(#7CB25B, c_white, 0.3), onAlpha);