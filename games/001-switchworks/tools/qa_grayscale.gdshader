shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
void fragment() {
    vec4 source = textureLod(screen_texture, SCREEN_UV, 0.0);
    float luminance = dot(source.rgb, vec3(0.2126, 0.7152, 0.0722));
    COLOR = vec4(vec3(luminance), source.a);
}
