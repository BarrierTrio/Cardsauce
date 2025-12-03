local jokerInfo = {
    name = "That Fucking Koffing Again",
    atlas = 'jokers',
	pos = {x = 1, y = 9},
    config = {extra = {rerolled = false}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'BarrierTrio/Gote',
    programmer = 'Mysthaps'
}

function jokerInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.koffing_rerolls = G.GAME.current_round.koffing_rerolls + 1
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

    G.GAME.current_round.koffing_rerolls = G.GAME.current_round.koffing_rerolls - 1
end

return jokerInfo