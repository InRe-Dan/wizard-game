shader_type canvas_item;

uniform sampler2D screen : hint_screen_texture, repeat_disable, filter_nearest, source_color;

void fragment() {
	vec4 screen_col = texture(screen, SCREEN_UV);
	COLOR = vec4(vec3(1.) - screen_col.xyz, COLOR.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
