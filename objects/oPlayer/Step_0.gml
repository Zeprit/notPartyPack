var _spdInc = 0.5;
if (keyboard_check(vk_right)){
	if (cSpd < maxSpd){ cSpd += _spdInc; }
}else if (keyboard_check(vk_left)){
	if (cSpd > -maxSpd){ cSpd -= _spdInc; }
}else{
	if (cSpd > _spdInc){ cSpd -= _spdInc; }
	else if (cSpd < -_spdInc){ cSpd += _spdInc; }
	else{
		cSpd = 0;
	}
}

x += cSpd;