local jokerInfo = {
    name = "WE'RE TRULY FRAUDS!",
    atlas = 'jokers',
	pos = {x = 6, y = 14},
    config = {},
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    dependencies = {
        config = {
            ['VinnyContent'] = true,
            ['VHSs'] = true
        }
    },
    origin = {
        category = 'rlm',
        sub_origins = {'rlm_wotw'},
        custom_color = 'rlm'
    },
    artist = 'Lyzerus'
}

function jokerInfo.add_to_deck(self, card)
    ArrowAPI.game.refresh_costs()
end

function jokerInfo.remove_from_deck(self, card)
    ArrowAPI.game.refresh_costs()
end

return jokerInfo
