local jokerInfo = {
    name = "Scourge Of Pantsylvania",
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlock_key = 'j_csau_frich',
    streamer = "vinny",
    artist = 'FenixSeraph'
}

function jokerInfo.check_for_unlock(self, args)
    return G.FUNCS.discovery_check({ mode = 'key', key = self.unlock_key })
end

return jokerInfo