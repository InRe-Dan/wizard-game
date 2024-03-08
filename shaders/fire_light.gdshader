shader_type canvas_item;
render_mode world_vertex_coords, blend_add, unshaded;

uniform sampler2D noise : repeat_enable;
varying vec2 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy + (UV / TEXTURE_PIXEL_SIZE).xy;
}

void fragment() {
	COLOR = vec4(COLOR.rgb, COLOR.a * texture(noise, world_pos / vec2(textureSize(noise, 0))).r);
}
