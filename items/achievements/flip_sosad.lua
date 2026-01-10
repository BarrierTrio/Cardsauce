local achInfo = {
    rarity = 2,
    config = {key_1 = 'j_csau_sohappy', key_2 = 'j_csau_sosad'},
    unlock_condition = function(self, args)
        return args.type == "flip_sosad"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????',
    }}
end

return achInfo