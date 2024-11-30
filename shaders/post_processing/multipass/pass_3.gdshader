shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex: hint_screen_texture;
uniform sampler2D last_pass: filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec4 throwaway = texture(screen_tex, UV);
	ALBEDO = (texture(last_pass, UV).xyz + vec3(0.6, 0.1, 0.2));
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
