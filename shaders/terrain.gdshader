shader_type spatial;

uniform sampler2D noise;

varying vec2 tex_position;

void vertex() {
	float height = texture(noise, UV).r;
	tex_position = VERTEX.xz / 2.0 + 0.5;
	VERTEX.y = height;
}

void fragment() {
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
