if (isPlayer){
	pressRight =	(keyboard_check(vk_right)) or (keyboard_check(ord("D")));
	pressLeft =		(keyboard_check(vk_left)) or (keyboard_check(ord("A")));
	pressSpace =	(keyboard_check(vk_space));
}

audio_emitter_position(myEmitter, x, y, 0);

#macro RIGHT pressRight
#macro LEFT pressLeft
#macro SPACE pressSpace

#region effects
slowSin += .015;

if (canSwitchAngleDir > 0){ canSwitchAngleDir--; }
#endregion

#region movement
var _spdInc = 0.5;
var _canWalkRight = true, _canWalkLeft = true;
var _walkRight = false, _walkLeft = false;
var _spdDivide = 1;

if ((oControl.game_state != "go") && (oControl.game_state != "finish")) && (x > 230){ _canWalkRight = false; }
if (x < 20){ _canWalkLeft = false; }

if (RIGHT) && !(LEFT){
	if (angleDir == -1){ _spdDivide = 3; }	//go slower when we are actually moving the other way
	if (cSpd < (maxSpd/_spdDivide)){ cSpd += _spdInc; }
	else if (cSpd >= (maxSpd/_spdDivide)+_spdInc){ cSpd -= _spdInc; }
	_walkRight = true;
	
}else if (LEFT) && !(RIGHT){
	if (angleDir == 1){ _spdDivide = 3; }
	if (cSpd > -(maxSpd/_spdDivide)){ cSpd -= _spdInc; }
	else if (cSpd < -(maxSpd/_spdDivide)-_spdInc){ cSpd += _spdInc; }
	_walkLeft = true;
	
}else{
	if (cSpd > _spdInc){ cSpd -= _spdInc; }
	else if (cSpd < -_spdInc){ cSpd += _spdInc; }
	else{
		cSpd = 0;
	}
}

if (isPlayer){
	x += cSpd;
}else{
	x += (xxTo - x) * 0.5;
}
if !(_canWalkRight) && (x > 230){ x = 230; if (cSpd > 0){ cSpd = 0; } }
if (x > 2850){ x = 2850; }
if !(_canWalkLeft) && (x < 20){ x = 20; if (cSpd < 0){ cSpd = 0; } }

if (_walkRight) or (_walkLeft){
	slowSin += .015;
	legIndex += 0.3 + ((1/_spdDivide)*0.7);
}else{
	if !(((legIndex % sprite_get_number(sPlayer)) <= 1) && ((legIndex % sprite_get_number(sPlayer)) >= 0))
	&& !(((legIndex % sprite_get_number(sPlayer)) <= 31) && ((legIndex % sprite_get_number(sPlayer)) >= 30)){
		legIndex++;
	}
}
#endregion

#region angle
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

#endregion

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

if (SPACE) or (_head){
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
		photon_realtime_player_properties_set_local_bool("ready", true);
	}else if (x < 218) && (_ready){
		photon_realtime_player_properties_set_local_bool("ready", false);
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

//if (keyboard_check_pressed(ord("L"))){ room_speed = 5; }
//if (keyboard_check_pressed(ord("K"))){ room_speed = 60; }