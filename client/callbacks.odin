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

wireframe_rendering := false
cb_input :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	if action != glfw.PRESS {
		return
	}

	switch key {
	case glfw.KEY_ESCAPE:
		running = false
	case glfw.KEY_F2:
		wireframe_rendering = !wireframe_rendering
		if wireframe_rendering {
			gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
		} else {
			gl.PolygonMode(gl.FRONT_AND_BACK, gl.FILL)
		}
	}
}

cb_window_resize :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}
