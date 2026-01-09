local achInfo = {
    rarity = 1,
    config = {joker = 'j_csau_passport', val = 7},
    unlock_condition = function(self, args)
        if args.type ~= 'scale_card' or args.card.config.center.key ~= self.config.key then return end

        return args.value >= self.config.val
    end,
}

function achInfo.loc_vars(self)
    return { vars = {
        G.P_CENTERS[self.config.joker].discovered and localize{type = 'name_text', set = 'Joker', key = self.config.joker} or '????????',
        self.config.val
    }}
end

return achInfo