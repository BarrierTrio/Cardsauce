local achInfo = {
    rarity = 2,
    config = {key = 'c_csau_spec_quixotic'},
    unlock_condition = function(self, args)
        return args.type == "activate_quixotic"
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Spectral', key = self.config.key} or '????????'}}
end

return achInfo