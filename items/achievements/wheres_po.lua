local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_csau_purple', key_2 = 'c_csau_rawtime'},
    unlock_condition = function(self, args)
        return args.type == "wheres_po"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'VHS', key = self.config.key_2} or '????????',
    }}
end
return achInfo