shader_type canvas_item;

uniform float quantizationSteps = 8;
uniform float vignetteExponent = 0.5;
// If you intend to read from mipmaps with `textureLod()` LOD values greater than `0.0`,
// use `filter_nearest_mipmap` instead. This shader doesn't require it.
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest, source_color;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
		// Very fun effects when the third magic number is just TIME
        vec2(12.9898,78.233))) * (TIME + 2415.1231) / 20.);
}

float sdAxisAlignedRect(vec2 uv, vec2 tl, vec2 br)
{
    vec2 d = max(tl-uv, uv-br);
    return length(max(vec2(0.0), d)) + min(0.0, max(d.x, d.y));
}

void fragment() {
	vec2 resolution = 1. / SCREEN_PIXEL_SIZE;
	float dist = sdAxisAlignedRect(FRAGCOORD.xy, vec2(0., 0.), resolution);
	float light = 2. * -dist / length(resolution);
	COLOR = texture(screen_texture, SCREEN_UV);
	COLOR = vec4(COLOR.xyz * pow(light, vignetteExponent), 1.);
	float stepSize = 1./quantizationSteps;
	vec3 quantizedCol = floor(COLOR.xyz / stepSize) * stepSize;
	vec3 remainder = mod(COLOR.xyz, stepSize);
	vec3 ditherProb = remainder / stepSize;
	vec3 randVect = vec3(random(UV), random(UV), random(UV));
	vec3 stepUp = ditherProb - vec3(random((UV)));
	stepUp.x = stepUp.x > 0.? 1. : 0.;
	stepUp.y = stepUp.y > 0.? 1. : 0.;
	stepUp.z = stepUp.z > 0.? 1. : 0.;
	COLOR = vec4(quantizedCol.xyz + stepSize * stepUp, COLOR.w);
}