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

function deckInfo.loc_vars(self, info_queue, card)
    return {vars = {localize{type = 'name_text', key = 'v_overstock_norm', set = 'Voucher'}}}
end

function deckInfo.apply(self, back)
    G.GAME.starting_params.csau_jokers_rate = (G.GAME.starting_params.csau_jokers_rate or 1) * 2
end

return deckInfo