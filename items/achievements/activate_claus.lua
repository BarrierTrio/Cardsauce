local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_maskedjoker', num = 5},
    unlock_condition = function(self, args)
        return args.type == 'activate_claus'
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        self.config.num,
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????'
    }}
end

return achInfo