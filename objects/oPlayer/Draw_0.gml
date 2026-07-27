


draw_sprite_ext(sPlayerNeck, image_index, x + lengthdir_x(128,bodyAngle+90), y + lengthdir_y(128,bodyAngle+90) + (256*(sin(slowSin)*.008)), image_xscale * angleDir, image_yscale, neckAngle + bodyAngle, image_blend, image_alpha);

draw_sprite_ext(sprite_index, legIndex, x, y, (image_xscale + (sin(slowSin)*.016)) * angleDir, (image_yscale - (sin(slowSin)*.016)), bodyAngle, image_blend, image_alpha);

draw_sprite_ext(sPlayerHead, headIndex,	x + lengthdir_x(128, bodyAngle+90) + lengthdir_x(118, neckAngle+bodyAngle+90), y + lengthdir_y(128, bodyAngle+90) + (256*(sin(slowSin)*.016)) + lengthdir_y(118, neckAngle+bodyAngle+90), image_xscale * angleDir, image_yscale, headAngle, image_blend, image_alpha);


//draw_text(x, y-280, $"neckAngle: {neckAngle}, headAngle: {neckAngle}, neckSpd: {neckSpd}, pullDown: {anglePullDown}");
draw_text(x, y-280, $"myID: {myID}");