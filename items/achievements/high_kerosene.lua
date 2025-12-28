local achInfo = {
    rarity = 1,
    config = {chips = 200, joker = 'j_csau_kerosene'},
    unlock_condition = function(self, args)
        local cards = SMODS.find_card(self.config.joker)
        if cards and #cards > 0 then
            for _, v in ipairs(cards) do
                if to_big(v.ability.extra.chips) >= to_big(self.config.chips) then
                    return true
                end
            end
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.joker].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker} or '?????',
        self.config.chips
    }}
end

return achInfo