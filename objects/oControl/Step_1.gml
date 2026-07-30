
#region KEY BINDINGS

#region gamepad stuff
var gp = currentGamepad;
var _axisMin = 0.35;	//minimal axis of joysticks

if (gp != -1){
	if ((gamepad_axis_value(gp, gp_axislh) > -.2) && (gamepad_axis_value(gp, gp_axislh) < .2)){gpTapH = true;}
	if ((gamepad_axis_value(gp, gp_axislv) > -.2) && (gamepad_axis_value(gp, gp_axislv) < .2)){gpTapV = true;}
}
#endregion

var _face1 = gp_face1;
var _face2 = gp_face2; //switch these face buttons for switch controller implementation

//KEYBINDINGS:
global.K_Left =				keyboard_check(vk_left) or (keyboard_check(ord("A")))
							or (gamepad_button_check(gp, gp_padl)) or (gamepad_axis_value(gp, gp_axislh) < -_axisMin);
global.K_Left_Pressed_Single =		keyboard_check_pressed(vk_left) or (keyboard_check_pressed(ord("A")))
							or (gamepad_button_check_pressed(gp, gp_padl)) or (gamepad_axis_value(gp, gp_axislh) < -0.6 && gpTapH);
global.K_Right =			keyboard_check(vk_right) or (keyboard_check(ord("D")))
							or (gamepad_button_check(gp, gp_padr)) or (gamepad_axis_value(gp, gp_axislh) > _axisMin);
global.K_Right_Pressed_Single =	keyboard_check_pressed(vk_right) or (keyboard_check_pressed(ord("D")))
							or (gamepad_button_check_pressed(gp, gp_padr)) or (gamepad_axis_value(gp, gp_axislh) > 0.6 && gpTapH);
global.K_Up	=				keyboard_check(vk_up) or (keyboard_check(ord("W")))
							or (gamepad_button_check(gp, gp_padu)) or (gamepad_axis_value(gp, gp_axislv) < -_axisMin);
global.K_Up_Pressed_Single	=		keyboard_check_pressed(vk_up) or (keyboard_check_pressed(ord("W")))
							or (gamepad_button_check_pressed(gp, gp_padu)) or (gamepad_axis_value(gp, gp_axislv) < -0.6 && gpTapV);
global.K_Down =				keyboard_check(vk_down) or (keyboard_check(ord("S")))
							or (gamepad_button_check(gp, gp_padd)) or (gamepad_axis_value(gp, gp_axislv) > _axisMin);
global.K_Down_Pressed_Single =		keyboard_check_pressed(vk_down) or (keyboard_check_pressed(ord("S")))
							or (gamepad_button_check_pressed(gp, gp_padd)) or (gamepad_axis_value(gp, gp_axislv) > 0.6 && gpTapV);
global.K_Space_Pressed =	keyboard_check_pressed(vk_space) or keyboard_check_pressed(vk_enter)
							or (gamepad_button_check_pressed(gp, _face1));
global.K_Space =			keyboard_check(vk_space)
							or (gamepad_button_check(gp, _face1));
global.K_Space_Released =	keyboard_check_released(vk_space)
							or (gamepad_button_check_released(gp, _face1));
global.K_Back =				keyboard_check(ord("X")) or keyboard_check(vk_shift)
							or (gamepad_button_check(gp, _face2));
global.K_Back_Pressed =		keyboard_check_pressed(ord("X"))
							or (gamepad_button_check_pressed(gp, _face2));
global.K_Info =				keyboard_check(ord("C"))
							or (gamepad_button_check(gp, gp_face4));
global.K_Info_Pressed =		keyboard_check_pressed(ord("C"))
							or (gamepad_button_check_pressed(gp, gp_face4));
global.K_Swap_Pressed =		keyboard_check_pressed(ord("V"))
							or (gamepad_button_check_pressed(gp, gp_face3));
global.K_Escape_Pressed	=	keyboard_check_pressed(vk_escape)
							or (gamepad_button_check_pressed(gp, gp_start));

global.K_Left_Pressed = false;
global.K_Right_Pressed = false;
global.K_Up_Pressed = false;
global.K_Down_Pressed = false;
if (global.K_Left_Pressed_Single){global.K_Left_Pressed = true;}
if (global.K_Right_Pressed_Single){global.K_Right_Pressed = true;}
if (global.K_Up_Pressed_Single){global.K_Up_Pressed = true;}
if (global.K_Down_Pressed_Single){global.K_Down_Pressed = true;}

if (global.K_Left_Pressed) or (global.K_Right_Pressed){gpTapH = false;}
if (global.K_Up_Pressed) or (global.K_Down_Pressed){gpTapV = false;}

#region hold keys to do a tap
var _holdLength = 18; //32 //22
if (global.K_Left){
	keyHoldLeft++;
	if (keyHoldLeft > _holdLength){
		global.K_Left_Pressed = true;
		keyHoldLeft = _holdLength-4;
	}
}else{keyHoldLeft = 0;}

if (global.K_Right){
	keyHoldRight++;
	if (keyHoldRight > _holdLength){
		global.K_Right_Pressed = true;
		keyHoldRight = _holdLength-4;
	}
}else{keyHoldRight = 0;}

if (global.K_Up){
	keyHoldUp++;
	if (keyHoldUp > _holdLength){
		global.K_Up_Pressed = true;
		keyHoldUp = _holdLength-4;
	}
}else{keyHoldUp = 0;}

if (global.K_Down){
	keyHoldDown++;
	if (keyHoldDown > _holdLength){
		global.K_Down_Pressed = true;
		keyHoldDown = _holdLength-4;
	}
}else{keyHoldDown = 0;}
#endregion
#region hold space
global.K_Space_Hold = false;
if (global.K_Space_Pressed){keyHoldSpace = 0;}
if (global.K_Space) && (keyHoldSpace >= 0){
	if (keyHoldSpace < SECOND/2){keyHoldSpace++;}else{global.K_Space_Hold = true; keyHoldSpace = -1;}
}else{
	keyHoldSpace = -1;
}
#endregion

#endregion
#region MACROS

#macro LEFT global.K_Left
#macro LEFT_PRESSED global.K_Left_Pressed
#macro LEFT_PRESSED_SINGLE global.K_Left_Pressed_Single
#macro RIGHT global.K_Right
#macro RIGHT_PRESSED global.K_Right_Pressed
#macro RIGHT_PRESSED_SINGLE global.K_Right_Pressed_Single
#macro UP global.K_Up
#macro UP_PRESSED global.K_Up_Pressed
#macro UP_PRESSED_SINGLE global.K_Up_Pressed_Single
#macro DOWN global.K_Down
#macro DOWN_PRESSED global.K_Down_Pressed
#macro DOWN_PRESSED_SINGLE global.K_Down_Pressed_Single
#macro SPACE global.K_Space
#macro SPACE_PRESSED global.K_Space_Pressed
#macro SPACE_RELEASED global.K_Space_Released
#macro SPACE_HOLD global.K_Space_Hold
#macro SPACE_HOLD_SHORT global.K_Space_Hold_Short
#macro BACK_PRESSED global.K_Back_Pressed
#macro BACK global.K_Back

#macro ESCAPE_PRESSED global.K_Escape_Pressed

#endregion