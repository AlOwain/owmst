package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "core:c"
import "core:fmt"

import "../shared"

GL_MAJOR_VERSION : c.int : 3
GL_MINOR_VERSION :: 3
running := false

vertex_shader_src := #load("./shaders/0.vert", cstring)
fragment_shader_src := #load("./shaders/1.frag", cstring)

main :: proc() {
	if !glfw.Init() {
		fmt.println("GLFW is a failure.")
		return
	}
	defer glfw.Terminate()

    glfw.SetErrorCallback(cb_error);
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, GL_MAJOR_VERSION)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	window := glfw.CreateWindow(800, 400, "OWMst", nil, nil)

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

	vertices: []f32 = {
// 		 X		Y	 Z
		-0.5, -0.5, 0.0,
		0.5,  -0.5, 0.0,
		0.0,   0.5, 0.0
	};

	vbo, vao: u32 = ---, ---
	gl.GenVertexArrays(1, &vao)
	gl.GenBuffers(1, &vbo)
	gl.BindVertexArray(vao)
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(gl.ARRAY_BUFFER, len(vertices) * size_of(vertices[0]), &vertices[0], gl.STATIC_DRAW)
	gl.VertexAttribPointer(0, 3, gl.FLOAT, false, 3 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	// Unbind Vertex Buffer Object and Vertex Array Object
	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)

	for !glfw.WindowShouldClose(window) && running {
        glfw.PollEvents()

        gl.ClearColor(1.0, 1.0, 1.0, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        gl.UseProgram(shader)
        gl.BindVertexArray(vao)
        gl.DrawArrays(gl.TRIANGLES, 0, 3)

        glfw.SwapBuffers(window)
	}
}
