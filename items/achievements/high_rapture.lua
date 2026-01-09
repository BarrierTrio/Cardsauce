local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_rapture', val = 77, ref_value = 'mult'},
    unlock_condition = function(self, args)
        if args.type ~= 'scale_card' or args.card.config.center.key ~= self.config.key then return end

        return args.ref_value == self.config.ref_value and args.ref_table[args.ref_value] >= self.config.val
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
        self.config.val
    }}
end

return achInfo