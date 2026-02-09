package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "core:fmt"
import "core:time"

input_held :: proc(window: glfw.WindowHandle) {
	if ckey.W in held_keys {
		fmt.printf("W is pressed, time: %f\n", glfw.GetTime())
	}
	if ckey.SPACE in held_keys {
		time.sleep(100_000_000)
	}
}

wireframe_rendering := false
input_on_press :: proc(window: glfw.WindowHandle, key: ckey) {
	#partial switch key {
	case ckey.F2:
		wireframe_rendering = !wireframe_rendering
		if wireframe_rendering {
			gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
		} else {
			gl.PolygonMode(gl.FRONT_AND_BACK, gl.FILL)
		}
	}
}

input_on_release :: proc(window: glfw.WindowHandle, key: ckey) {
	#partial switch key {
	case ckey.ESCAPE:
		running = false
	}
}
