local achInfo = {
    rarity = 2,
    config = {key_1 = 'c_jojobal_stone_white_moon', key_2 = 'c_jojobal_stone_white_heaven'},
    unlock_condition = function(self, args)
        return args.type == "evolve_stand" and args.old_key == self.config.key_1 and args.new_key == self.config.key_2
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key_1].discovered and localize{type = 'name_text', set = 'Stand', key = self.config.key_1} or '????????',
        G.P_CENTERS[self.config.key_2].discovered and localize{type = 'name_text', set = 'Stand', key = self.config.key_2} or '????????',
    }}
end

return achInfo