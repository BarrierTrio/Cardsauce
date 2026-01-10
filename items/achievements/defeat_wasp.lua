local achInfo = {
    rarity = 2,
    config = {key = 'bl_csau_wasp'},
    unlock_condition = function(self, args)
        return args.type == "blind_defeated" and args.blind.config.blind.key == self.config.key
    end,
}

function achInfo.loc_vars(self)
    return {
        vars = {
            G.P_BLINDS[self.config.key].discovered and localize{type = 'name_text', set = 'Blind', key = self.config.key} or '????????',
            colours = {
                G.P_BLINDS[self.config.key].boss_colour
            }
        }
    }
end

return achInfo