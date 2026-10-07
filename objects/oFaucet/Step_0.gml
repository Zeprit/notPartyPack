if (time > 0){ time--; }
else{
	instance_create_depth(x-65, y-136, depth+1, oWaterball);
	time = room_speed*2;
}