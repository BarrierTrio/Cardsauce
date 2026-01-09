local achInfo = {
    rarity = 1,
    config = {key = 'j_csau_grannycream'},
    unlock_condition = function(self, args)
        return args.type == "card_expire" and args.card.center.key == self.config.key
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.key].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.key} or '????????',
    }}
end
return achInfo