shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest, repeat_disable;

// Cross hatching textures, from lightest to darkest
uniform sampler2D hatching0: filter_nearest, repeat_enable;
uniform sampler2D hatching1: filter_nearest, repeat_enable;
uniform sampler2D hatching2: filter_nearest, repeat_enable;

uniform int num_tones = 4;

void vertex() {

}

void fragment() {
	vec3 color = texture(screen_tex, SCREEN_UV).xyz;
	float luminence = ((color.r * 0.3) + (color.g * 0.59) + (color.b * 0.11)) * (float(num_tones) - 1.0);
	float adjusted = round(luminence);
	if (adjusted < 0.5) {
		COLOR = vec4(texture(hatching2, UV * 5.0).xyz, 1.0);
	}
	else if (adjusted < 1.5) {
		COLOR = vec4(texture(hatching1, UV * 5.0).xyz, 1.0);
	}
	else if (adjusted < 2.5) {
		COLOR = vec4(texture(hatching0, UV * 5.0).xyz, 1.0);
	}
	else {
		COLOR = vec4(vec3(adjusted), 1.0);
	}
	COLOR = vec4(vec3(adjusted / (float(num_tones) - 1.0)), 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
