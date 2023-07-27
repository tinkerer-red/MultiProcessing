if (!__mp_is_main_process()) { exit; };


var _cb_count = "0";
if (MultiProcessing_Use_Structs) {
	var _arr = struct_get_names(__MP.request_callbacks);
	var _count = array_length(_arr);
	_cb_count = string(_count);
}
else {
	var _count = ds_map_size(__MP.request_callbacks);
	_cb_count = string(_count);
}
	
	
var _connect_str = (__MP.workers_connected) ? "true" : "false"
draw_text(0,32,
		"Connected :" + _connect_str + "\n" +
		"Child Process IDs : " + string(global.__MultiProcessingChildProcessID) + "\n" + 
		"Last Returned Result : " + draw_txt + "\n" +
		"\n" +
		"Current Task Index : " + string(__MP.task_index) + "\n" + 
		"Cached Callbacks Count : " + _cb_count + "\n" + 
		"\n" +
		"Current Requests Index : " + string(__MP.request_index) + "\n" +
		"Pending Request Count : " + string(ds_map_size(__MP.pending_requests)) + "\n" +
"\n")