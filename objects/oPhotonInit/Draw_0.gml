/*
draw_set_font(fnt_gm_15);
draw_set_halign(fa_left);
draw_set_valign(fa_left);

var _x = 30;
var _y = 100;

if (room != rmStart){
	draw_text_transformed(_x,_y,$"Initialized: {photon_realtime_is_initialized()}", 0.75, 0.75, 0);
	_y+=20
	draw_text_transformed(_x,_y,$"Connected: {photon_realtime_is_connected()}", 0.75, 0.75, 0);
	_y+=20
	draw_text_transformed(_x,_y,$"In Room: {photon_realtime_is_in_room()}", 0.75, 0.75, 0);
	_y+=20
	draw_text_transformed(_x,_y,$"Room Name: {photon_realtime_get_current_room_name()}", 0.75, 0.75, 0);
	_y+=20
	draw_text_transformed(_x,_y,$"Local Player: {photon_realtime_get_local_player_number()}", 0.75, 0.75, 0);
	_y+=20
}
//*/