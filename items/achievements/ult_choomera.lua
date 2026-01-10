local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_csau_chromedup', key_2 = 'j_csau_maskedjoker', num = 5},
    unlock_condition = function(self, args)
        return args.type == "ult_choomera"
    end,
}

function achInfo.loc_vars(self)
    return {
        vars = {
            self.config.num,
            G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
            G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????'
        }
    }
end

return achInfo