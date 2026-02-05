package client

import "vendor:glfw"
import gl "vendor:OpenGL"

main_loop :: proc(shader: u32, window: ^glfw.WindowHandle) {
	for !glfw.WindowShouldClose(window^) && running {
		glfw.PollEvents()
		// FIXME: Remove this, make cb_input call instead
		// make sure that there aren't differences in how
		// either behave
		input(window)

		gl.ClearColor(1.0, 1.0, 1.0, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)

		glfw.SwapBuffers(window^)
	}
}
