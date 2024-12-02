// Terrain based off of a single noise texture

shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D noise: filter_nearest, repeat_disable;

float get_height(vec2 pos) {
	return texture(noise, pos).x * 3.0;
}

void vertex() {
	// Set the current positions height
	float height0 = get_height(UV);
	VERTEX.y = height0;
}

void fragment() {
	// Sample Noise Texture, yz channels are derivatives
	vec2 d = texture(noise, UV).yz;

	// Normal = (dh / dx, dh / dy, dh/dz)
	vec3 normal = vec3(d.x,d.y,1.0); // normal vector

	// Write to the normal map, which uses a reasonable coordinate system
	//  (tangent space, which is lined up with world XYZ)
	NORMAL_MAP = 0.5 + 0.5 * normalize(normal);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
