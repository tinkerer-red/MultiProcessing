//If the init script is required to be called or if the init script will automatically be called on game launch.
#macro MultiProcessing_Require_Init_Script false

#macro MultiProcessing_Frame_Speed 60 //{Real} The speed at which your game will run

//How many threads to use, this needs to be replaced with a good way to count the number of threads
#macro MultiProcessing_Percent_Of_Threads 0.25 //{Float: 0-1} //The percent of available threads to make use of. The ideal max should roughly be 0.25 to leave the OS breathing room as GM processes bleed over to other threads too.
#macro MultiProcessing_Number_Of_Processes_Min 1 //{Real} Having a value of 0 will mean its possible that remote execute functions will not run at all.
#macro MultiProcessing_Number_Of_Processes_Max 7 //{Real}
#macro MultiProcessing_Unlock_Number_Of_Processes false //{Bool} Allows you to run more processes then you have cores, not recommended as it causes OS to lag.

//{Real} How Many tasks to process by the main thread per frame. If a negative value, this uncaps the amount of tasks able to be processed, MultiProcessing_Percent_Of_Frame will still be applicable despite this.
// NOTE : if you consistantly produce more tasks then this hard limit you will eventually run out of memory
#macro MultiProcessing_Tasks_Per_Frame -1

#region Advanced
	
	#macro MultiProcessing_Percent_Of_Frame 1 //{Float: 0-1} How much of the frame to take up to send packets to subprocesses, 1 is usually acceptable unless you are sending out millions of packets in which case you can lower it down.
	
	#macro MultiProcessing_TTL 10 //{Real} The "Time To Live" in seconds a subprocesses have to respond, or get a signal from the main process.
	
	//If the main process will continue to run even if a subprocess dies should we create a new process in it's place?
	// NOTE: if this is off, you will need your own way to ensure that processes stay connected, you can spawn a processes with SpawnMultiProcessing() Although this will not obide by the Number_Of_Processes macros
	#macro MultiProcessing_Respawn true //{Bool}
	
	#macro MultiProcessing_GC_SAFE true //{Bool} :: TRUE RECOMMENDED :: if this is turned off there is no assurance that a task will ever complete and is completely a fire and forget processes, this also means its possible tasks will never be completed and cause a memory leak.
	
#endregion

#region Networking
	
	#macro MultiProcessing_Port 63479 //{Real} the port to use
	#macro MultiProcessing_Socket network_socket_tcp //{Constant.SocketType} the socket type to use
	
#endregion

#region Debugging
	
	#macro MultiProcessing_Visual_Debug true //{Bool} Draws the multiprocessing's data to the screen
	
	#macro MultiProcessing_Use_Structs false //{Bool} Used for testing the speeds of structs over maps and vyseversa, generally they are the same speeds over all and only an option for personal preference.
	
	// Used to spawn the multiprocessing as the IDE's focused process for debugging
	// True: The game process will be the first process launched and the IDE's console will have focus on that.
	// False: A subprocess will be the first process launched and the IDE's console will have focus on that.
	#macro MultiProcessing_Spawn_Main_Process_First true
	
#endregion


