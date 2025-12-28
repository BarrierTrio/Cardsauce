#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
#define MY_HIGHP_OR_MEDIUMP highp
#else
#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 hamon;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
//self.ARGS.send_to_shader[1] = G.TIMERS.REAL
extern MY_HIGHP_OR_MEDIUMP number time;
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

extern Image textureFront;
//extern Image textureBack;

#define PI 3.14159265359

const vec2  SCROLLING_SPEED = vec2(-1.0, -1.0);

const float HEIGHT  = 8.0;

const float DISTANCE = 7.0;
const int   COUNT    = 2;
const float FADE     = 0.25;
const float START_ALPHA = 0.8;
const float TINT_AMOUNT = 0.5;
const vec4  TINT = vec4(1.0);
const bool  PULSE_BOTH = false;
const float DIAGONAL_ANGLE = 45.0;
const int   BLEND_MODE = 0;

vec3 toLinear(vec3 c) {
    return pow(c, vec3(2.2));
}

vec3 toSRGB(vec3 c) {
    return pow(c, vec3(1.0 / 2.2));
}

vec4 toMonoAndAlpha(vec4 c) {
    float lum = dot(c.rgb, vec3(0.299,0.587,0.114));
    float a = lum >= 0.5 ? 1.0 : 0.0;
    return vec4(vec3(lum), a);
}

vec2 scrollingUV(vec2 uv, float t, float speedFactor) {
    vec2 T = vec2(-1.0) * t * 0.1 * speedFactor;
    return vec2(mod(uv.x * 4 + T.x, 1), mod(uv.y * 4 + T.y, 1));
}

vec4 dissolve_mask(vec4 tex, vec2 uv) {
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, shadow ? tex.a * 0.3 : tex.a);
    }

    float adjusted_dissolve = (dissolve * dissolve * (3. - 2. * dissolve)) * 1.02 - 0.01; // Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does
    // not pause at extreme values

    float t = time * 10.0 + 2003.;
    vec2 floored_uv = (floor((uv * texture_details.ba))) / max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

    vec2 field_part1 = uv_scaled_centered + 50. * vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50. * vec2(cos(t / 53.1532), cos(t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50. * vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field =
    (1. + (cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) + cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)))
    / 2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5 * cos((adjusted_dissolve) / 82.612 + (field + -.5) * 3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x) * (5. + 5. * dissolve) : 0.) * (dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y) * (5. + 5. * dissolve) : 0.) * (dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5 * (0.5 - abs(adjusted_dissolve - 0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0., 0., 0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a * 0.3 : tex.a) : .0);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec4 tex = Texel(texture, texture_coords);
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;

    float bob = sin(2.0 * PI * 0.4 * hamon.y);

    vec2 scUV = scrollingUV(uv, hamon.y, 1.0);
    vec2 scaled_tex_coords = (scUV * texture_details.ba + texture_details.xy*texture_details.ba)/image_details;

    vec4 mainCol = toMonoAndAlpha(tex);
    vec3 scrollRGB = Texel(textureFront, scaled_tex_coords).rgb;

    vec4 mixedMain = vec4(scrollRGB * mainCol.a, mainCol.a);


    return dissolve_mask(mixedMain, uv);
}


extern MY_HIGHP_OR_MEDIUMP vec2 mouse_screen_pos;
extern MY_HIGHP_OR_MEDIUMP float hovering;
extern MY_HIGHP_OR_MEDIUMP float screen_scale;

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position) {
    if (hovering <= 0.0) {
        return transform_projection * vertex_position;
    }
    float mid_dist = length(vertex_position.xy - 0.5 * love_ScreenSize.xy) / length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy) / screen_scale;
    float scale = 0.2 * (-0.03 - 0.3 * max(0.0, 0.3 - mid_dist)) * hovering *
                  (length(mouse_offset) * length(mouse_offset)) / (2.0 - mid_dist);

    return transform_projection * vertex_position + vec4(0, 0, 0, scale);
}
#endif
