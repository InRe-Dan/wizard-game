shader_type canvas_item;

void light() {
	LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
	if (texture_sdf(screen_uv_to_sdf(SCREEN_UV)) > -10.) {
		float value = 1. + 0.5 * (1. + clamp(texture_sdf(screen_uv_to_sdf(SCREEN_UV)), 0., -10.) / 10.);
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY * value, LIGHT_COLOR.a);
	} else {
		LIGHT = vec4(LIGHT_COLOR.rgb * COLOR.rgb * LIGHT_ENERGY, LIGHT_COLOR.a);
	}
}