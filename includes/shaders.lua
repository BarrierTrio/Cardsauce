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
--------------------------- VHS shader effects
---------------------------

SMODS.Shader({ key = 'vhs', path = 'vhs.fs' })

local slide_mod = 12
local slide_out_delay = 0.05
local width_factor = 0.1

local old_center_ds = SMODS.DrawSteps.center.func
SMODS.DrawStep:take_ownership('center', {
    func = function(self, layer)
        if self.ability.set ~= 'VHS' then
            return old_center_ds(self, layer)
        end
    end
})

SMODS.DrawStep {
    key = 'vhs_slide',
    order = -1,
    func = function(self, layer)
        if self.ability.set ~= 'VHS' or (self.area and self.area.config.collection and not self.config.center.discovered) then
            --If the card is not yet discovered
            if not self.config.center.discovered and self.ability.set == 'VHS' then

                local shared_sprite = G.shared_undiscovered_tarot
                local scale_mod = -0.05 + 0.05*math.sin(1.8*G.TIMERS.REAL)
                local rotate_mod = 0.03*math.sin(1.219*G.TIMERS.REAL)

                self.children.center:draw_shader('dissolve', self.shadow_height)
	            self.children.center:draw_shader('dissolve')
                shared_sprite.role.draw_major = self
                if (self.config.center.undiscovered and not self.config.center.undiscovered.no_overlay) or not( SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].no_overlay) then
                    shared_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                else
                    if SMODS.UndiscoveredSprites[self.ability.set] and SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite then
                        SMODS.UndiscoveredSprites[self.ability.set].overlay_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                    end
                end
            end

            return
        end

        if not self.ability.slide_move or not self.ability.slide_out_delay then
            self.ability.slide_move = 0
            self.ability.slide_out_delay = 0
        end

        if self.ability.activated and self.ability.slide_move < 1 then
            if self.ability.slide_out_delay < slide_out_delay then
                self.ability.slide_out_delay = self.ability.slide_out_delay + (slide_mod * G.real_dt)
            else
                self.ability.slide_move = self.ability.slide_move + (slide_mod * G.real_dt)
                if self.ability.slide_move > 1 then
                    self.ability.slide_move = 1
                end
            end
        elseif not self.ability.activated and self.ability.slide_move > 0 then
            self.ability.slide_out_delay = 0
            self.ability.slide_move = self.ability.slide_move - (slide_mod * G.real_dt)

            if self.ability.slide_move < 0 then
                self.ability.slide_move = 0
                self.children.center.VT.w = self.T.w
            end

        end

        if self.ability.slide_move <= 0 then
            self.shadow_height = self.states.drag.is and 0.35 or 0.1
            self.children.center:draw_shader('dissolve', self.shadow_height)
	        self.children.center:draw_shader('dissolve')
            return
        end

        -- adjusting the width to match the shader change
        if not self.children.center.pinch.x then
            self.children.center.VT.x = self.T.x - width_factor * self.ability.slide_move * 2
            self.children.center.VT.w = (self.T.w * width_factor * self.ability.slide_move) + self.T.w
        end

        -- default tilt behavior
        G.SHADERS['csau_vhs']:send('spine', G.ASSET_ATLAS['csau_blackspine'].image)
        G.SHADERS['csau_vhs']:send('lerp', self.ability.slide_move)

        self.shadow_height = self.states.drag.is and 0.35 or 0.1
        self.children.center:draw_shader('csau_vhs', self.shadow_height)
	    self.children.center:draw_shader('csau_vhs', nil)

        local center = self.config.center
        if center.draw and type(center.draw) == 'function' then
            center:draw(self, layer)
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}






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