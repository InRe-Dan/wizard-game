shader_type canvas_item;

uniform float quantizationSteps = 8;
uniform float vignetteExponent = 0.5;
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest, source_color;
uniform sampler2D noise_texture;

float sdAxisAlignedRect(vec2 uv, vec2 tl, vec2 br)
{
    vec2 d = max(tl-uv, uv-br);
    return length(max(vec2(0.0), d)) + min(0.0, max(d.x, d.y));
}


void fragment() {
	// apply vignette
	vec2 resolution = 1. / SCREEN_PIXEL_SIZE;
	float dist = sdAxisAlignedRect(FRAGCOORD.xy, vec2(0., 0.), resolution);
	float light = 2. * -dist / length(resolution);
	COLOR = texture(screen_texture, SCREEN_UV);
	//quantize and dither
	COLOR = vec4(COLOR.xyz * pow(light, vignetteExponent), 1.);
	float stepSize = 1./quantizationSteps;
	vec3 quantizedCol = floor(COLOR.xyz / stepSize) * stepSize;
	vec3 remainder = mod(COLOR.xyz, stepSize);
	vec3 ditherProb = remainder / stepSize;
	float rand = texture(noise_texture, SCREEN_UV).r;
	vec3 dither_colour = vec3(bvec3(ditherProb.x > rand, ditherProb.y > rand, ditherProb.z > rand));
	COLOR = vec4(quantizedCol.xyz + stepSize * dither_colour, COLOR.w);
}