local jokerInfo = {
    name = "Scourge Of Pantsylvania",
    atlas = 'jokers',
	pos = {x = 8, y = 10},
    config = {},
    rarity = 2,
    cost = 5,
    unlocked = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlock_condition = {key = 'j_csau_frich'},
    origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'FenixSeraph'
}

function jokerInfo.check_for_unlock(self, args)
    return (G.P_CENTERS[self.unlock_condition.key] or {}).discovered
end

return jokerInfo