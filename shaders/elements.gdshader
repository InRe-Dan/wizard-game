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
uniform sampler2D snow_gradient : filter_nearest, repeat_enable;
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

vec4 water(vec2 pos, vec4 col) {
	vec2 uv = pos / vec2(textureSize(water_noise, 0));
	vec2 dir = normalize(vec2(sin(TIME * 0.01), cos(TIME * 0.01)));
	vec2 offset = 0.03 * (mat2(vec2(0., -1.), vec2(1., 0.)) * dir) * sin(TIME * 1.5);
	vec4 wave = texture(water_noise, uv + offset + TIME * dir * wave_speed);
	wave -= texture(water_noise_2, uv + TIME * vec2(0.7, -0.7) * wave_subtract_speed) * 0.2;
	vec4 returned;
	if (wave_low_threshold < wave.r && wave_high_threshold > wave.r) {
		returned = wave_colour;
	} else if (wave.r > wave_low_threshold - transition_length  && wave.r < wave_low_threshold) {
		returned = water_transition_colour;
		
	} else if (wave.r < wave_high_threshold + transition_length  && wave.r > wave_high_threshold) {
		returned = water_transition_colour;
	}else {
		returned = water_colour;
	}
	returned.a = pow(col.b, 0.5);
	return returned;
}

vec4 ice(vec2 pos, vec4 col) {
	vec4 returned = texture(snow_noise, pos / vec2(textureSize(snow_noise, 0).xy));
	returned = texture(snow_gradient, returned.xy);
	vec4 rand = texture(snow_noise, 20. * pos / vec2(textureSize(snow_noise, 0)));
	returned.a = 0.5;
	if (col.g < rand.r) {
		returned.a = 0.;
	}
	// return returned;
	return returned;
}

vec4 fire(vec2 pos, vec4 col) {
	vec2 uv = pos / vec2(textureSize(fire_noise, 0));
	vec4 wave = texture(fire_noise, uv + TIME * vec2(0., 1.) * fire_speed) * 0.3;
	wave /= pow(col.r, 1.);
	wave += texture(fire_noise_2, uv + TIME * vec2(-0.7, 0.7) * fire_subtract_speed) * 0.3;
	wave += texture(fire_noise_2, uv + 0.5 + TIME * vec2(0.7, 0.7) * fire_subtract_speed * 0.7) * 0.3;
	vec4 returned = texture(fire_gradient, wave.rg);
	return returned;
}

void fragment() {
	vec4 f = fire(world_pos, COLOR);
	vec4 i = ice(world_pos, COLOR);
	vec4 w = water(world_pos, COLOR);
	COLOR = (COLOR.r * f + i * COLOR.g + COLOR.b * w) / (COLOR.r + COLOR.g + COLOR.b);
}

void light() {
	vec4 col = texture(elements, UV);
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
	if ((col.b > 0.05) || (col.g > 0.05)) {
		if (COLOR.r > 0.95) {
			LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * 1.5, LIGHT_COLOR.a);
		}
	}
}
