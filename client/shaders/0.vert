#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec4 VertColor;

uniform float skew;

void main()
{
   gl_Position = vec4(aPos.x + skew, aPos.yz, 1.0);
   VertColor = vec4(aColor, 1.0);
}
