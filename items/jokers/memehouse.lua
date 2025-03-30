local jokerInfo = {
    name = "Meme House",
    config = {
        activated = false
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.joey } }
    return { vars = { } }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main then
        if next(context.poker_hands['Full House']) then
            card.ability.activated = true
        else
            card.ability.activated = false
        end
    end
    if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
        if G.GAME.chips <= G.GAME.blind.chips then
            if card.ability.activated and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'memehouse')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))
                        card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                        return true
                    end)}))
            end
        end
        card.ability.activated = false
    end
end

return jokerInfo