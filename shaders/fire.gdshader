shader_type canvas_item;

uniform vec2 polygon[100];

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(1.0, UV.x * 0.5 + 0.5, UV.y, 0.5);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
