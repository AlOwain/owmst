package client

import "vendor:glfw"

import "core:fmt"

// TODO:
// 	- Add movement and whatnot
//  - Seperate taking input from resolving logic
//  - Support remappable keys (much later)
input :: proc(window: ^glfw.WindowHandle) {
	if w := glfw.GetKey(window^, glfw.KEY_W); w == glfw.PRESS {
		fmt.printf("W is pressed, time: %f\n", glfw.GetTime())
	}
}
