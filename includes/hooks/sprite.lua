local ref_draw_shader = Sprite.draw_shader
function Sprite:draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
    if self.atlas.name == 'stickers' then
        if other_obj and other_obj.parent and other_obj.parent.Mid and other_obj.parent.Mid.config and other_obj.parent.Mid.config.center_key then
            if other_obj.parent.Mid.config.center_key == 'j_csau_bonzi' then
                mx = 0.45
            end
        end
    end
    return ref_draw_shader(self, _shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
end