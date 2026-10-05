if (y < 576){
	grav += 0.35;
	
	y += grav;
	x += spd;
}else{
	show_debug_message($"died with a spd of {spd} and grav of {grav}");
	instance_destroy();
}