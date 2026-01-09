local achInfo = {
    rarity = 1,
    hidden_text = true,
    config = {key = 'j_csau_mug'},
    unlock_condition = function(self, args)
        return args.type == "activate_mug"
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????'}}
end

return achInfo