local achInfo = {
    rarity = 3,
    config = {key = 'j_csau_veryexpensivejoker', dollars = 60},
    unlock_condition = function(self, args)
        return args.type == "purchase_dink" and args.dollars >= self.config.dollars
    end,
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
            self.config.dollars
        }
    }
end

return achInfo