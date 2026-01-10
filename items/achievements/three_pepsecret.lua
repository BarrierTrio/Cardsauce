local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_pepsecret', num = 3},
    unlock_condition = function(self, args)
        return args.type == "three_pepsecret"
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????', self.config.num}}
end

return achInfo