shader_type canvas_item;

// Taken from the internet, not an Elliott Original
float white_noise(vec2 pos) {
	float random = dot(pos, vec2(12.9898, 78.233));
	random = sin(random);
	random *= 43758.5453;
	return fract(random);
}

vec3 value_noise( vec2 pos ) {
	vec2 uv = pos * 4.0;

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

// Followed along with https://iquilezles.org/articles/morenoise/ while writing this
vec3 fbm(vec2 x, float H )
{
    float G = exp2(-H);
    float f = 1.0;
    float a = 1.0;
    vec3 t = vec3(0.0);                 // x: Noise Value, y: dn_dx, z: dn_dy
	float m = dot(t.yz, vec2(1.0,1.0)); // Magnitude of Gradient
    for( int i=0; i<5; i++ )
    {
		m = dot(t.yz, vec2(1.0,1.0));
        t += a*value_noise(f*x);
        f *= 2.0;
        a *= G;
    }
    return t / 2.0;
}

void fragment() {
	COLOR = vec4(fbm(UV, 0.5), 1.0);
	//COLOR = vec4(vec3(fract(UV.x * UV.y * 1000.123)), 1.0);
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
