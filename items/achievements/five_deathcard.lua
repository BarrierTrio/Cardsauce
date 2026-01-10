local achInfo = {
    rarity = 3,
    config = {key = 'j_csau_veryexpensivejoker', num = 5},
    unlock_condition = function(self, args)
        return args.type == "deathcard" and args.num >= self.config.num
    end,
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
            self.config.num
        }
    }
end
return achInfo