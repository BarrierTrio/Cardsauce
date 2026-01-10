local achInfo = {
    rarity = 2,
    config = {key = 'j_csau_miracle'},
    unlock_condition = function(self, args)
        return args.type == "miracle_inherit"
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
    }}
end

return achInfo