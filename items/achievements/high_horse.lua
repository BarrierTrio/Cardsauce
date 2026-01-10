local achInfo = {
    rarity = 1,
    config = {key_1 = 'c_csau_devilstory', key_2 = 'm_gold', val = 5, ref_value = 'count'},
    unlock_condition = function(self, args)
        if args.type ~= 'scale_card' or args.card.config.center.key ~= self.config.key_1 then return end

        return args.ref_value == self.config.ref_value and args.ref_table[args.ref_value] >= self.config.val
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        localize{type = 'name_text', set = 'Enhanced', key = self.config.key_2}..'s',
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'VHS', key = self.config.key_1} or '????????',
        self.config.val
    }}
end

return achInfo