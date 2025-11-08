SMODS.DrawStep:take_ownership('floating_sprite', {
	func = function(self, layer)
        -- TODO: possibly simplify this?
        if self.config.center.soul_pos and self.ability.set ~= 'Stand' and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

            if type(self.config.center.soul_pos.draw) == 'function' then
                self.config.center.soul_pos.draw(self, scale_mod, rotate_mod)
            elseif self.ability.name == 'Hologram' or self.config.center.key == "j_csau_shrimp" then
                self.hover_tilt = self.hover_tilt*1.5
                self.children.floating_sprite:draw_shader('hologram', nil, self.ARGS.send_to_shader, nil, self.children.center, 2*scale_mod, 2*rotate_mod)
                self.hover_tilt = self.hover_tilt/1.5
            else
                if not self.config.center.no_soul_shadow then
                    self.children.floating_sprite:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
                end
                self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
            end

            if self.edition then
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then
                        if self.edition[v.key:sub(3)] then
                            self.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                        end
                    end
                end
            end
        end
	end,
})

local old_seal_fs = SMODS.DrawSteps.seal.func
SMODS.DrawStep:take_ownership('seal', {
    func = function(self, layer)
        if not self.seal_delay then
            old_seal_fs(self, layer)
        end
    end
})








---------------------------
--------------------------- Stand Draw Steps
---------------------------

if not next(SMODS.find_mod('jojobal')) then
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
end






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