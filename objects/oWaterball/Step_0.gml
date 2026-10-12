if (y < 576){
	grav += 0.35;
	
	y += grav;
	x += spd;
	
	audio_emitter_position(myEmitter, x, y, 0);
}else{
	
	instance_create_depth(x, y, depth, oWaterSplash);
	audio_play_sound_on(myEmitter, sfxLowThumb, false, 1,,, random_range(1.2, 1.3));
	
	instance_destroy();
}