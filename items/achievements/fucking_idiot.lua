local achInfo = {
    rarity = 3,
    config = {key_1 = 'j_csau_powers', key_2 = 'j_csau_beginners', key_3 = 'j_oops'},
    unlock_condition = function(self, args)
        if args.type ~= 'modify_deck' then return end
        return (ArrowAPI.game.have_multiple_jokers({self.config.key_1, self.config.key_2})
            or ArrowAPI.game.have_multiple_jokers({self.config.key_1, self.config.key_3}))
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????',
        G.P_CENTERS[self.config.key_3].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_3} or '????????'
    }}
end

return achInfo