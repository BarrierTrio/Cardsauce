local deckInfo = {
    name = 'Vine Deck',
    unlocked = false,
    discovered = false,
    config = {
        vouchers = {
            'v_overstock_norm',
        },
    },
    unlock_condition = {type = 'win_deck', deck = 'b_green'},
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Kekulism',
}

deckInfo.loc_vars = function(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
end

deckInfo.apply = function(self, back)
    G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate or 1
            G.GAME.starting_params.csau_jokers_rate = G.GAME.starting_params.csau_jokers_rate * 2
            return true
        end
    }))
end

return deckInfo