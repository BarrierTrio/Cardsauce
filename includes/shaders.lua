---------------------------
--------------------------- Stand Draw Steps
---------------------------

local ref_debuff_func = SMODS.DrawSteps.debuff.func
SMODS.DrawStep:take_ownership('debuff', {
    func = function(self, layer)
        ref_debuff_func(self,layer)
        if self.cured_debuff then
            self.children.center:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            if self.children.front and self.ability.effect ~= 'Stone Card' and not self.config.center.replace_base_card then
                self.children.front:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            end
        end
    end,
})





---------------------------
--------------------------- 2 Kings VFX
---------------------------

local old_back_ds = SMODS.DrawSteps.back.func
SMODS.DrawStep:take_ownership('back', {
    func = function(self, layer)
        if not self.csau_2kings_rank then
            return old_back_ds(self, layer)
        end

        local overlay = G.C.WHITE
        if self.csau_2kings_rank > 3 then
            self.back_overlay = self.back_overlay or {}
            self.back_overlay[1] = 0.5 + ((self.csau_2kings_total - self.csau_2kings_rank)%7)/50
            self.back_overlay[2] = 0.5 + ((self.csau_2kings_total - self.csau_2kings_rank)%7)/50
            self.back_overlay[3] = 0.5 + ((self.csau_2kings_total - self.csau_2kings_rank)%7)/50
            self.back_overlay[4] = 1
            overlay = self.back_overlay
        end

        self.children.back:draw(overlay)
    end
})