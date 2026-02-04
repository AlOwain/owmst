#version 330 core

uniform sampler2D ourTexture;

in vec3 VertColor;
in vec2 TexCoord;

out vec4 FragColor;

void main()
{
    FragColor = texture(ourTexture, TexCoord) * vec4(VertColor, 1.0);
}
