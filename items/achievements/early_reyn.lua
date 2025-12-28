local achInfo = {
    rarity = 1,
    config = {joker = 'j_csau_reyn', ante = 1},
    unlock_condition = function(self, args)
        return args.type == "early_reyn"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.joker].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker} or '?????',
        self.config.ante
    }}
end

return achInfo