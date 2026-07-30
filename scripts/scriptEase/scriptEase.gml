//scripts for easy effects

#region Bounce(_time, _begin, _change, _duration)
function Bounce(_time, _begin, _change, _duration){
	var s = 1.7; //1.7
	var p = 0;
	var a = _change;
	if (_time == 0){ return _begin;}
	_time /= _duration;
	if (_time == 1){ return _begin + _change;}
	if (!p){ p = _duration*.4; } //_duration*.3;
	if (a < abs(_change)){
		a = _change;
		s = p/4;
	}else{
		s = p/(5*pi)*arcsin(_change/a); //2*pi
	}
	
	return a * power(2,-10*_time) * sin((_time*_duration-s)*(2*pi)/p) +_change +_begin;
}
#endregion