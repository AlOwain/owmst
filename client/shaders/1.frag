#version 330 core

uniform sampler2D wall;
uniform sampler2D face;

in vec3 VertColor;
in vec2 TexCoord;

out vec4 FragColor;

void main()
{

    FragColor = mix(
            texture(wall, TexCoord),
            texture(face, TexCoord),
        0.2) * vec4(VertColor, 1.0);
}
