shader_type spatial;

uniform sampler2D noise1;
uniform sampler2D noise1Normal;
uniform sampler2D noise2;
uniform sampler2D noise2Normal;
uniform sampler2D noise3;
uniform sampler2D noise3Normal;

// Offset of points used to calculate the Normal Vector
const float pos_offset = 1.0;

varying vec2 tex_position;

// Calculates the height of a given position based on 3 layers of fractal noise
float get_height(vec2 pos) {
	float layer1 = pow(texture(noise1, pos).r, 4.0) * (1.0 * 4.0);
	float layer2 = texture(noise2, pos).r * (1.0 / 2.0);
	float layer3 = texture(noise3, pos).r * (1.0 / 4.0);
	
	return layer1 + layer2 + layer3;
}

void vertex() {
	// Set the current positions height
	float height = get_height(UV);
	VERTEX.y = height;
	
	// Get the world coordinates of the current vertex
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	// Get two vectors near the current position
	vec3 p0 = vec3(world_vert.x, height, world_vert.z);
	vec3 p1 = vec3(world_vert.x, get_height(UV - vec2(0, -pos_offset)), world_vert.z - pos_offset);
	vec3 p2 = vec3(world_vert.x - pos_offset, get_height(UV - vec2(-pos_offset, 0)), 0.0);
	
	// Find two vectors in the plane perpendicular to the normal
	vec3 v1 = p1 - p0;
	vec3 v2 = p2 - p0;
	
	// Calculate the normal based on the cross product of two vectors
	NORMAL = cross(v1, v2);
}

void fragment() {
	
	}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
