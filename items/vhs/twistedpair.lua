local consumInfo = {
    name = 'Twisted Pair',
    set = "VHS",
    runtime = 2,
    cost = 3,
    alerted = true,
    config = {},
    artist = 'FenixSeraph'
}

function consumInfo.calculate(self, card, context)
    if card.debuff then return end

    if card.ability.activated and context.before then
        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end

        G.E_MANAGER:add_event(Event({
            func = function()
                local _card = copy_card(context.scoring_hand[1])
                _card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                G.hand:emplace(_card)
                table.insert(G.playing_cards, _card)
                playing_card_joker_effects({_card})
                card:juice_up()
                return true
            end
        }))
    end
end

return consumInfo