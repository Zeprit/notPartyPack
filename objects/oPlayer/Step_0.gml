if (isPlayer){
	pressRight =	(keyboard_check(vk_right)) or (keyboard_check(ord("D")));
	pressLeft =		(keyboard_check(vk_left)) or (keyboard_check(ord("A")));
	pressSpace =	(keyboard_check(vk_space));
}

audio_emitter_position(myEmitter, x, y, 0);

#region effects
slowSin += .015;

if (canSwitchAngleDir > 0){ canSwitchAngleDir--; }
#endregion

#region movement
var _spdInc = 0.5;
var _canWalkRight = true, _canWalkLeft = true;
var _walkRight = false, _walkLeft = false;
var _spdDivide = 1;

if (x > 2914){ _canWalkRight = false; }
if (x < 20){ _canWalkLeft = false; }
if (sprite_index == sPlayerGrab) && (sprite_index == sPlayerThrow){ _canWalkRight = false; _canWalkLeft = false; }

if (pressRight) && !(pressLeft) && (_canWalkRight){

	if (cSpd < (maxSpd)){ cSpd += _spdInc; }
	else if (cSpd >= (maxSpd)+_spdInc){ cSpd -= _spdInc; }
	_walkRight = true;
	xScale = 1;
	
}else if (pressLeft) && !(pressRight) && (_canWalkLeft){

	if (cSpd > -(maxSpd)){ cSpd -= _spdInc; }
	else if (cSpd < -(maxSpd)-_spdInc){ cSpd += _spdInc; }
	_walkLeft = true;
	xScale = -1;
	
}else{
	if (cSpd > _spdInc){ cSpd -= _spdInc; }
	else if (cSpd < -_spdInc){ cSpd += _spdInc; }
	else{
		cSpd = 0;
	}
}

if !(_canWalkLeft) && (x < 20){ if (cSpd < 0){ cSpd = 0; } }

if (isPlayer){
	x += cSpd;
}else{
	x += (xxTo - x) * 0.5;
}

#endregion

#region walk & idle animations

if (state == ""){
	if (sprite_index == sPlayerThrow) or (sprite_index == sPlayerGrab){
		if (image_index >= image_number-1.5){ sprite_index = sPlayer; image_index = 0;}
	}
	
	if ((_walkRight) or (_walkLeft)){
		//if we are walking:
		slowSin += .015;
		if (sprite_index == sPlayer) or (sprite_index == sPlayerBlink){ sprite_index = sPlayerWalk; }

	}else{
		//if we aren't walking:
		if (sprite_index == sPlayerWalk){
			if !(((image_index % sprite_get_number(sPlayer)) <= 1) && ((image_index % sprite_get_number(sPlayer)) >= 0))
			&& !(((image_index % sprite_get_number(sPlayer)) <= 20) && ((image_index % sprite_get_number(sPlayer)) >= 19)){
				//still walking
			}else{
				 sprite_index = sPlayer;
			}
		}else{
			
			if (sprite_index == sPlayer){
				if (canBlink > 0){ canBlink--; }
				else{
					canBlink = irandom(room_speed*8);
					sprite_index = sPlayerBlink;
					blinkTime = irandom_range(7, 12);
				}
			}else if (sprite_index == sPlayerBlink){
				if (blinkTime > 0){ blinkTime--; }
				else{
					sprite_index = sPlayer;
				}
			}
			
			
		}
	}
}

#endregion

