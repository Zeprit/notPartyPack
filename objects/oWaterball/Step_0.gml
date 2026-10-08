if (y < 576){
	grav += 0.35;
	
	y += grav;
	x += spd;
}else{
	
	instance_create_depth(x, y, depth, oWaterSplash);
	
	instance_destroy();
}