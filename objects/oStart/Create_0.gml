
time = 10;
state = "nothing";
progress = 0;
startAlpha = 1;

debugOutput = "";
debugError = "";

#region GLOBAL VARIABLES

global.startAlphaColor = c_black;

global.fntNormal = font_add("DarumadropOne-Regular.ttf", 32, false, false, 32, 127);
font_enable_sdf(global.fntNormal, true);

global.userName = "";

#endregion

#region CAMERA

	view_enabled = true;
	view_visible[0] = true;
	
	//MAKE THE SCREEN RATIO
	var _reso = 1080;
	var ideal_width = 0, ideal_height = _reso;//768;
	aspect_ratio = display_get_width() / display_get_height();
	show_debug_message("aspect_ratio: "+string(aspect_ratio));
	//aspect_ratio = 1920 / 1080;
	ideal_width  = round(ideal_height * aspect_ratio);
	show_debug_message("ideal_width: "+string(ideal_width));
	//ideal_width = 1920;
	
	
	if (ideal_width & 1){
		ideal_width++;		//if we end up on an uneven width we add 1
	}
	show_debug_message("ideal_width2: "+string(ideal_width));
	
	window_set_size(ideal_width, ideal_height);

	surface_resize(application_surface, ideal_width, ideal_height);

	display_set_gui_size(ideal_width, ideal_height);
	
	global.camW = ideal_width;
	global.camH = ideal_height;
	
	#macro WIDTH global.camW
	#macro HEIGHT global.camH
	#macro CAMERA view_camera[0]
	
#endregion

#macro SECOND 60