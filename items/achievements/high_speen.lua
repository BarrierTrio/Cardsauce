local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_csau_speen', key_2 = 'c_wheel_of_fortune'},
    unlock_condition = function(self, args)
        return args.type == "high_speen"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Tarot', key = self.config.key_2} or '????????',
    }}
end

return achInfo