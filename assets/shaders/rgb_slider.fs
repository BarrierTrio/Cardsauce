#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP float start_x = 0;
extern MY_HIGHP_OR_MEDIUMP float end_x = 1920;
extern MY_HIGHP_OR_MEDIUMP number colour_channel = 1;
extern MY_HIGHP_OR_MEDIUMP vec3 current_color;

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	vec3 base_colour = vec3(current_color.r/255., current_color.g/255., current_color.b/255.);
	float uv = (screen_coords.x - start_x) / (end_x - start_x);

	if (colour_channel == 1) {
		base_colour.r = uv;
	} else if (colour_channel == 2) {
		base_colour.g = uv;
	} else if (colour_channel == 3) {
		base_colour.b = uv;
	}

	return vec4(base_colour, 1);
}