shader_type canvas_item;
// This might come in handy!
render_mode world_vertex_coords;

// Parameters
uniform float wave_low_threshold;
uniform float wave_high_threshold;
uniform vec4 water_colour : source_color;
uniform vec4 wave_colour : source_color;
uniform vec4 water_transition_colour : source_color;
uniform float wave_speed;
uniform float wave_subtract_speed;
uniform float transition_length;
uniform sampler2D fire_gradient;
uniform float fire_speed;
uniform float fire_subtract_speed;


// Random noise
uniform sampler2D snow_noise : filter_nearest, repeat_enable;
uniform sampler2D water_noise : filter_nearest, repeat_enable;
uniform sampler2D water_noise_2 : filter_nearest, repeat_enable;
uniform sampler2D fire_noise : filter_nearest, repeat_enable;
uniform sampler2D fire_noise_2 : filter_nearest, repeat_enable;

// Set by floor handler
uniform sampler2D elements;

varying vec2 world_pos;
varying vec4 pixel_color;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy + (UV / TEXTURE_PIXEL_SIZE).xy;
}

vec4 water(vec2 pos) {
	vec2 uv = pos / vec2(textureSize(water_noise, 0));
	vec4 wave = texture(water_noise, uv + TIME * vec2(sin(TIME * 0.01), cos(TIME * 0.01)) * wave_speed) * 1.0;
	wave -= texture(water_noise_2, uv + TIME * vec2(0.7, -0.7) * wave_subtract_speed) * 0.2;
	if (wave_low_threshold < wave.r && wave_high_threshold > wave.r) {
		return wave_colour;
	} else if (wave.r > wave_low_threshold - transition_length  && wave.r < wave_low_threshold) {
		return water_transition_colour;
		
	} else if (wave.r < wave_high_threshold + transition_length  && wave.r > wave_high_threshold) {
		return water_transition_colour;
	}
	return water_colour;
}

vec4 ice(vec2 pos) {
	return vec4(texture(snow_noise, pos / vec2(textureSize(snow_noise, 0).xy)).xyz, 0.3);
}

vec4 fire(vec2 pos) {
	vec2 uv = pos / vec2(textureSize(fire_noise, 0));
	vec4 wave = texture(fire_noise, uv + TIME * vec2(0., 1.) * fire_speed) * 0.3;
	wave += texture(fire_noise_2, uv + TIME * vec2(-0.7, -0.7) * fire_subtract_speed) * 0.3;
	wave += texture(fire_noise_2, uv + 0.5 + TIME * vec2(0.7, -0.7) * fire_subtract_speed * 0.7) * 0.3;
	return texture(fire_gradient, wave.rg);
}

void fragment() {
	if (COLOR.r > 0.01) {
		COLOR = fire(world_pos);
	} else if (COLOR.g > 0.01) {
		COLOR = ice(world_pos);
	} else if (COLOR.b > 0.01) {
		COLOR = water(world_pos);
	} else {
		COLOR = vec4(0.);
	}
}

void light() {
	if (texture(elements, UV).b > 0.01 && COLOR.r > 0.9) {
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * 3., LIGHT_COLOR.a);
	} else {
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
	}
}
