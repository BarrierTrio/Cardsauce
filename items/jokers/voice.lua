local jokerInfo = {
    name = "Choicest Voice",
    atlas = 'jokers',
	pos = {x = 5, y = 8},
    config = {
        extra = {
            repetitions = 1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'cardsauce',
    artist = 'Akai (Balatrostuck)'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local choicevoice = G.GAME.current_round.choicevoice or { suit = G.GAME.wigsaw_suit or 'Clubs', rank = 'Ace', id = 14 }
    return { vars = {
        localize(choicevoice.rank, 'ranks'),
        localize(choicevoice.suit, 'suits_plural'),
        colours = {
            G.C.SUITS[choicevoice.suit]
        }
    }}
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end
    if context.cardarea == G.play and context.repetition then
        for _, v in ipairs(context.full_hand) do
            if v:get_id() == G.GAME.current_round.choicevoice.id and v:is_suit(G.GAME.current_round.choicevoice.suit) then
                check_for_unlock({ type = "activate_voice" })
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.repetitions,
                    card = context.blueprint_card or card
                }
            end
        end
    end
end

return jokerInfo