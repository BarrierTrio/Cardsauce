local achInfo = {
    rarity = 3,
    config = {key = 'j_csau_quarterdumb'},
    hidden_text = true,
    unlock_condition = function(self, args)
        return (G.P_CENTERS[self.config.unlock_key] or {}).discovered
    end,
}

return achInfo