if (isPlayer){
	
	if (state == ""){
		if (SPACE_PRESSED) && !((sprite_index == sPlayerThrow) && (image_index >= 67)){
			state = "grab";
			sprite_index = sPlayerGrab;
			image_index = 0;
			photon_realtime_player_properties_set_local_i32("sprite_index", sprite_index);
			photon_realtime_player_properties_set_local_i32("image_index", image_index);
		}
	}
	
	if (state == "grab"){
		
		if (sprite_index == sPlayerGrab){
			if (SPACE){
				if (place_meeting(x+(48*xScale), y, oWaterball)){
					//at water!
					if (image_index >= 6){
						sprite_index = sPlayerThrow;
						var _catch = instance_place(x+(48*xScale), y, oWaterball);
						if (_catch != noone){
							with(_catch){
								instance_create_depth(x, y, depth-1, oPickupEffect);
								audio_play_sound(sfxSelect, 1, false, 0.8,, random_range(1.1, 1.2));
								instance_destroy();
							}
						}
					}
					
				}else{
					
					if (image_index >= 6){ image_index = 6; }
					
				}
			}else{
				if (image_index > 6){ state = ""; }
			}
		}
		
		if (sprite_index == sPlayerThrow){
			
			if (SPACE_RELEASED) or (image_index >= 67){
				
				var _index = (image_index - 6) / (66 - 6);	//the longer you hold the higher this is from 0 to 1
				var _myWater = instance_create_depth(x, y-150, depth-1, oWaterball);
					_myWater.grav = -14 + (6 * _index);
					_myWater.spd = (-1.5 + (_index * 10))*xScale;
					
				var _posGrav = abs(_myWater.grav);
				var _posSpd = abs(_myWater.spd);
				var _xScale = 0;
				if (xScale == -1){ _xScale = 1; }
				
				var b = buffer_create(64, buffer_grow, 1);
				buffer_seek(b, buffer_seek_start, 0);
				buffer_write(b, buffer_u16, 1);
				buffer_write(b, buffer_u16, x);
				buffer_write(b, buffer_u16, y-150);
				buffer_write(b, buffer_u16, _posGrav);
				buffer_write(b, buffer_u16, _posSpd);
				buffer_write(b, buffer_u16, _xScale);
				photon_realtime_operation_raise_event_buffer(true, b, buffer_tell(b), 100);
	
				buffer_delete(b)
			
				image_index = 67;
				photon_realtime_player_properties_set_local_i32("image_index", image_index);
				
				state = "";
			}
			
		}
		
	}
	
	
	if (sprite_index == sPlayerThrow){
		if (image_index < 30) && (SPACE_RELEASED){
			
			
		}
		if (image_index >= image_number-2){ sprite_index = sPlayer; animating = false; }
	}
	

}

#region angle

/*

bodyAngle = sin(slowSin)*2;		//breathing effect for body.

var _isPlayer = isPlayer;
if (_isPlayer){
	
	if (_walkRight) && (angleDir == -1) && (canSwitchAngleDir <= 0){
		if (neckSpd > -12){
			neckSpd -= 0.2;
		
			if (neckSpd < -6){
				neckSpd -= 0.3;
			}
			if (headAngle > 320){
				neckSpd -= 0.4;
			}
		}
		if (neckAngle < 15){
			neckAngle -= neckSpd/50;
			if (neckAngle < 0){
				neckAngle -= neckSpd/25;
			}
		}
		if (anglePullDown > 0){ anglePullDown -= 0.5; }
	
	}else if (_walkLeft) && (angleDir == 1) && (canSwitchAngleDir <= 0){
		if (neckSpd < 12){
			neckSpd += 0.2;
		
			if (neckSpd > 6){
				neckSpd += 0.3;
			}
			if (headAngle < 40){
				neckSpd += 0.4;
			}
		}
	
		if (neckAngle > -15){
			neckAngle -= neckSpd/50;
			if (neckAngle > 0){
				neckAngle -= neckSpd/25;
			}
		}
		if (anglePullDown > 0){ anglePullDown -= 0.5; }
	
	}else{
		if (neckAngle > 0.3){ neckAngle -= 0.25; }
		else if (neckAngle < -0.3){ neckAngle += 0.25; }
	
		if (neckSpd > 0.4){ neckSpd -= 0.5; }
		else if (neckSpd < -0.4){ neckSpd += 0.5; }
		else{ neckSpd = 0; }
	
		if (anglePullDown < 5) && (angleCanPullDown <= 0){ anglePullDown += 0.5; }
		else{
			if (anglePullDown > 0){
				anglePullDown -= 0.5;
			}
		}
	
		if (angleCanPullDown > 0){ angleCanPullDown--; }
	}

	if (headAngle > 40) && (headAngle < 320) && (angleCanPullDown > 0){ angleCanPullDown--; }


	headAngle += neckSpd;

	if (angleDir == 1){
		if (headAngle > 20){ headAngle -= (anglePullDown + (neckSpd/1.5)); }
		else if (angleCanPullDown <= 0){ neckSpd = 0; angleCanPullDown = 20; }
	
		if (headAngle > 175) && (canSwitchAngleDir <= 0){
			angleDir = -1;
			canSwitchAngleDir = 22;
		}
	}else if (angleDir == -1){
		if (headAngle < 340){ headAngle -= (-anglePullDown + (neckSpd/1.5)); }
		else if (angleCanPullDown <= 0){ neckSpd = 0; angleCanPullDown = 20; }
	
		if (headAngle < 185) && (canSwitchAngleDir <= 0){
			angleDir = 1;
			canSwitchAngleDir = 22;
		}
	}

}

//*/

