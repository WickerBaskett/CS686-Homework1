shader_type canvas_item;
render_mode unshaded;

uniform sampler2D last_pass: filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 color = texture(last_pass, UV);
	color.x += 0.5;
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
