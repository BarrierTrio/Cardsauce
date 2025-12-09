
local ref_back_ui = Back.generate_UI
function Back:generate_UI(other, ui_scale, min_dims, challenge, ...)
    if self.effect.center.artist and not Galdur then
        local ret = ref_back_ui(self, other, ui_scale, min_dims, challenge, ...)

        ret.config.minh = 1.12
        ret.nodes[1].config.padding = 0.035
        ret.nodes[1].config.minh = 1.12
        ret.nodes[1].nodes[1].config.padding = nil
        return ret
    else
        return ref_back_ui(self, other, ui_scale, min_dims, challenge, ...)
    end
end