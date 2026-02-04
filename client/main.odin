package client

import gl "vendor:OpenGL"
import stbi "vendor:stb/image"
import "vendor:glfw"

import "core:c"
import "core:fmt"
import "core:time"
import "core:math/rand"

CONFIG :: struct {
	debug: bool,
	gl_version: [2]c.int,
	window: [2]i32,
}{
	debug = false,
	gl_version = {3, 3},
	window = [2]i32{400, 400},
}

Screenshake :: struct {
	uniform_location: i32,
	multiplier: f32,
	interval: time.Duration,
	stopwatch: time.Stopwatch,
}

running := false

vertex_shader_src := #load("./shaders/0.vert", cstring)
when !CONFIG.debug {
	fragment_shader_src := #load("./shaders/1.frag", cstring)
} else {
	fragment_shader_src := #load("./shaders/dbg.frag", cstring)
}

main :: proc() {
	if !glfw.Init() {
		fmt.println("GLFW is a failure.")
		return
	}
	defer glfw.Terminate()

    glfw.SetErrorCallback(cb_error)
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, CONFIG.gl_version[0])
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, CONFIG.gl_version[1])
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(CONFIG.window.x, CONFIG.window.y, "OWMst", nil, nil)

	if window == nil {
		fmt.println("NO WINDOW")
		return
	}
	defer glfw.DestroyWindow(window)
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

	shader: u32 = create_shader(&vertex_shader_src, &fragment_shader_src)

	vbo, vao, ebo, wall: u32 = ---, ---, ---, ---
	{
		vertex_data := [?]f32 {
			//X	   Y    Z      R   G  B
			 .5,  .5,   0,     1,  0,  0,	1, 1, // Bottom Left
			 .5, -.5,   0,     0,  1,  0,	1, 0, // Bottom Right
			-.5, -.5,   0,     0,  0,  1,	0, 0, // Top Right
			-.5,  .5,   0,     1,  1,  0,	0, 1, // Top Left
		}
		indices := [?]u32 {
			3, 2, 1, // TL -> TR -> BR
			3, 1, 0, // TL -> BR -> BL
		}

		x, y, channels: i32 = ---, ---, ---
		texture := stbi.load("wall.jpg", &x, &y, &channels, 0)
		defer stbi.image_free(texture)

		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.MIRRORED_REPEAT)
		gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT)

		gl.GenTextures(1, &wall)
		gl.BindTexture(gl.TEXTURE_2D, wall)
		defer gl.BindTexture(gl.TEXTURE_2D, 0)

		gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, x, y, 0, gl.RGB, gl.UNSIGNED_BYTE, texture)
		gl.GenerateMipmap(gl.TEXTURE_2D)

		gl.GenVertexArrays(1, &vao)
		gl.GenBuffers(1, &vbo)
		gl.GenBuffers(1, &ebo)

		gl.BindVertexArray(vao)
		defer gl.BindVertexArray(0)

		gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
		defer gl.BindBuffer(gl.ARRAY_BUFFER, 0)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(vertex_data), &vertex_data, gl.STATIC_DRAW)

		gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
		defer gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0)
		gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(indices), &indices, gl.STATIC_DRAW)

		gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 8 * size_of(f32), 0)
		gl.EnableVertexAttribArray(0)

		gl.VertexAttribPointer(1, 3, gl.FLOAT, false, 8 * size_of(f32), 3 * size_of(f32))
		gl.EnableVertexAttribArray(1)

		gl.VertexAttribPointer(2, 2, gl.FLOAT, false, 8 * size_of(f32), 6 * size_of(f32))
		gl.EnableVertexAttribArray(2)

		when CONFIG.debug {
		// TODO: Look into replacing the fixed number location with a name to aPos and aColor
		// aPos := gl.GetUniformLocation(shader, "aPos") // or similar
		// gl.VertexAttribPointer(aPos, 3, gl.FLOAT, false, 6 * size_of(f32), 3 * size_of(f32))
		//
		// aColor := gl.GetUniformLocation(shader, "aColor") // or similar
		// gl.VertexAttribPointer(aColor, 3, gl.FLOAT, false, 6 * size_of(f32), 3 * size_of(f32))
		//
		// assert(aPos == 0 && aColor == 1)
		// TODO: Look into using DSAs (OpenGL version ≥ 4.5) to remove all the binding.
			fmt.println(texture != nil, x, y, channels, wall)
		}

	}
	defer gl.DeleteBuffers(1, &vbo)
	defer gl.DeleteBuffers(1, &ebo)
	defer gl.DeleteVertexArrays(1, &vao)
	defer gl.DeleteTextures(1, &wall)

	scrshake := Screenshake {
		uniform_location = gl.GetUniformLocation(shader, "screenshake"),
		multiplier = 0.00,
		interval = 20 * time.Millisecond,
		stopwatch = time.Stopwatch{}
	}
	assert(scrshake.uniform_location != -1)

	when CONFIG.debug {
		ret: i32 = ---
		gl.GetIntegerv(gl.MAX_VERTEX_ATTRIBS, &ret)
		fmt.println("MAX_VERTEX_ATTRIBS:", ret)
	}
	for !glfw.WindowShouldClose(window) && running {
		gl.UseProgram(shader)

		glfw.PollEvents()
		input(&window)

		if !scrshake.stopwatch.running || time.stopwatch_duration(scrshake.stopwatch) >= scrshake.interval {
			scrshake_pos := [2]f32{
				scrshake.multiplier * (rand.float32() * 2.0 - 1.0),
				scrshake.multiplier * (rand.float32() * 2.0 - 1.0)
			}
			gl.Uniform2f(scrshake.uniform_location, scrshake_pos.x, scrshake_pos.y)
			time.stopwatch_reset(&scrshake.stopwatch)
			time.stopwatch_start(&scrshake.stopwatch)
		}

		gl.ClearColor(1.0, 1.0, 1.0, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		{
			gl.BindTexture(gl.TEXTURE_2D, wall)
			defer gl.BindTexture(gl.TEXTURE_2D, 0)

			gl.BindVertexArray(vao)
			defer gl.BindVertexArray(0)

			gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
			defer gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0)

			gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)
		}

		glfw.SwapBuffers(window)
	}
}
