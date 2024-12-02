shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;
uniform sampler2D hatching_stroke: filter_nearest, repeat_disable;

const int num_tones = 5;

// Taken from the internet, not an Elliott Original
float white_noise(vec2 pos) {
	float random = dot(pos, vec2(12.9898, 78.233));
	random = sin(random);
	random *= 43758.5453;
	return fract(random);
}

vec3 value_noise( vec2 pos ) {
	vec2 uv = pos * 1.0;

	// Convert into a grid/lattice
	vec2 grid_uv = fract(uv);
	vec2 grid_id = floor(uv);

	// Quintic Interpolation: 6w^(5) - 15w^(4) + 10w^(3)
	vec2 u = grid_uv * grid_uv * grid_uv * (grid_uv * (grid_uv * 6.0 -15.0) + 10.0);
	vec2 du = 30.0 * grid_uv * grid_uv * (grid_uv * grid_uv - 2.0 * grid_uv + 1.0);

	float a = white_noise(grid_id);
	float b = white_noise(grid_id + vec2(1.0, 0.0));
	float c = white_noise(grid_id + vec2(0.0, 1.0));
	float d = white_noise(grid_id + vec2(1.0, 1.0));

	// Bilinear Interpolation done by hand to allow computation of du
	float k0 = a;
	float k1 = b - a;
	float k2 = c - a;
	float k3 = a - b - c + d;

	float n = k0 + k1*u.x + k2*u.y + k3*u.x*u.y;

	return vec3(n,
		du * vec2(k1 + k3 * u.y,
				  k2 + k3 * u.x) );
}

// Taken from Book of Shaders, rotation matrix with angle in radians
mat2 rotate2d(float angle){
    return mat2(vec2(cos(angle),-sin(angle)), vec2(sin(angle),cos(angle)));
}

// Creates a hatching texture
// This function is an Elliott Original
float tonal_map(vec2 pos, float lines, float angle, float density)
{
	pos = rotate2d(angle) * pos;
	// Convert texture to a grid
	vec2 uv = vec2(pos.x * lines, pos.y * lines * 8.0);
	vec2 i = floor(uv);
	vec2 f = fract(uv);


	// Check if the current cell should be hatched
	if (value_noise(i).x < density)
	{
		// Count the number of hatched cells to the left of the current one, store this in lc
		float offset = -1.0;
		float lc = 0.0;
		while (value_noise(i + vec2(offset, 0.0)).x < density)
		{
			lc += 1.0;
			offset -= 1.0;
		}

		// Count the number of hatched cells to the right of the current one, store this in rc
		offset = 1.0;
		float rc = 0.0;
		while (value_noise(i + vec2(offset, 0.0)).x < density)
		{
			rc += 1.0;
			offset += 1.0;
		}
		float tc = 1.0 + lc + rc; // Total Cell Count

		// Find new coordinates in the combined cells
		vec2 coords = vec2((f.x + lc) / tc, f.y);
		vec3 tex = texture(hatching_stroke, coords).xyz;
		// Grayscale conversion
		return dot(tex, vec3(0.3, 0.59, 0.11));
	}
	return 1.0;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 color = texture(screen_tex, SCREEN_UV).xyz;
	// Grayscale conversion
	float luminence = ((color.r * 0.3) + (color.g * 0.59) + (color.b * 0.11)) * (float(num_tones));
	float adjusted = floor(luminence);
	if (adjusted < 0.01) {
		ALBEDO = vec3(0.0, 0.0, 0.0);
	}
	else if (adjusted < 2.0) {
		float horizontal = min(tonal_map(UV, 16.0, 0.0, 0.5), tonal_map(UV, 32.0, 0.0, 0.5));
		horizontal = min(horizontal, tonal_map(UV, 64.0, 0.0, 0.5));

		float vertical = min(tonal_map(UV, 16.0, PI/2.0, 0.5), tonal_map(UV, 32.0, PI/2.0, 0.5));
		vertical = min(vertical, tonal_map(UV, 64.0, PI/2.0, 0.5));

		float tone = min(vertical, horizontal);
		ALBEDO = vec3(tone);
	}
	else if (adjusted < 3.0) {
		float tone = min(tonal_map(UV, 64.0, 0.0, 0.5), tonal_map(UV, 32.0, 0.0, 0.5));
		ALBEDO = vec3(tone);
	}
	else {
		ALBEDO = vec3(adjusted);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
