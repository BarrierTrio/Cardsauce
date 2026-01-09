local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_joeycastle', val = 5},
    unlock_condition = function(self, args)
        return args.type == "high_joeyscastle"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
        self.config.val,
    }}
end

return achInfo