shader_type canvas_item;

uniform bool active = false;
uniform float frequency = 5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float period = 1. / frequency;
	if (active) {
		float fractional = TIME - floor(TIME);
		float segment = fractional - period * floor(fractional / period);
		if (segment * 2. < (0.5 * period)) {
			COLOR = mix(COLOR, vec4(1, 1, 1, COLOR.w), vec4(0.2));
		}
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
