shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise1Normal;
uniform sampler2D noise2;
uniform sampler2D noise2Normal;
uniform sampler2D noise3;
uniform sampler2D noise3Normal;

uniform float scale = 1.0;

varying vec2 tex_position;

// Calculates the height of a given position based on 3 layers of fractal noise
float get_height(vec2 pos) {
	float layer1 = pow(texture(noise1, pos).r,4) * (scale * 4.0);
	float layer2 = texture(noise2, pos).r * (scale / 2.0);
	float layer3 = texture(noise3, pos).r * (scale / 4.0);
	
	return layer1 + layer2 + layer3;
}

void vertex() {
	
	
	float height = get_height(UV);
	VERTEX.y = height;
	
	// Figure out using the cross product to calculate the normal map, this should work I think
}

void fragment() {
	NORMAL_MAP = (texture(noise1Normal, tex_position).xyz * scale * 4.0) + (texture(noise2Normal, tex_position).xyz * scale / 2.0) + (texture(noise2Normal, tex_position).xyz * scale / 4.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
