shader_type canvas_item;

uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 noise_pixel = texture(noise, UV);
	float dist = pow(1. - (length(UV - 0.5) / sqrt(2)), 5);
	if (dist > 1. - noise_pixel.x) {
		dist = 1.0;
	} else {
		dist = 0.0;
	}
	if (texture(noise, UV).x > 0.5) {
		COLOR = vec4(noise_pixel.xyz + vec3(0.2, 0., 0.), dist);
	} else {
		COLOR = vec4(noise_pixel.xyz + vec3(-0.2, 0., 0.), dist);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
