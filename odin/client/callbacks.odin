package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "base:runtime"
import "core:fmt"
import "core:os"

cb_error :: proc "c" (code: i32, desc: cstring) {
	context = runtime.default_context()

    fmt.println(code, desc);
}

cb_input :: proc "c" (windw: glfw.WindowHandle, key, scancode, action, mods: i32) {
	running = false
	os.exit(1)
}

cb_window_resize :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}
