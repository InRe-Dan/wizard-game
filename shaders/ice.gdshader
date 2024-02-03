shader_type canvas_item;

uniform sampler2D noise;
uniform mat4 global_transform;
varying vec2 world_pos;
uniform float lifetime_percentage;

// Shoutout to https://github.com/godotengine/godot/issues/19800#issuecomment-441794862
void vertex() {
    world_pos = (global_transform * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	// Blue channel of the noise actually denotes probability of omission
	vec4 noise_sample = texture(noise, mod(world_pos * 0.12381251, 1.0));
	float dist = pow(1. - (length(2. * UV - 1.) / sqrt(2)), 10. - lifetime_percentage * 10.);
	if (dist > texture(noise, mod(UV + vec2(0.5), 1.0)).r && dist < 0.5) {
		COLOR = vec4(noise_sample.xyz, 1.0);
	} else {
	COLOR = vec4(noise_sample.xyz, 0.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
