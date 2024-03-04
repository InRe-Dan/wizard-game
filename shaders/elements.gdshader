shader_type canvas_item;

uniform sampler2D noise;

uniform sampler2D elements;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 water() {
	return vec4(0.0, 0.1, 0.8, 0.6);
}

vec4 ice() {
	return vec4(0.0, 0.5, 0.8, 0.6);
}

vec4 fire() {
	return vec4(0.8, 0.5, 0.0, 0.6);
}

void fragment() {
	if (COLOR.r > 0.01) {
		COLOR = fire();
	} else if (COLOR.g > 0.01) {
		COLOR = ice();
	} else if (COLOR.b > 0.01) {
		COLOR = water();
	} else {
		COLOR = vec4(0.);
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
}
