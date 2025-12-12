local achInfo = {
    rarity = 1,
    config = {joker = 'j_csau_muppet', x_mult = 4},
    unlock_condition = function(self, args)
        local cards = SMODS.find_card(self.config.joker)
        if cards and #cards > 0 then
            for i, v in ipairs(cards) do
                if to_big(v.ability.extra.x_mult) >= to_big(self.config.x_mult) then
                    return true
                end
            end
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.joker].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker} or '?????',
        self.config.x_mult
    }}
end

return achInfo