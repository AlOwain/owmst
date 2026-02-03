package client

import gl "vendor:OpenGL"

import "core:fmt"
import "core:os"

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
		// Consider removing the exit
		os.exit(1)
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

create_shader :: proc (vsrc: ^cstring, fsrc: ^cstring) -> u32 {
	vsdr := shader_compile(vsrc, gl.VERTEX_SHADER)
	defer gl.DeleteShader(vsdr)

	fsdr := shader_compile(fsrc, gl.FRAGMENT_SHADER)
	defer gl.DeleteShader(fsdr)

	shader := gl.CreateProgram()
	gl.AttachShader(shader, vsdr)
	gl.AttachShader(shader, fsdr)

	// NOTE(critical): This program depends on having a static shader linked and compiled once.
	// It can not work with dynamic shaders. There are static uniform locations.
	gl.LinkProgram(shader)
	gl_check_errors(shader, gl.LINK_STATUS)

	return shader
}