#endregion

/*
var _head = false;
var _dragonSpd = 1;
if (headAngle > 98) && (headAngle < 165){
	if (isPlayer){ x -= _dragonSpd+dragonSpdExtra; }
	_head = true;
}
if (headAngle > 98+90) && (headAngle < 165+90){
	if (isPlayer){ x += _dragonSpd+dragonSpdExtra; }
	_head = true;
}
if !(_head){
	dragonSpdExtra = 0;
}else{
	if (dragonSpdExtra < 15){ dragonSpdExtra += 0.008; }
	if (dragonSpdExtra < 3){ dragonSpdExtra += 0.015; }
	if (dragonSpdExtra < 5){ dragonSpdExtra += 0.003; }
}

if (pressSpace) or (_head){
	if (headIndex > 39){ headIndex = 0; }
	else if (headIndex >= 39){ headIndex = 6; }
	
	headIndex++;
	
	if (mySound == -1) or !(audio_is_playing(mySound)){
		mySound = audio_play_sound_on(myEmitter, sfxLoop, true, 1);
		audio_sound_gain(mySound, 0, 0);
	}
	if (mySoundGain < 0.5){ mySoundGain += 0.1; }
	if (mySoundGain < 1){ mySoundGain += 0.0025; }
	
	
	
}else{
	if (headIndex < 4){ headIndex = 0; }
	else{ headIndex++; }
	if (headIndex >= 4) && (headIndex < 40){ headIndex = 40; }
	if (headIndex >= 44){ headIndex = 0; }
	
	if (mySoundGain > 0){ mySoundGain -= 0.05; }
	else{mySoundGain = 0; }
}

if (mySound != -1) && (audio_is_playing(mySound)){
	audio_sound_gain(mySound, mySoundGain, 0);
	audio_sound_pitch(mySound, 1 + (neckAngle/20));
}


if (isPlayer){
	var _ready = photon_realtime_player_properties_get_local_bool("ready");
	if (x > 220) && !(_ready){
		//photon_realtime_player_properties_set_local_bool("ready", true);
	}else if (x < 218) && (_ready){
		//photon_realtime_player_properties_set_local_bool("ready", false);
	}
	
	if (x > 2014){
		if (photon_realtime_room_properties_get_string("game_state") != "finish"){
			photon_realtime_room_properties_set_string("game_state", "finish");
			oControl.game_state = "finish";
			king = true;
			photon_realtime_player_properties_set_local_bool("king", king);
			global.shake = 5;
		}
	}
}
//*/
//if (keyboard_check_pressed(ord("L"))){ room_speed = 5; }
//if (keyboard_check_pressed(ord("K"))){ room_speed = 60; }