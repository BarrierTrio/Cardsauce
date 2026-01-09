local achInfo = {
    rarity = 3,
    unlock_key = 'j_csau_vincenzo',
    unlock_condition = function(self, args)
        return (G.P_CENTERS[self.unlock_key] or {}).discovered
    end,
}

return achInfo