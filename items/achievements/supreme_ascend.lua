local achInfo = {
    rarity = 2,
    config = {key_1 = 'j_csau_rapture', key_2 = 'j_csau_kings', val = 30, ref_value = 'mult'},
    unlock_condition = function(self, args)
        if args.type ~= 'scale_card' or args.card.config.center.key ~= self.config.key then return end

        return next(SMODS.find_card(self.config.key_2)) and args.ref_value == self.config.ref_value
        and args.ref_table[args.ref_value] >= self.config.val
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????',
    }}
end

return achInfo
