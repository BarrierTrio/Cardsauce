local jokerInfo = {
    name = "Scourge Of Pantsylvania",
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlock_condition = {key = 'j_csau_frich'},
    streamer = "vinny",
    artist = 'FenixSeraph'
}

function jokerInfo.check_for_unlock(self, args)
    return (G.P_CENTERS[self.unlock_condition.key] or {}).discovered
end

return jokerInfo