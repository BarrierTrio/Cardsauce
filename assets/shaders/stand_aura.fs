#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern Image noise_tex;
extern Image gradient_tex;
extern MY_HIGHP_OR_MEDIUMP float time;
extern MY_HIGHP_OR_MEDIUMP vec4 outline_color;
extern MY_HIGHP_OR_MEDIUMP vec4 base_color;
extern MY_HIGHP_OR_MEDIUMP float spread;
extern MY_HIGHP_OR_MEDIUMP vec2 step_size;
extern MY_HIGHP_OR_MEDIUMP number seed;
extern MY_HIGHP_OR_MEDIUMP number aura_rate = 1;

vec4 effect(vec4 color, Image tex, vec2 tex_coords, vec2 screen_coords) {
	float t = (time * aura_rate) + seed / 65536.;

	vec4 ret = Texel(tex, tex_coords);
	vec2 upper_coords = vec2(tex_coords.x, tex_coords.y + 0.12);
	vec2 lower_coords = vec2(tex_coords.x, tex_coords.y - 0.03);
	float noise_value_1 = Texel(noise_tex, upper_coords + vec2(0.0, t)).x;
	float noise_value_2 = Texel(noise_tex, lower_coords + vec2(0.0, t + 0.43)).x;

    float alpha = 4 * ret.a;
    alpha -= Texel(tex, tex_coords + vec2(step_size.x, 0.0)).a;
    alpha -= Texel(tex, tex_coords + vec2(-step_size.x, 0.0)).a;
    alpha -= Texel(tex, tex_coords + vec2(0.0, step_size.y)).a;
    alpha -= Texel(tex, tex_coords + vec2(0.0, -step_size.y)).a;

    vec4 ret_color = vec4(outline_color.rgb, min(outline_color.a, alpha));
    if (alpha <= 0 && ret.a > 0) {
        ret_color = base_color;
    }

	if (tex_coords.y < 0.946) {
		float grad_lower = Texel(gradient_tex, lower_coords).x;
		grad_lower -= smoothstep(spread + 0.4, spread + 0.7, length(lower_coords + vec2(-0.5, -0.5)) / spread);
		float step1_lower = step(noise_value_2, grad_lower);
		float step2_lower = step(noise_value_2, grad_lower - 0.2);
		vec3 bd_lower = mix(base_color.rgb, outline_color.rgb, step1_lower - step2_lower);
		vec4 apply_lower = vec4(bd_lower, min(step1_lower, base_color.a));

		if ((apply_lower.a > 0) && (ret.a <= 0 || alpha > 0)) {
			ret_color = apply_lower;
		}
	}
	
	float grad_upper = Texel(gradient_tex, upper_coords).x;
	grad_upper -= smoothstep(spread + 0.35, spread + 0.5, length(upper_coords + vec2(-0.5, -0.4)) / spread);
	float step1_upper = step(noise_value_1, grad_upper);
	float step2_upper = step(noise_value_1, grad_upper - 0.1);
	vec3 bd_upper = mix(base_color.rgb, outline_color.rgb, step1_upper - step2_upper);
	vec4 apply_upper = vec4(bd_upper, min(step1_upper, base_color.a));

	if ((apply_upper.a > 0) && (ret.a <= 0 || alpha > 0)) {
		ret_color = apply_upper;
	}
	
	return ret_color;
}

extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position( mat4 transform_projection, vec4 vertex_position )
{
    if (hovering <= 0.){
        return transform_projection * vertex_position;
    }
    MY_HIGHP_OR_MEDIUMP float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    MY_HIGHP_OR_MEDIUMP vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    MY_HIGHP_OR_MEDIUMP float scale = 0.1*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif