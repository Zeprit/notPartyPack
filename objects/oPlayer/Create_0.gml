cSpd = 0;
maxSpd = 3;
myID = -1;

dragonSpdExtra = 0;
king = false;

canBlink = irandom(room_speed*6);
blinkTime = 0;


slowSin = 0;
state = "";

bodyAngle = 0;
neckAngle = 0;
headAngle = 20;
neckSpd = 0;	//variable used to accelerate the strength or speed the neck is turning directions
angleDir = 1;	//what direction are we turning to?
anglePullDown = 0;
angleCanPullDown = 0;	//needed so that gravity resets in certain positions
canSwitchAngleDir = 0;	//can we switch the angle direction?

xScale = 1;

legIndex = 0;
headIndex = 0;


pressRight = 0;
pressLeft = 0;
pressSpace = 0;

//other player:
isPlayer = false;
xxTo = x;


myEmitter = audio_emitter_create();
mySound = -1;
mySoundGain = 0;


animating = false;