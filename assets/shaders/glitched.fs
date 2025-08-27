// Shader by Sir. Gameboy

#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define MY_HIGHP_OR_MEDIUMP highp
#else
	#define MY_HIGHP_OR_MEDIUMP mediump
#endif

extern MY_HIGHP_OR_MEDIUMP vec2 glitched;
extern MY_HIGHP_OR_MEDIUMP number dissolve;
extern MY_HIGHP_OR_MEDIUMP number time;
// (sprite_pos_x, sprite_pos_y, sprite_width, sprite_height) [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec4 texture_details;
// (width, height) for atlas texture [not normalized]
extern MY_HIGHP_OR_MEDIUMP vec2 image_details;
extern bool shadow;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_1;
extern MY_HIGHP_OR_MEDIUMP vec4 burn_colour_2;

// custom var for random seed
extern MY_HIGHP_OR_MEDIUMP number seed;

// function defs for required functions later in the code
vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv);
number hue(number s, number t, number h);
vec4 HSL(vec4 c);
vec4 RGB(vec4 c);

// base game negative effect
vec4 negative(float t, vec4 tex) 
{
    vec4 hsl = HSL(tex);
    if (t > 0.0 || t < 0.0) {
        hsl.b = (1.-hsl.b);
    }
    hsl.r = -hsl.r+0.2;

    return RGB(hsl) + 0.8*vec4(79./255., 99./255.,103./255.,0.);
}

// base game shine effect
vec4 shine_effect(vec4 tex, vec2 uv)
{
    float shine_amount = 0.25;

    number low = min(tex.r, min(tex.g, tex.b));
    number high = max(tex.r, max(tex.g, tex.b));
    number delta = high - low - 0.1;

    number fac = 0.8 + 0.9*sin(11.*uv.x+4.32*uv.y + glitched.r*12. + cos(glitched.r*5.3 + uv.y*4.2 - uv.x*4.));
    number fac2 = 0.5 + 0.5*sin(8.*uv.x+2.32*uv.y + glitched.r*5. - cos(glitched.r*2.3 + uv.x*8.2));
    number fac3 = 0.5 + 0.5*sin(10.*uv.x+5.32*uv.y + glitched.r*6.111 + sin(glitched.r*5.3 + uv.y*3.2));
    number fac4 = 0.5 + 0.5*sin(3.*uv.x+2.32*uv.y + glitched.r*8.111 + sin(glitched.r*1.3 + uv.y*11.2));
    number fac5 = sin(0.9*16.*uv.x+5.32*uv.y + glitched.r*12. + cos(glitched.r*5.3 + uv.y*4.2 - uv.x*4.));

    number maxfac = 0.7*max(max(fac, max(fac2, max(fac3,0.0))) + (fac+fac2+fac3*fac4), 0.);

    float shine = shine_amount * (-delta + delta * maxfac * (0.7 - fac5 * 0.27) - 0.1);
    return vec4(tex.rgb + shine, tex.a);
}

