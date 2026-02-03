#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

uniform vec2 screenshake;

out vec4 VertColor;

void main()
{
   gl_Position = vec4(aPos.xy + screenshake, aPos.z, 1.0);
   VertColor = vec4(aColor, 1.0);
}
