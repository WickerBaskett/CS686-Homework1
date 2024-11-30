shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex: hint_screen_texture, filter_nearest, repeat_disable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 col = texture(screen_tex, UV).xyz;
	ALBEDO = col;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
