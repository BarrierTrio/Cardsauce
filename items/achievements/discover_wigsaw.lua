local achInfo = {
    rarity = 3,
    config = {unlock_key = 'j_csau_wigsaw'},
    unlock_condition = function(self, args)
        return (G.P_CENTERS[self.config.unlock_key] or {}).discovered
    end,
}

return achInfo