package client

import "vendor:glfw"

import "core:fmt"
import "core:time"

// TODO:
// 	- Add movement and whatnot
//  - Seperate taking input from resolving logic
//  - Support remappable keys (much later)
input :: proc(window: ^glfw.WindowHandle) {
	if w := glfw.GetKey(window^, glfw.KEY_W); w == glfw.PRESS {
		fmt.printf("W is pressed, time: %f\n", glfw.GetTime())
	}
	if spc := glfw.GetKey(window^, glfw.KEY_SPACE); spc == glfw.PRESS {
		time.sleep(100_000_000)
	}
}
