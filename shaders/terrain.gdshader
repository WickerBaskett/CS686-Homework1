shader_type spatial;
render_mode world_vertex_coords;

uniform sampler2D noise1;
uniform sampler2D noise2;
uniform sampler2D noise3;

uniform int num_tones = 5;

// Offset of points used to calculate the Normal Vector
const float pos_offset = 0.00001;


// Calculates the height of a given position based on 3 layers of fractal noise
float get_height(vec2 pos) {
	float layer1 = texture(noise1, pos).r * (1.0 * 4.0);
	float layer2 = texture(noise2, pos).r * (1.0 / 2.0);
	float layer3 = texture(noise3, pos).r * (1.0 / 4.0);

	return layer1 + layer2 + layer3 + dot(pos, vec2(1.0, 1.0));
}

void vertex() {


	// Set the current positions height
	float height0 = get_height(UV);
	VERTEX.y = height0;

	/*
	// Calculate the heights of two nearby points, used to find tangent and bitangent
	float height1 = get_height(UV - vec2(0, -pos_offset));
	float height2 = get_height(UV - vec2(-pos_offset, 0));

	// Get two vectors near the current position, double check that the coords are in right
	//  space
	vec3 p0 = vec3(VERTEX.x, 			  height0, VERTEX.z);
	vec3 p1 = vec3(VERTEX.x, 			  height1, VERTEX.z - pos_offset);
	vec3 p2 = vec3(VERTEX.x - pos_offset, height2, 0.0);

	// Find two vectors in the plane perpendicular to the normal
	vec3 v1 = p1 - p0;
	vec3 v2 = p2 - p0;

	// Calculate the normal based on the cross product of two vectors
	NORMAL = normalize(cross(v1, v2));

	//vec2 pos = VERTEX.xz;
	//NORMAL = -1.0 * normalize(vec3(height - get_height(pos + vec2(0.1, 0.0)), 0.1, height - get_height(pos + vec2(0.0, 0.1))));
	*/
}

void fragment() {
	//-------------------
	// Calculate Normals
	//-------------------
	vec2 uvSize = 1.0/vec2(textureSize(noise1,0));
	float T = get_height(UV + vec2(0, -uvSize.y));
	float R = get_height(UV + vec2(+uvSize.x, 0));
	float L = get_height(UV + vec2(-uvSize.x, 0));
	float B = get_height(UV + vec2(0, +uvSize.y));

	// Compute spatial derivatives
	float d_dx = (R-L);
	float d_dy = (T-B);

	// Normal = (-dh / dx, -dh / dy, dh/dz)
	vec3 normal = vec3(-d_dx,-d_dy,1.0); // normal vector
	// Write to the normal map, which uses a reasonable coordinate system
	//  (tangent space, which is lined up with world XYZ)
	NORMAL_MAP = 0.5 + 0.5 * normalize(normal);

	//--------------------
	// Set Albedo
	//--------------------


}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
