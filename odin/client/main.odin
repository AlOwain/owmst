package client

import gl "vendor:OpenGL"
import "vendor:glfw"

import "base:runtime"
import "core:c"
import "core:fmt"
import "core:os"

import "../shared"

GL_MAJOR_VERSION : c.int : 3
GL_MINOR_VERSION :: 3
running := false

cb_error :: proc "c" (code: i32, desc: cstring) {
	context = runtime.default_context()

    fmt.println(code, desc);
}

cb_input :: proc "c" (windw: glfw.WindowHandle, key, scancode, action, mods: i32) {
	running = false
	os.exit(0)
}

cb_window_resize :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	gl.Viewport(0, 0, width, height)
}

gl_check_errors :: proc (id, error_type: u32) {
	success: i32 = ---
	task: string
	info_log: [512]u8
	switch error_type {
		case gl.LINK_STATUS:
			gl.GetProgramiv(id, error_type, &success)
			gl.GetProgramInfoLog(id, 512, nil, raw_data(info_log[:]));
			task = "Shader linking"
		case gl.COMPILE_STATUS:
			gl.GetShaderiv(id, error_type, &success)
			gl.GetShaderInfoLog(id, 512, nil, raw_data(info_log[:]));
			task = fmt.aprintf("Shader compilation")
	}

	if success != 1 {
		fmt.printfln("%s failed. Error message:", task)
		fmt.println(string(info_log[:]))
		// TODO: Consider adding: os.exit(1)
	}
}

shader_compile :: proc (shader_src: ^cstring, shader_type: u32) -> u32 {
	shader: u32 = ---
	shader = gl.CreateShader(shader_type)
	gl.ShaderSource(shader, 1, shader_src, nil)
	gl.CompileShader(shader)

	gl_check_errors(shader, gl.COMPILE_STATUS)

	return shader
}

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

	vertex_shader_src: cstring = `
#version 330 core
layout (location = 0) in vec3 aPos;
void main()
{
   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}`
	vertex_shader := shader_compile(&vertex_shader_src, gl.VERTEX_SHADER)
	defer gl.DeleteShader(vertex_shader)

	fragment_shader_src: cstring = `
#version 330 core
out vec4 FragColor;

void main()
{
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}`
	fragment_shader := shader_compile(&fragment_shader_src, gl.FRAGMENT_SHADER)
	defer gl.DeleteShader(fragment_shader)

	shader_program: u32 = ---
	shader_program = gl.CreateProgram()
	gl.AttachShader(shader_program, vertex_shader);
	gl.AttachShader(shader_program, fragment_shader);
	gl.LinkProgram(shader_program);

	gl_check_errors(shader_program, gl.LINK_STATUS)
	gl.UseProgram(shader_program)

	for !glfw.WindowShouldClose(window) && running {
        glfw.PollEvents()

        gl.ClearColor(1.0, 1.0, 1.0, 1.0)
        gl.Clear(gl.COLOR_BUFFER_BIT)

        glfw.SwapBuffers(window)
	}
}
