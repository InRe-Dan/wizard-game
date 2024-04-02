#[compute]
#version 450

layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;

layout(rgba8, binding = 0) restrict readonly uniform image2D i;

layout(rgba8, binding = 1) restrict uniform image2D o;

void decay(ivec2 coords, vec4 mask) {
	vec4 pixel = imageLoad(i, coords);
	if (length(pixel * mask) < 0.01) {
		return;
	}
	float sum = 0.0;
	sum += length(imageLoad(i, ivec2(-1, -1) + coords) * mask);
	sum += length(imageLoad(i, ivec2(-1, 0) + coords) * mask);
	sum += length(imageLoad(i, ivec2(-1, 1) + coords) * mask);
	sum += length(imageLoad(i, ivec2(0, -1) + coords) * mask);
	sum += length(imageLoad(i, ivec2(0, 1) + coords) * mask);
	sum += length(imageLoad(i, ivec2(1, -1) + coords) * mask);
	sum += length(imageLoad(i, ivec2(1, 0) + coords) * mask);
	sum += length(imageLoad(i, ivec2(1, 1) + coords) * mask);
	if (sum < 5) {
		imageStore(o, coords, pixel - vec4(vec3(0.01), 0.0));
	} else {
		imageStore(o, coords, pixel);
	}
}

void main() {
	decay(ivec2(gl_GlobalInvocationID.xy), vec4(1., 0., 0., 0.));
	decay(ivec2(gl_GlobalInvocationID.xy), vec4(0., 1., 0., 0.));
	decay(ivec2(gl_GlobalInvocationID.xy), vec4(0., 0., 1., 0.));
}