// random number between 0 and 1, depending on input vec2
float rand(vec2 co) 
{
    // use external random seed for variation across instances
    co += (seed / 2.0) + time; // also use start time 
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float rand(float co) 
{
    return rand(vec2(co));
}

vec4 random_grid(float t, vec2 uv)
{
    vec2 resolution = vec2(4., 6.);
    vec2 ipos = floor(uv * resolution);

    float r = rand(ipos + t);
    vec4 random_squares = vec4(r);

    return random_squares;
}

vec2 uv_offset(float t, vec2 resolution, vec2 uv)
{
    vec2 block = floor(uv * resolution);
    return vec2(rand(block + t), rand(block + (t + 1.)));
}

// round to pixel (idk if this actually does anything)
vec2 round_to_pixel(vec2 uv, vec2 pixel_size)
{
    return floor(uv * image_details.xy + 0.5) / image_details.xy - pixel_size / 2.;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // for some reason glitched.y is the time value, not the variable called time
    float t = glitched.y; 
    float speed = 2.5; // speed multiplier for time
    float clock = floor(t * speed); // stepped time
    float rtime = rand(floor(t * speed * rand(clock))); // randomly stepped time

    vec4 tex_orig = Texel(texture, texture_coords);
    vec2 uv =  (((texture_coords)*(image_details)) - texture_details.xy*texture_details.ba)/texture_details.ba;
    
    vec2 resolution = vec2(4., 6.);

    float sprite_width = texture_details.z / image_details.x;
    float sprite_height = texture_details.a / image_details.y;
    vec2 sprite_size = vec2(sprite_width, sprite_height); // normalised size

    float sprite_pos_x = texture_details.x * sprite_width;
    float sprite_pos_y = texture_details.y * sprite_height;
    vec2 sprite_pos = vec2(sprite_pos_x, sprite_pos_y); // normalised pos

    vec2 pixel_size = vec2(1.) / image_details.xy; // normalised pixel size

    vec4 glitch_layer = vec4(0.);

    // glitch effect
    vec4 random_mask = random_grid(rtime, uv);
    float grid_value = random_mask.r;
    if (grid_value > 0.5) // half chance for grid piece to be glitched
    {
        vec2 offset = uv_offset(rtime, resolution, uv);
        offset = mod(texture_coords + offset, sprite_size); 

        offset = round_to_pixel(offset, pixel_size);

        glitch_layer = Texel(texture, sprite_pos + offset);
        
        if (grid_value > 0.6 && grid_value <= 0.7) // further 10% chance for negative
        {
            glitch_layer = negative(t, glitch_layer);
        }
        else if (grid_value > 0.7 && grid_value <= 0.8) // or 10% chance for uv stretch
        {
            if(grid_value > 0.75) // 5% chance for horizontal stretch
            { 
                offset.y = offset.x;
            }
            else // 5% chance for vertical stretch
            { 
                offset.x = offset.y;
            }

            offset = round_to_pixel(offset, pixel_size);

            glitch_layer = Texel(texture, sprite_pos + offset);
        }
        else if (grid_value > 0.8 && grid_value <= 0.9) // or 10% chance for hue shift
        {
            vec4 hsl = HSL(glitch_layer);
            hsl.r = fract(hsl.r + rand(rtime + grid_value));
            glitch_layer = RGB(hsl);
        }
        else if(grid_value > 0.9) // or 10% chance for colour offset
        {
            float red_offset = rand(rtime + grid_value + 1.) - 0.5;
            float green_offset = rand(rtime + grid_value + 2.) - 0.5;
            float blue_offset = rand(rtime + grid_value + 3.) - 0.5;
            glitch_layer.rgb += 0.2 * vec3(red_offset, green_offset, blue_offset);
        }
    }
    
    vec4 tex = tex_orig;
    tex = mix(tex, glitch_layer, glitch_layer.a);
    tex = shine_effect(tex, uv);

    // required for dissolve fx
    return dissolve_mask(tex*colour, texture_coords, uv);
}

// --- below are all required functions --- //

vec4 dissolve_mask(vec4 tex, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, shadow ? tex.a*0.3: tex.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.-2.*dissolve))*1.02 - 0.01; //Adjusting 0.0-1.0 to fall to -0.1 - 1.1 scale so the mask does not pause at extreme values

	float t = time * 10.0 + 2003.;
	vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);
	
	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;
    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos( (adjusted_dissolve) / 82.612 + ( field + -.5 ) *3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5. + 5.*dissolve) : 0.)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5. + 5.*dissolve) : 0.)*(dissolve);

    if (tex.a > 0.01 && burn_colour_1.a > 0.01 && !shadow && res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
        if (!shadow && res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5)) && res > adjusted_dissolve) {
            tex.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            tex.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.,0.,0.) : tex.xyz, res > adjusted_dissolve ? (shadow ? tex.a*0.3: tex.a) : .0);
}

number hue(number s, number t, number h)
{
	number hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	number t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	number s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	number low = min(c.r, min(c.g, c.b));
	number high = max(c.r, max(c.g, c.b));
	number delta = high - low;
	number sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
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
    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)/length(love_ScreenSize.xy);
    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;
    float scale = 0.2*(-0.03 - 0.3*max(0., 0.3-mid_dist))
                *hovering*(length(mouse_offset)*length(mouse_offset))/(2. -mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif