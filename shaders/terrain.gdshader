shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise1Normal;
uniform sampler2D noise2;
uniform sampler2D noise3;

uniform float scale = 1.0;

varying vec2 tex_position;

void vertex() {
	float layer1 = texture(noise1, UV).r * scale;
	float layer2 = texture(noise2, UV).r * (scale / 2.0);
	float layer3 = texture(noise3, UV).r * (scale / 4.0);
	
	float height = layer1 + layer2 + layer3;
	VERTEX.y = height;
	
	// Figure out using the cross product to calculate the normal map, this should work I think
}

void fragment() {
	NORMAL_MAP = texture(noise1Normal, tex_position).xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
