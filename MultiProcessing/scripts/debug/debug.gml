function log(_str) {
	show_debug_message(_str)
}

//define
#macro trace  __trace(_GMFILE_+"/"+_GMFUNCTION_+":"+string(_GMLINE_)+": ")
function __trace(_location) {
        static __struct = {};
        __struct.__location = _location;
        return method(__struct, function(_str)
    {
        show_debug_message(__location + ": " + string(_str));
    });
}