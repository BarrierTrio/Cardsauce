local achInfo = {
    rarity = 1,
    config = {key_1 = 'j_csau_frich', key_2 = 'j_cavendish' },
    unlock_condition = function(self, args)
        if args.type == "frich_cavendish" then
            return true
        end
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key_2} or '????????',
    }}
end

return achInfo