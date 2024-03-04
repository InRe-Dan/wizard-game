shader_type canvas_item;
// This might come in handy!
render_mode world_vertex_coords;

// Parameters
uniform float wave_low_threshold;
uniform float wave_high_threshold;

// Random noise
uniform sampler2D snow_noise;
uniform sampler2D water_noise;

// Set by floor handler
uniform sampler2D elements;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 water(vec2 uv) {
	vec4 wave = texture(water_noise, mod(uv + vec2(TIME) * 0.01, 1.0));
	if (wave_low_threshold < wave.r && wave_high_threshold > wave.r) {
		return vec4(0.8, 0.8, 1.0, 0.6);
	}
	return vec4(0.1, 0.2, 1., 0.6);
}

vec4 ice(vec2 uv) {
	return texture(snow_noise, uv);
}

vec4 fire() {
	return vec4(0.8, 0.5, 0.0, 0.6);
}

void fragment() {
	if (COLOR.r > 0.01) {
		COLOR = fire();
	} else if (COLOR.g > 0.01) {
		COLOR = ice(UV);
	} else if (COLOR.b > 0.01) {
		COLOR = water(UV);
	} else {
		COLOR = vec4(0.);
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
}
