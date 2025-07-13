package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:os"

import "../shared"

cb_error :: proc "c" (code: i32, desc: cstring) {
	context = runtime.default_context()

    fmt.println(code, desc);
}

cb_input :: proc "c" (windw: glfw.WindowHandle, key, scancode, action, mods: i32) {
	os.exit(0)
}

cb_window_resize :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

main :: proc() {
	if !glfw.Init() {
		fmt.println("GLFW is a failure.")
		return
	}
	defer glfw.Terminate()

    glfw.SetErrorCallback(cb_error);
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3) 
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 2)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(800, 400, "OWMst", nil, nil)

	if nil == window {
		fmt.println("NO WINDOW")
		return
	}
	defer glfw.DestroyWindow(window)

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1) // Enables V-Sync, not sure if I want to

	glfw.SetKeyCallback(window, cb_input)
	glfw.SetFramebufferSizeCallback(window, cb_window_resize)
}
