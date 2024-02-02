shader_type canvas_item;

uniform sampler2D noise;
uniform sampler2D transparencyNoise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(texture(noise, UV).xyz, texture(transparencyNoise, UV).x);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
