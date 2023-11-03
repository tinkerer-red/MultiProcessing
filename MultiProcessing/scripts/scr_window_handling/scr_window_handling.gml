function window_zoom() {
  if (os_kernel_name() == "Windows_NT") {
    external_call(external_define(working_directory + "libzoom.dll", "window_zoom", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Darwin") {
    external_call(external_define(working_directory + "libzoom.dylib", "window_zoom", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Linux") {
    if (os_architecture() == "x86_64") external_call(external_define(working_directory + "libzoom.so", "window_zoom", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "aarch64") external_call(external_define(working_directory + "libzoom_arm64.so", "window_zoom", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "armv7l") external_call(external_define(working_directory + "libzoom_arm.so", "window_zoom", dll_cdecl, ty_real, 1, ty_string), window_handle());
  }
}

function window_hide() {
	//these are not impliedly needed but just incase ;D
	window_set_size(0,0);
	window_set_caption("subprocess");
	window_set_max_height(0);
	window_set_max_width(0);
	application_surface_draw_enable(false);
	draw_enable_drawevent(false);
	
	if (os_kernel_name() == "Windows_NT") {
    external_call(external_define(working_directory + "libzoom.dll", "window_hide", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Darwin") {
    external_call(external_define(working_directory + "libzoom.dylib", "window_hide", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Linux") {
    if (os_architecture() == "x86_64") external_call(external_define(working_directory + "libzoom.so", "window_hide", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "aarch64") external_call(external_define(working_directory + "libzoom_arm64.so", "window_hide", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "armv7l") external_call(external_define(working_directory + "libzoom_arm.so", "window_hide", dll_cdecl, ty_real, 1, ty_string), window_handle());
  }
}

function window_focus() {
  if (os_kernel_name() == "Windows_NT") {
    external_call(external_define(working_directory + "libzoom.dll", "window_focus", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Darwin") {
    external_call(external_define(working_directory + "libzoom.dylib", "window_focus", dll_cdecl, ty_real, 1, ty_string), window_handle());
  } else if (os_kernel_name() == "Linux") {
    if (os_architecture() == "x86_64") external_call(external_define(working_directory + "libzoom.so", "window_focus", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "aarch64") external_call(external_define(working_directory + "libzoom_arm64.so", "window_focus", dll_cdecl, ty_real, 1, ty_string), window_handle());
    else if (os_architecture() == "armv7l") external_call(external_define(working_directory + "libzoom_arm.so", "window_focus", dll_cdecl, ty_real, 1, ty_string), window_handle());
  }
}