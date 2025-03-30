local jokerInfo = {
    name = 'The Purple Joker',
    config = {
        tarot = 2
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.sine } }
    return {vars = { card.ability.tarot, localize(G.GAME and G.GAME.wigsaw_suit or "Spades", 'suits_plural'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or "Spades"]} } }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_purple" })
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff and to_big(G.GAME.current_round.hands_played) == to_big(0) and next(context.poker_hands['Flush']) then
        local purp = G.FUNCS.csau_all_suit(context.full_hand, G.GAME and G.GAME.wigsaw_suit or "Spades")
        if purp then
            for i = 1, math.min(card.ability.tarot, G.consumeables.config.card_limit - #G.consumeables.cards) do
                G.E_MANAGER:add_event(Event({func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local _card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'imthepurpleone')
                        _card:add_to_deck()
                        G.consumeables:emplace(_card)
                        card:juice_up(0.3, 0.5)
                    end
                    return true end }))
            end
        end
    end
end

return jokerInfo
