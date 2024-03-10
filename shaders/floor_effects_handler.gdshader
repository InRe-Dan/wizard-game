shader_type canvas_item;
render_mode blend_add, unshaded;

void fragment() {
	// Code borrwed from https://www.reddit.com/r/godot/comments/12cb1t2/comment/jf1dmfo/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	// r/Godot, u/Kwabi, https://pastebin.com/S3tKQs9j
	vec3 col = texture(TEXTURE, UV).xyz * 0.16;
    col += texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.075;
    col += texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.075;
    col += texture(TEXTURE, UV + vec2(2.0 * TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.06;
    col += texture(TEXTURE, UV + vec2(2.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.06;
    col += texture(TEXTURE, UV + vec2(3.0 * TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.045;
    col += texture(TEXTURE, UV + vec2(3.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.045;
    col += texture(TEXTURE, UV + vec2(4.0 * TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.025;
    col += texture(TEXTURE, UV + vec2(4.0 * -TEXTURE_PIXEL_SIZE.x, 0.0)).xyz * 0.025;
	col += texture(TEXTURE, UV + vec2(0.0, TEXTURE_PIXEL_SIZE.y)).xyz * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, -TEXTURE_PIXEL_SIZE.y)).xyz * 0.075;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * TEXTURE_PIXEL_SIZE.y)).xyz * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 2.0 * -TEXTURE_PIXEL_SIZE.y)).xyz * 0.06;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * TEXTURE_PIXEL_SIZE.y)).xyz * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 3.0 * -TEXTURE_PIXEL_SIZE.y)).xyz * 0.045;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * TEXTURE_PIXEL_SIZE.y)).xyz * 0.025;
    col += texture(TEXTURE, UV + vec2(0.0, 4.0 * -TEXTURE_PIXEL_SIZE.y)).xyz * 0.025;
	vec3 new_col = vec3(0.0);
	if (col.x > 0.01) {
		 new_col += vec3(1.0, 0.3, 0.05 ) * col.r;
	} if (col.g > 0.01) {
		new_col += vec3(0.05, 1., 1.) * col.g * 0.3;
	} if (length(new_col) < 0.001) {
		COLOR = vec4(0.0);
	} else {
		COLOR.a *= 1.0;
	}
	COLOR.xyz = new_col;
}
