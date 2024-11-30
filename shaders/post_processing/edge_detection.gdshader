shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex: hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D depth_tex: hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D normal_tex: hint_normal_roughness_texture, repeat_disable, filter_nearest;

// A value of 2 here creates an interesting effect, anything greater makes garbage
const int offset = 1;

// Definition of Sobel Operators
const mat3 sv = mat3(vec3(-1, 0, 1),
				     vec3(-2, 0, 2),
				     vec3(-1, 0, 1));

const mat3 sh = mat3(vec3(-1, -2, -1),
				     vec3(0, 0, 0),
					 vec3(1, 2, 1));

// Helper function to calculate the linear depth at a given position in screen space
float calc_depth(ivec2 pos, mat4 inv_proj_mat) {
	// Get depth, this is non-linear from 0.0 to 1.0
	float depth = texelFetch(depth_tex, pos, 0).r;
	// Convert to Normalized Device Coords, we only really care about the z coord
	vec4 non_linear = vec4(1.0, 1.0, depth, 1.0);
	// Convert to view space
	vec4 view = inv_proj_mat * non_linear;
	view.xyz /= view.w;

	float linear_depth = -view.z;
	return log2(linear_depth);

}

mat3 get_surrounding_depth_pixels(ivec2 center, mat4 inv_proj_mat) {
	mat3 pixels;
	for(int i = 0; i < 3; ++i) {
		for(int j = 0; j < 3; ++j) {
			float curr_pix = calc_depth(ivec2(center.xy) + ivec2(i - offset, j - offset), inv_proj_mat);
			pixels[i][j] = curr_pix;
		}
	}
	return pixels;
}

mat3 get_surrounding_normal_pixels(ivec2 center) {
	mat3 pixels;
	for(int i = 0; i < 3 * offset; i += offset) {
		for(int j = 0; j < 3 * offset; j += offset) {
			vec3 curr_pix = texelFetch(normal_tex, ivec2(center.xy) + ivec2(i, j), 0).xyz;
			float combined = curr_pix.x + curr_pix.y + curr_pix.z;
			pixels[i][j] = combined;
		}
	}
	return pixels;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	mat3 n_pixels = get_surrounding_normal_pixels(ivec2(FRAGCOORD.xy));
	mat3 d_pixels = get_surrounding_depth_pixels(ivec2(FRAGCOORD.xy), INV_PROJECTION_MATRIX);

	// Convolve the surrounding depth pixels with the sobel operators
	float dv_convul = dot(d_pixels[0], sv[0]) + dot(d_pixels[1], sv[1]) + dot(d_pixels[2], sv[2]);
	float dh_convul = dot(d_pixels[0], sh[0]) + dot(d_pixels[1], sh[1]) + dot(d_pixels[2], sh[2]);
	float d_val = sqrt(pow(dv_convul, 2) + pow(dh_convul,2));
	d_val = smoothstep(1.0, 1.0, d_val);

	float nv_convul = dot(n_pixels[0], sv[0]) + dot(n_pixels[1], sv[1]) + dot(n_pixels[2], sv[2]);
	float nh_convul = dot(n_pixels[0], sh[0]) + dot(n_pixels[1], sh[1]) + dot(n_pixels[2], sh[2]);
	float n_val = sqrt(pow(nv_convul, 2) + pow(dh_convul,2));
	n_val = smoothstep(1.0, 1.0, n_val);

	if (n_val > 0.0) {
		ALBEDO = vec3(0.0, 0.0, 0.0);
	}
	else {
		ALBEDO = texelFetch(screen_tex, ivec2(FRAGCOORD.xy), 0).xyz;
	}
	//ALBEDO = vec3(d_val + n_val);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
