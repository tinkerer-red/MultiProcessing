show_debug_overlay(true);

current_input_index = 0

factorial_example = function(_x, _time) {
	var _t = _x-1;
	var _v = _x;
	repeat (_x-2){
		_t--;
		_v *= _t;
	}
	return {input: _x, result: _v, time: _time};
}

callback_example = function(_response) {
	var _input  = _response.input;
	var _result = _response.result;
	var _time   = _response.time;
	
	if (_input mod 1000 == 0) {
		var _ms_time = (get_timer()-_time)/1_000;
		show_debug_message(string("Time: {0} Input: {1}, Result: {2}", _ms_time, _input, _result))
		
		if (_input == 100_000) {
			show_message_async("🎉🎉🎉 Test Successful! 🎉🎉🎉")
		}
	}
	
	remote_execute(factorial_example, [current_input_index, get_timer()], callback_example);
	current_input_index+=1;
}

