#version 330 core

in vec3 aPos;
in vec3 aColor;
in vec2 aTexCoord;

out vec3 VertColor;
out vec2 TexCoord;

void main()
{
   gl_Position = vec4(aPos, 1.0);
   VertColor = aColor;
   TexCoord = aTexCoord;
}
