/// @desc DESCRIPTION
repeat(1_000){
    remote_execute(factorial_example, [current_input_index, get_timer()], callback_example);
		current_input_index+=1
}
