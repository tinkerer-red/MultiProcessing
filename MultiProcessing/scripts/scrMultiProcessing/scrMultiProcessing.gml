#region jsDoc
/// @func    remote_execute()
/// @desc    Execute a function with supplied arguments on a separate process, when a response is returned this will pass the function's return into the callback as an argument.
///
///          .
///
///          Note: This will trigger the async networking event, although this message will be processed by the multiprocessing handler
/// @param   {Function} func : The function to execute.
/// @param   {Array} arg : The arguments for the function.
/// @param   {Function} callback : The function or method to be executed when a responce has been recieved, this will pass the function's return into the callback as an argument.
#endregion
function remote_execute(_func, _args = undefined, _callback = undefined) {
	static empty_arr = []; //prevent the need to create new arrays every time
	static empty_func = function(_result){}; //prevent the need to create new methods every time
	
	//is the first is null/undefined use the second
	_args ??= empty_arr;
	_callback ??= empty_func;
	
	with (__MP) {
		var _request = new make_request(_func, _args, task_index);
		var _request_callback = _callback;
		
		//cache the callback info
		if (MultiProcessing_Use_Structs) {
			request_callbacks[$ string(task_index)] = _request_callback;
		}
		else {
			request_callbacks[? string(task_index)] = _request_callback;
		}
		
		//enqueue the request so we can send multiple requests through a single packet
		array_push(task_queue, _request);
		task_index++
		
	}
}

#region jsDoc
/// @func    remote_execute_all()
/// @desc    Execute a function with supplied arguments on a separate process, when a response is returned this will pass the function's return into the callback as an argument.
///
///          .
///
///          Generally this is used to keep processes alive, or end them all, but it can also be used to update subprocesses to store bulk data on all processes.
///
///          .
///
///          Note: This will trigger the async networking event, although this message will be processed by the multiprocessing handler
/// @param   {Function} func : The function to execute.
/// @param   {Array} arg : The arguments for the function.
/// @param   {Function} callback : The function or method to be executed when a responce has been recieved, this will pass the function's return into the callback as an argument.
#endregion
function remote_execute_all(_func, _args = undefined, _callback = undefined) {
	static empty_arr = []; //prevent the need to create new arrays every time
	static empty_func = function(_result){}; //prevent the need to create new methods every time
	
	//is the first is null/undefined use the second
	_args ??= empty_arr;
	_callback ??= empty_func;
	
	with (__MP) {
		var _request = new make_request(_func, _args, task_index);
		var _request_callback = _callback;
		
		//cache the callback info
		if (MultiProcessing_Use_Structs) {
			request_callbacks[$ string(task_index)] = _request_callback;
		}
		else {
			request_callbacks[? string(task_index)] = _request_callback;
		}
		
		//enqueue the request so we can send multiple requests through a single packet
		inform_all_children(_request)
		task_index++
	}
}

#region Header
	
	#macro MP_Version "1.0.0"
	show_debug_message("[Red's MultiProcessing] : Thank you for using Red's MultiProcessing!");
	show_debug_message("[Red's MultiProcessing] : Version : "+MP_Version);
	
#endregion

#region Environment Variables
	
	//instance id : used to keep track of what instance number the process is
	global.__MultiProcessingInstanceID = int64(bool(EnvironmentGetVariableExists("MultiProcessingInstanceID")) ? EnvironmentGetVariable("MultiProcessingInstanceID") : string(0));
	if (!EnvironmentGetVariableExists("MultiProcessingInstanceID")){
		EnvironmentSetVariable("MultiProcessingInstanceID", string(global.__MultiProcessingInstanceID));
	}
	if (!EnvironmentGetVariableExists("MultiProcessingGameEnd")){
		EnvironmentSetVariable("MultiProcessingGameEnd", "0");
	}
	if (!EnvironmentGetVariableExists("MultiProcessingMainProcessID")){
		if (__mp_is_main_process()) {
			EnvironmentSetVariable("MultiProcessingMainProcessID", string(ProcIdFromSelf()));
		}
	}
	
	// Process ID list : used to keep track of all the processes, so when one is closed all of them can be closed
	global.__MultiProcessingChildProcessID = [];
	
	// Processor Count : used to determin how many processes we should spawn.
	if (MultiProcessing_Unlock_Number_Of_Processes) {
		global.__MultiProcessingProcessorCount = clamp(floor(cpu_numcpus()*MultiProcessing_Percent_Of_Threads+0.5), MultiProcessing_Number_Of_Processes_Min, MultiProcessing_Number_Of_Processes_Max);
	}
	else {
		global.__MultiProcessingProcessorCount = clamp(
				floor(cpu_numcpus()*MultiProcessing_Percent_Of_Threads+0.5),
				MultiProcessing_Number_Of_Processes_Min,
				min(cpu_numcpus()-1, MultiProcessing_Number_Of_Processes_Max)
			);
	}

