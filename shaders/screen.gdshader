shader_type canvas_item;
render_mode world_vertex_coords;

uniform float quantizationSteps = 8;
uniform float vignetteExponent = 0.5;
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D noise_texture : repeat_enable, filter_nearest;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest, source_color;
varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy + (UV / TEXTURE_PIXEL_SIZE).xy;
}

void fragment() {
	// apply vignette
	vec2 resolution = 1. / SCREEN_PIXEL_SIZE;
	float dist = length(FRAGCOORD.xy - resolution / 2.);
	float light = dist / length(resolution);
	//quantize and dither
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR = vec4(COLOR.rgb * pow(1. - light, vignetteExponent), COLOR.a);
	float stepSize = 1./quantizationSteps;
	vec3 quantizedCol = floor(COLOR.xyz / stepSize) * stepSize;
	vec3 remainder = mod(COLOR.xyz, stepSize);
	vec3 ditherProb = remainder / stepSize;
	vec2 uv = world_pos / vec2(textureSize(noise_texture, 0));
	float rand = texture(noise_texture, uv + TIME * 0.2 * vec2(0.001, 0.00345)).r * 0.5;
	rand += texture(noise_texture, uv + TIME * 0.3 * vec2(-0.03, +0.02)).r * 0.25;
	rand += texture(noise_texture, uv + TIME * 0.4 * vec2(+0.003, -0.05)).r * 0.12;
	rand += texture(noise_texture, uv + TIME * 0.5 * vec2(-0.03, -0.01)).r * 0.13;
	vec3 dither_colour = vec3(bvec3(ditherProb.x > rand, ditherProb.y > rand, ditherProb.z > rand));
	COLOR = vec4(quantizedCol.xyz + stepSize * dither_colour, COLOR.w);
}