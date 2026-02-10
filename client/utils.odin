package client

import gl "vendor:OpenGL"
import stbi "vendor:stb/image"

import "core:fmt"
import "core:os"

gl_check_errors :: proc(id, error_type: u32) {
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
		running = false
	}
}

shader_compile :: proc(shader_src: ^cstring, shader_type: u32) -> u32 {
	shader: u32 = ---
	shader = gl.CreateShader(shader_type)
	gl.ShaderSource(shader, 1, shader_src, nil)
	gl.CompileShader(shader)

	gl_check_errors(shader, gl.COMPILE_STATUS)

	return shader
}

create_shader :: proc(vsrc: ^cstring, fsrc: ^cstring) -> u32 {
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

create_texture :: proc(filename: cstring) -> u32 {
	texture: u32 = ---
	x, y, channels: i32 = ---, ---, ---

	gl.GenTextures(1, &texture)
	when CONFIG.debug {
		active_texture_unit: i32
		gl.GetIntegerv(gl.ACTIVE_TEXTURE, &active_texture_unit)
		fmt.println("Texture", filename, "\n\tID:", active_texture_unit - gl.TEXTURE0)
	}
	gl.BindTexture(gl.TEXTURE_2D, texture)
	defer gl.BindTexture(gl.TEXTURE_2D, 0)

	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.MIRRORED_REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.MIRRORED_REPEAT)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR)
	gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR)

	// This only needs to be set once but, oh well.
	stbi.set_flip_vertically_on_load(1)
	img := stbi.load(filename, &x, &y, &channels, 0)
	when CONFIG.debug { if img == nil { fmt.panicf("%s failed to load. %d, %d, %d, %d",  filename, x, y, channels, texture) }}
	if img != nil {
		if channels == 3 {
			gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, x, y, 0, gl.RGB, gl.UNSIGNED_BYTE, img)
		} else if channels == 4 {
			gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, x, y, 0, gl.RGBA, gl.UNSIGNED_BYTE, img)
		}
	}
	defer stbi.image_free(img)

	gl.GenerateMipmap(gl.TEXTURE_2D)

	return texture
}
