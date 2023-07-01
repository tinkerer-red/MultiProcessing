# MultiProcessing
A simple MultiProcessing example in gml. With a heavy focus on simplicity for newer users.

### Example:
```gml
///create
factorial = function(_x) {
	var _t = _x-1;
	var _v = _x;
	repeat (_x-2){
		_t--;
		_v *= _t;
	}
	return _v;
}

callback_example = function(_response) {
	show_debug_message(string("Factorial Value: {0}", _response))
}

//key-release [spacebar]
for (var _i=0; _i<=1_000; _i++) {
	remote_execute(factorial, [_i], callback_example);
}
```
