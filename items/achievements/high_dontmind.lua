local achInfo = {
    rarity = 1,
    config = {joker_1 = 'j_csau_dontmind', joker_2 = 'j_csau_pivot', level = 20},
    unlock_condition = function(self, args)
        return args.type == "hand_level" and (next(SMODS.find_card(self.config.joker_1)) or next(SMODS.find_card(self.config.joker_2)))
        and args.hand == "High Card" and to_big(args.level) < to_big(self.config.level) and to_big(args.level_after) >= to_big(self.config.level)
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        self.config.level,
        G.P_CENTERS[self.config.joker_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker_1} or '?????',
        G.P_CENTERS[self.config.joker_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker_2} or '?????'
    }}
end

return achInfo