local achInfo = {
    rarity = 3,
    config = {key = 'j_csau_wigsaw'},
    unlock_condition = function(self, args)
        if args.type ~= 'discover_amount' then return false end

        return (G.P_CENTERS[self.config.key] or {}).discovered
    end,
}

function achInfo.loc_vars(self)
    return {vars = {
        localize{type = 'name_text', set = 'Joker', key = self.config.key},
    }}
end

return achInfo