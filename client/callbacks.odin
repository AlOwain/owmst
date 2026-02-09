package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "core:fmt"
import "core:os"

import "base:runtime"

cb_error :: proc "c" (code: i32, desc: cstring) {
	context = runtime.default_context()

    fmt.println(code, desc);
}

cb_input :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	context = runtime.default_context()

	switch action {
	case glfw.REPEAT: fallthrough
	case glfw.PRESS:
		held_keys += {glfw_to_ckey(key)}
		input_on_press(window, glfw_to_ckey(key))
	case glfw.RELEASE:
		held_keys -= {glfw_to_ckey(key)}
		input_on_release(window, glfw_to_ckey(key))
	case: fmt.panicf("Invalid input action %i", action)
	}
}

cb_window_resize :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}
