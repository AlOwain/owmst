package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "core:c"
import "core:fmt"

import "../shared"

GL_MAJOR_VERSION : c.int : 3
GL_MINOR_VERSION :: 3

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 600

running := false

vertex_shader_src := #load("./shaders/0.vert", cstring)
fragment_shader_src := #load("./shaders/1.frag", cstring)

main :: proc() {
	if !glfw.Init() {
		fmt.println("GLFW is a failure.")
		return
	}
	defer glfw.Terminate()

    glfw.SetErrorCallback(cb_error)
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "OWMst", nil, nil)

	if nil == window {
		fmt.println("NO WINDOW")
		return
	}
	defer glfw.DestroyWindow(window)
	running = true

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)

	glfw.SetKeyCallback(window, cb_input)
	glfw.SetFramebufferSizeCallback(window, cb_window_resize)

	gl.load_up_to(int(GL_MAJOR_VERSION), GL_MINOR_VERSION, glfw.gl_set_proc_address)
	{
		width, height := glfw.GetFramebufferSize(window)
		gl.Viewport(0, 0, width, height)
	}

	shader: u32 = ---
	{
		vertex_shader := shader_compile(&vertex_shader_src, gl.VERTEX_SHADER)
		defer gl.DeleteShader(vertex_shader)

		fragment_shader := shader_compile(&fragment_shader_src, gl.FRAGMENT_SHADER)
		defer gl.DeleteShader(fragment_shader)

		shader = gl.CreateProgram()
		gl.AttachShader(shader, vertex_shader)
		gl.AttachShader(shader, fragment_shader)
		gl.LinkProgram(shader)
		gl_check_errors(shader, gl.LINK_STATUS)
	}

	vertices := [?]f32 {
// 		  X		Y	 Z
		 0.5,  0.5, 0.0, // RT
		 0.5, -0.5, 0.0, // RB
		-0.5, -0.5, 0.0, // LB
		-0.5,  0.5, 0.0, // LT
		 0.0,  1.0, 0.0, // CV
	}
	indices := [?]u32 {
		3, 2, 1, // He put: 1, 2, 3		Isn't this clockwise? How does it work?!
		3, 1, 0, // He put: 0, 1, 3		But counter-clockwise
		0, 4, 3, // This is my solution for Exercise 1
	}

	vbo, vao, ebo: u32 = ---, ---, ---
	{
		// TODO: Shouldn't you use:
		// buf_arr := [2]u32
		// gl.GenBuffers(2, &buf_arr)
		// vbo := buf_arr[0]
		// ebo := buf_arr[1]

		gl.GenVertexArrays(1, &vao)
		gl.GenBuffers(1, &vbo)
		gl.GenBuffers(1, &ebo)

		gl.BindVertexArray(vao)
		defer gl.BindVertexArray(0)

		gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
		defer gl.BindBuffer(gl.ARRAY_BUFFER, 0)
		gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices, gl.STATIC_DRAW)

		gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
		defer gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0)
		gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, size_of(indices), &indices, gl.STATIC_DRAW)

		gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 3 * size_of(f32), 0)
		gl.EnableVertexAttribArray(0)
	}
	defer gl.DeleteBuffers(1, &vbo)
	defer gl.DeleteBuffers(1, &ebo)
	defer gl.DeleteVertexArrays(1, &vao)

	for !glfw.WindowShouldClose(window) && running {
		glfw.PollEvents()
		input(&window)

		gl.ClearColor(1.0, 1.0, 1.0, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		gl.UseProgram(shader)

		gl.BindVertexArray(vao)
		defer gl.BindVertexArray(0)

		gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
		defer gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, 0)

		gl.DrawElements(gl.TRIANGLES, 9, gl.UNSIGNED_INT, nil);

		glfw.SwapBuffers(window)
	}
}
