shader_type spatial;
render_mode unshaded;

uniform sampler2D screen_tex: hint_screen_texture, filter_nearest, repeat_disable;
uniform int num_tones = 4;

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	vec3 color = texture(screen_tex, SCREEN_UV).xyz;
	
	// Grayscale conversion
	float luminence = ((color.r * 0.3) + (color.g * 0.59) + (color.b * 0.11)) * (float(num_tones));
	
	float adjusted = floor(luminence);
	ALBEDO = vec3(adjusted / (float(num_tones) - 1.0));
}


//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
