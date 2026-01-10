local achInfo = {
    rarity = 2,
    config = {key = 'j_csau_roche'},
    unlock_condition = function(self, args)
        return args.type == "activate_roche"
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????'}}
end

return achInfo