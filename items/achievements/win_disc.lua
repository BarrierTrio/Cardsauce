local achInfo = {
    rarity = 3,
    config = {key = 'b_jojobal_stone_disc'},
    unlock_condition = function(self, args)
        return args.type == 'win_deck' and G.GAME.selected_back.effect.center.key == self.config.key
    end,
}

function achInfo.loc_vars(self)
    return { vars = { G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Back', key = self.config.key} or '????????'}}
end

return achInfo