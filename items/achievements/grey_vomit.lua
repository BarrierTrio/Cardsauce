local achInfo = {
    rarity = 2,
    config = {key_1 = 'j_csau_greyjoker', key_2 = 'j_csau_vomitblast'},
    unlock_condition = function(self, args)
        if G.jokers and #G.jokers.cards > 0 then
            return ArrowAPI.game.have_multiple_jokers({self.config.key_1, self.config.key_2})
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????',
    }}
end

return achInfo