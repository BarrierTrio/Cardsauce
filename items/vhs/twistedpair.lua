local consumInfo = {
    name = 'Twisted Pair',
    atlas = 'vhs',
	pos = {x = 0, y = 2},
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
        local new_copy = copy_card(context.scoring_hand[1])
        new_copy:start_materialize({G.C.SECONDARY_SET.Enhanced})
        G.hand:emplace(new_copy)
        table.insert(G.playing_cards, new_copy)
        new_copy.states.visible = nil

        G.E_MANAGER:add_event(Event({
            func = function()
                new_copy:start_materialize()
                card:juice_up()
                return true
            end
        }))

        if not context.blueprint then
            ArrowAPI.vhs.run_tape(card)
        end
    end
end

return consumInfo