#endregion

#region Init
	
	//create the corosponding object
	#macro __MP global.__MultiProcessing
	if (!MultiProcessing_Require_Init_Script) {
		time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, MultiProcessingInit));
	};
	
#endregion

#region Internal
	
	#region Server/Worker Constructors
		
		function __mp_core() constructor {
			
			connected = false;
			life_time = time_source_create(time_source_game, MultiProcessing_TTL, time_source_units_seconds, game_end);
			
			#region Packet management
				
				#region Constructors
					
					static make_request = function(_func, _args, _index) constructor {
						//convert a method into an asset index
						if (typeof(_func) == "method") {
							func = asset_get_index(script_get_name(_func))
						}
						else {
							func = _func;
						}
						
						args = (is_array(_args)) ? _args : [_args]; //the arguments for the function above
						index = _index; //the index used for the request, used to run the correct callback
					}
					static make_sent_request = function(_tasks) constructor {
						tasks = _tasks;
						sent_time = get_timer();
					}
					
				#endregion
				
				#region Data Management
					
					static send_struct = function(_socket, _struct) {
						var _buff = encode_struct(_struct);
						network_send_packet(_socket, _buff, buffer_tell(_buff));
						buffer_delete(_buff);
					}
					static encode_struct = function(_struct) {
						var _buff = buffer_create(1, buffer_grow, 1);
						var _json = json_stringify(_struct);
						
						buffer_seek(_buff, buffer_seek_start, 0);
						buffer_write(_buff, buffer_string, _json);
						
						return _buff;
					}
					static decode_struct = function(_buff){
						buffer_seek(_buff, buffer_seek_start, 0);
						var _json = buffer_read(_buff, buffer_string);
						
						try {
							var _r = json_parse(_json);
						}
						catch(error) {
							var _r = undefined;
						}
						
						return _r;
					}
					
				#endregion
				
				#region GML Events
					
					static gameend = function() {
						
					};
					
				#endregion
				
			#endregion
			
			#region useful function
				
				//used to spawn the subprocesses
				static processes_start_all = function() {
					var _length = array_length(global.__MultiProcessingChildProcessID)
					var _alive_proc_count = 0;
					var _i=0; repeat(_length) {
						var _procId = global.__MultiProcessingChildProcessID[_i];
						if (ProcIdExists(_procId)) {
							_alive_proc_count+=1;
						}
						else {
							array_delete(global.__MultiProcessingChildProcessID, _i, 1);
							continue;
						}
					_i+=1;}//end repeat loop
					
					var _spawn_count = global.__MultiProcessingProcessorCount - _alive_proc_count
					if (_spawn_count > 0) {
						time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, function(_spawn_count){
							repeat(_spawn_count) {
								SpawnMultiProcessing()
							}
					
						}, [_spawn_count]));
					}
				}
				//inform followers to drink the kool-aid
				static mass_suicide = function() {
					EnvironmentSetVariable("MultiProcessingGameEnd", "1");
				}
				//check to see if leader has drank the kool-aid
				static attempt_suicide = function() {
					var _str = EnvironmentGetVariable("MultiProcessingGameEnd");
					var _main_proc_id = EnvironmentGetVariable("MultiProcessingMainProcessID");
					
					var _bool = max(!ProcIdExists(_main_proc_id), bool(real(_str)))
					if (_bool) {
						//drink the kool-aid
						game_end();
					}
				}
				//keeps a child process alive for another 5 seconds
				static stay_alive = function() {
					time_source_reset(life_time);
					time_source_start(life_time);
				}
				
			#endregion
			
		}
		function __mp_server() : __mp_core() constructor {
			
			#region Config
				
				networking_socket_type = MultiProcessing_Socket;
				processer_count = global.__MultiProcessingProcessorCount;
				percent_of_frame = MultiProcessing_Percent_Of_Frame;
				networking_port = MultiProcessing_Port;
				server = network_create_server(networking_socket_type, networking_port, processer_count)
				
			#endregion
			
			#region System
				
				if (MultiProcessing_Use_Structs) {
					request_callbacks = {}; //callbacks for requests which have been sent out
				}
				else {
					request_callbacks = ds_map_create(); //callbacks for requests which have been sent out
				}
				pending_requests = ds_map_create(); //request which have been sent out but have not recieved a response
				task_queue = []; //these are the tasks which have yet to be sent out to children
				task_index = 0; //The number of tasks which have already been sent out
				request_index = 0; //The number of bulk requests made, this is generally task_index/processor_count
				worker_sockets = ds_list_create(); //a ds list of the sockets
				worker_index = 0; //the current index of the worker we will be sending data out to next.
				workers_connected = false; //is all of the workers are connected
				
				time_source_start(time_source_create(time_source_game, 1, time_source_units_seconds, keep_children_alive, [], -1));
				
			#endregion
			
			#region Methods
				
				static send_request = function(_request) {
					var _socket = worker_sockets[| worker_index];
					send_struct(_socket, _request);
					
					if (MultiProcessing_GC_SAFE) {
						var _prending_request = new make_sent_request(_request);
						pending_requests[? string(request_index)] = _prending_request
					}
					
					worker_index+=1;
					request_index+=1;
					
					if (worker_index >= ds_list_size(worker_sockets)) { worker_index -= ds_list_size(worker_sockets); } ;
				}
				
				//check to see if any tasks need to be resent
				static parse_sent_requests = function() {
					if (!MultiProcessing_GC_SAFE) { return; };
					
					var _arr = ds_map_keys_to_array(pending_requests, []);
					
					var _i=0; repeat(array_length(_arr)) {
						var _request_index = _arr[_i];
						var _request_struct = pending_requests[? _request_index];
						var _bulk_request = _request_struct.tasks;
						
						//remove tasks which have been completed
						var _j=0; repeat(array_length(_bulk_request)) {
							var _task = _bulk_request[_j];
							var _exists = (MultiProcessing_Use_Structs) ? struct_exists(request_callbacks, string(_task.index)) : ds_map_exists(request_callbacks, string(_task.index));
							
							if (!_exists) {
								//reset the timer because we are still getting responses
								_request_struct.sent_time = get_timer();
								
								array_delete(_bulk_request, _j, 1);
								continue;
							}
						_j+=1;}//end repeat loop
						
						//cleanup the bulk request if all tasks are completed
						if (array_length(_bulk_request) == 0) {
							ds_map_delete(pending_requests, _request_index);
							_i+=1;
							continue;
						}
						
						//if its been an entire second with no response resend it again.
						static _frame_time = (1_000/MultiProcessing_Frame_Speed)*1_000;
						if ((get_timer()-_request_struct.sent_time)/1000 > _frame_time) {
							var _length = array_length(_bulk_request)
							
							//show_debug_message(":: MultiProcessing :: Pushing :: "+string(_length)+" tasks :: from request index "+string(_request_index));
							task_queue = array_concat(task_queue, _bulk_request)
							
							ds_map_delete(pending_requests, _request_index);
							
						}
						
					_i+=1;}//end repeat loop
				}
				//used to send an update message to all children, can be used to update some global data
				static inform_all_children = function(_request) {
					var _i=0; repeat(ds_list_size(worker_sockets)) {
						var _socket = worker_sockets[| _i];
						send_struct(_socket, [_request])
					_i+=1;}//end repeat loop
				}
				//used to inform all subprocesses to stay alive
				static keep_children_alive = function() {
					with (__MP) {
						inform_all_children(new make_request(stay_alive, [], -1))
					}
				}
				
			#endregion
			
			#region GML Events
				
				//async event happens after step, and before end_step, so to ensure we get it the next frame pass tasks over right after the async event.
				static end_step = function() {
					parse_sent_requests();
					
					var _size = array_length(task_queue);
					if (_size != 0) {
						//early out when too much time has passed
						var start_time = get_timer();	// 
						static frame_cap = 1_000_000/MultiProcessing_Frame_Speed*percent_of_frame
						var runTime = frame_cap/game_get_speed(gamespeed_fps);				// in Milliseconds. 1 frame is about 16ms. Have to leave time for other stuff too.
						
						var _workers = ds_list_size(worker_sockets);
						var _task_per_worker = ceil(_size/_workers);
						
						var _bulk_request = [];
						var _all_popped = false;
						
						static _task_per_frame_limit = (MultiProcessing_Tasks_Per_Frame < 0) ? infinity : MultiProcessing_Tasks_Per_Frame;
						
						var _bulk_request, _dt, _num_requests;
						repeat(_workers) {
							_num_requests = 0;
							
							var _tasks_for_worker = min(_task_per_worker, array_length(task_queue), _task_per_frame_limit)
							_num_requests += _tasks_for_worker;
							
							if (_tasks_for_worker > 0) {
								array_copy(_bulk_request, 0, task_queue, 0, _tasks_for_worker)
								array_delete(task_queue, 0, _tasks_for_worker)
								
								//send the request out
								send_request(_bulk_request);
								_bulk_request = [];
							}
							
							if (_num_requests >= _task_per_frame_limit) {
								break;
							}
							
							//early out so we can make use of the rest of the time between frames to build and send the requests out
							if ((get_timer()-start_time) > runTime) {
								break;
							}
							
						}; //end outer repeat
					}
					
				};
				static async = function(_async_load) {
					var _type_event = ds_map_find_value(_async_load, "type");
					
					var _indexes_to_destroy = [];
					
					switch(_type_event){
						case network_type_connect: {
							var _socket = ds_map_find_value(_async_load, "socket")
							ds_list_add(worker_sockets, _socket)
							
							if (ds_list_size(worker_sockets) >= processer_count){
								workers_connected = true;
								time_source_start(time_source_create(time_source_game, 1, time_source_units_frames, window_focus));
							}
							
							show_debug_message("Worker number \""+string(ds_list_size(worker_sockets))+"\" connected with socket: "+string(_socket))
						break;}
						case network_type_disconnect: {
							if (MultiProcessing_Respawn) {
								//this could be lower like 0.25 but to be safe we'll assure the process is fully killed from OS
								time_source_start(time_source_create(time_source_game, 0.5, time_source_units_seconds, processes_start_all));
							}
						break;}
						case network_type_data: {
							var _buffer = ds_map_find_value(_async_load, "buffer")
							var _socket = ds_map_find_value(_async_load, "id")
							
							var _returned_struct = decode_struct(_buffer);
							var _return_tasks = _returned_struct.arr;
							
							if (is_array(_return_tasks)){
								var _size = array_length(_return_tasks)
								var _i=0; repeat(_size) {
									var _task = _return_tasks[_i];
							
									//check the data and load the callbacks for the handled data
									var _index = _task.index;
									var _result = _task.result;
									
									//we have probably already processed that callback and this is a second safety pass
									if (MultiProcessing_Use_Structs) {
										if (!struct_exists(request_callbacks, string(_index))) {
											_i+=1;
											continue;
										}
									}
									else {
										if (!ds_map_exists(request_callbacks, string(_index))) {
											_i+=1;
											continue;
										}
									}
									
									var _callback = (MultiProcessing_Use_Structs) ? request_callbacks[$ string(_index)] : request_callbacks[? string(_index)];
									
									// If we sent a request right before recieving the result, this will be undefined on the second response so we can safely skip it.
									if (_callback == undefined) {
										//var _json = (MultiProcessing_Use_Structs) ? json_stringify(request_callbacks, true) : json_encode(request_callbacks, true);
										//show_error("index = "+string(_index)+"\n"+_json, true)
										_i+=1; continue;
									}
									
									_callback(_result);
									
									array_push(_indexes_to_destroy, _index)
									
									objMultiProcessing.draw_txt = string(_result);
									
								_i+=1}
							}
							
							buffer_delete(_buffer)
							
						break;}
					}
					
					//clean up those indexes from the request callbacks
					if (MultiProcessing_Use_Structs) {
						var _i=0; repeat(array_length(_indexes_to_destroy)) {
							struct_remove(request_callbacks, string(_indexes_to_destroy[_i]))
						_i+=1;}//end repeat loop
					}
					else {
						var _i=0; repeat(array_length(_indexes_to_destroy)) {
							ds_map_delete(request_callbacks, string(_indexes_to_destroy[_i]))
						_i+=1;}//end repeat loop
					}
					
				};
				static gameend = function() {
					//processes_end_all();
					mass_suicide();
				}
				
			#endregion
			
		}
		function __mp_worker() : __mp_core() constructor {
			
			#region Config
				
				networking_socket_type = MultiProcessing_Socket;
				networking_port = MultiProcessing_Port;
				
			#endregion
			
			#region System
				
				window_hide()
				game_set_speed(1, gamespeed_microseconds);
				
				//start the death timer
				time_source_start(life_time);
				
				//switch to an always inactive room
				ROOM = room_add();
				room_goto(ROOM);
				
				//connect to the host
				client = network_create_socket(networking_socket_type)
				network_connect_async(client, "127.0.0.1", networking_port) //this defaults to a PULL connection
				connected = false;
				workers_connected = false;
				
			#endregion
			
			#region Methods
				
				static return_results = function(_results) {
					//send all results back to the server
					send_struct(client, _results)
				}
				static run_task = function(_struct) {
					if (!is_undefined(_struct))
					&& (is_struct(_struct)) {
						var _func = _struct.func;
						var _args = _struct.args;
						var _index = _struct.index;
						
						var _length = array_length(_args);
						
						//An alternitive to the waterfall of doom as proposed by YellowAfterlife
						// NOTE : I know this is really unnecessary optimization as most functions only require a few arguments. But I found it interesting at the time.
						// This is not really needed for 2.3 but is needed for when i port this back to gm8 and gms1.4
						if (_length > 16) {
							show_error("Worker process \""+string(global.__MultiProcessingInstanceID)+"\" can not run function: \""+script_get_name(_func)+"\" with more then 16 arguments. \n arguments:"+string(_args), true)
						}
						
						if (_length < 8) {
							if (_length < 4) {
								if (_length < 2) {
									if (_length == 1) {
										var _result = _func(_args[0])
									}
									else{
										var _result = _func()
									}
								}
								else {
									if (_length == 3) {
										var _result = _func(_args[0], _args[1], _args[2])
									}
									else{
										var _result = _func(_args[0], _args[1])
									}
								}
							}
							else {
								if (_length < 6) {
									if (_length == 5) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4])
									}
									else{
										var _result = _func(_args[0], _args[1], _args[2], _args[3])
									}
								}
								else {
									if (_length == 7) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6])
									}
									else{
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5])
									}
								}
							}
						}
						else {
							if (_length < 12) {
								if (_length < 10) {
									if (_length == 9) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8])
									}
									else{
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7])
									}
								}
								else {
									if (_length == 11) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10])
									}
									else{
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9])
									}
								}
							}
							else {
								if (_length < 14) {
									if (_length == 13) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12])
									}
									else{
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11])
									}
								}
								else {
									if (_length < 15) {
										var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14])
									}
									else{
										if (_length == 16) {
											var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13], _args[14], _args[15])
										}
										else {
											var _result = _func(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6], _args[7], _args[8], _args[9], _args[10], _args[11], _args[12], _args[13])
										}
									}
								}
							}
						}
						
						var _returned_struct = {};
						_returned_struct.index = _index;
						_returned_struct.result = _result;
						
						return _returned_struct
					}
					else {
						show_error("Worker process \""+string(global.__MultiProcessingInstanceID)+"\" __MP.run_task() can not process supplied struct! \n struct:"+string(_struct), true)
					}
				}
				
			#endregion
			
			#region GML Events
				
				static end_step = function() {
					attempt_suicide();
				}
				static async = function(_async_load) {
					var _type_event = ds_map_find_value(_async_load, "type");
					
					switch(_type_event){
						case network_type_connect: {
							var _socket = ds_map_find_value(_async_load, "socket")
						break;}
						case network_type_disconnect: {
							var _socket = ds_map_find_value(_async_load, "socket")
							var _succeeded = ds_map_find_value(_async_load, "succeeded")
							if (_succeeded == 0){
								game_end()
							}
						break;}
						case network_type_non_blocking_connect: {
							connected = _async_load[? "succeeded"];
							workers_connected = connected;
						break;}
						case network_type_data: {
							var _buffer = ds_map_find_value(_async_load, "buffer");
							var _socket = ds_map_find_value(_async_load, "id");
							
							var _bulk_request = decode_struct(_buffer);
							
							//Sometimes a buffer is loaded in chunks, but for the rest of those times this check is specifically for when data is lost through the TCP protocal, Gamemaker has a nasty habit of writing over memory which subprocesses are currently using, leading to getting an invalid buffer
							if (_bulk_request == undefined) || (!is_array(_bulk_request)) { exit; };
							
							var _task;
							var _size = array_length(_bulk_request);
							
							var _struct = {arr:[]};
							var _i=0; repeat(_size) {
								_task = _bulk_request[_i]
								
								// run the task
								var _returned_data = run_task(_task);
								array_push(_struct.arr, _returned_data);
								
							_i++;}//end repeat loop
							
							return_results(_struct)
							
							//postpone the timer as we have completed our goal.
							stay_alive();
							
						break;}
					}
					
				}
				
			#endregion
			
		}
		
	#endregion
	
	#region Functions
		
		function __mp_is_main_process() {
			return (global.__MultiProcessingInstanceID == 0);
		}
		
		//The init function : call this to initialize multi threading, if MultiProcessing_Require_Init_Script is set to true this will automatically be called as game start. 
		function MultiProcessingInit() {
			
			if (global.__MultiProcessingProcessorCount == 0) {
				///no reason to run the multi processing if we dont want to use any cores
				__MP = {
					workers_connected : false,
					processer_count: 0,
					task_index : 0,
					end_step : function(){},
					gameend : function(){},
					async : function(_async_load){ show_message("Wait, h-how'd you do that?") },
				}
				
				return;
			}
			
			// Find the correct process to spawn as
			if (MultiProcessing_Spawn_Main_Process_First) {
				if (__mp_is_main_process()) {
					__MP = new __mp_server();
				}
				else{
					__MP = new __mp_worker();
				}
			}
			else {
				if (__mp_is_main_process()) {
					__MP = new __mp_worker();
				}
				else{
					if (global.__MultiProcessingInstanceID == global.__MultiProcessingProcessorCount) {
						__MP = new __mp_server();
					}
					else {
						__MP = new __mp_worker();
					}
				}
			}
			
			instance_create_depth(0, 0, -16000, objMultiProcessing);
			
			//init environment
			if (__mp_is_main_process()) {
				show_debug_message(":: MultiProcessing :: About to create workers.")
				__MP.processes_start_all();
			}
			
		}
		
		//for use if you want to bind it to a button instead of instantly spawning it
		function SpawnMultiProcessing() {
			// duplicate current process by executing its own command line
			EnvironmentSetVariable("MultiProcessingInstanceID", string(real(EnvironmentGetVariable("MultiProcessingInstanceID")) + 1));
			array_push(global.__MultiProcessingChildProcessID, ExecProcessFromArgVAsync(GetArgVFromProcid(ProcIdFromSelf()))); // define child process id for later use
		}

	#endregion
	
#endregion


