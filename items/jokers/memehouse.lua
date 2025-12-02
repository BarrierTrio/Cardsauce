local jokerInfo = {
    name = "Meme House",
    atlas = 'jokers',
	pos = {x = 4, y = 11},
    config = {
        activated = false
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pools = {
        ["Meme"] = true
    },
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'Joey'
}

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff and not context.individual and not context.repetition then
        local faces = 0
        for i = 1, #context.scoring_hand do
            if context.scoring_hand[i]:is_face() then faces = faces + 1 end
        end
        if faces >= 3 and next(context.poker_hands['Full House']) and to_big(#G.consumeables.cards + G.GAME.consumeable_buffer) < to_big(G.consumeables.config.card_limit) then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local card2 = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'memehouse')
                            card:add_to_deck()
                            G.consumeables:emplace(card2)
                            G.GAME.consumeable_buffer = 0
                            return true
                        end}))
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                    return true
                end)}))
        end
    end
end

return jokerInfo