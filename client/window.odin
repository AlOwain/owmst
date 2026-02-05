package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "core:fmt"
import "core:os"

create_window :: proc() -> glfw.WindowHandle {
	if !glfw.Init() {
		fmt.println("GLFW failed.")
		os.exit(1)
	}

    glfw.SetErrorCallback(cb_error)
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, CONFIG.gl_version[0])
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, CONFIG.gl_version[1])
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(CONFIG.window.x, CONFIG.window.y, "OWMst", nil, nil)

	if window == nil {
		fmt.println("GLFW failed to create a window.")
		os.exit(2)
	}
	running = true

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, cb_input)
	glfw.SetFramebufferSizeCallback(window, cb_window_resize)

	gl.load_up_to(int(CONFIG.gl_version[0]), int(CONFIG.gl_version[1]), glfw.gl_set_proc_address)
	{
		width, height := glfw.GetFramebufferSize(window)
		gl.Viewport(0, 0, width, height)
	}

	return window
}

close_window :: proc(window: glfw.WindowHandle) {
	// TODO: figure it out
	// glfw.DestroyWindow(window)
	// doesn't work for some reason, neither does
	// glfw.SetWindowShouldClose(window, true)
	glfw.Terminate()
}
