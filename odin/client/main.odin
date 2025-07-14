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

	vertices: []f32 = {
		-0.5, -0.5, 0.0,
		0.5,  -0.5, 0.0,
		0.0,   0.5, 0.0
	};

	vbo: u32 = ---
	gl.GenBuffers(1, &vbo)
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	gl.BufferData(gl.ARRAY_BUFFER, size_of(vertices), &vertices, gl.STATIC_DRAW)

	vertex_shader := shader_compile(&vertex_shader_src, gl.VERTEX_SHADER)
	defer gl.DeleteShader(vertex_shader)

	fragment_shader := shader_compile(&fragment_shader_src, gl.FRAGMENT_SHADER)
	defer gl.DeleteShader(fragment_shader)

	shader_program: u32 = ---
	shader_program = gl.CreateProgram()
	gl.AttachShader(shader_program, vertex_shader)
	gl.AttachShader(shader_program, fragment_shader)
	gl.LinkProgram(shader_program)

	gl_check_errors(shader_program, gl.LINK_STATUS)
	gl.UseProgram(shader_program)

	for !glfw.WindowShouldClose(window) && running {
        glfw.PollEvents()

        gl.ClearColor(1.0, 1.0, 1.0, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        glfw.SwapBuffers(window)
	}
}
