local consumInfo = {
    name = 'Star Platinum',
    set = "Stand",
    cost = 4,
    config = {
    },
    alerted = true,
    hasSoul = true,
}

function consumInfo.add_to_deck(self, card)
    set_consumeable_usage(card)
end

function consumInfo.calculate(self, card, context)
    if context.before and not card.debuff and G.GAME.current_round.hands_played == 0 then
        local diamonds = G.FUNCS.csau_all_suit(context, "Diamonds")
        if diamonds then
            ease_hands_played(1)
            return {
                card = card,
                message = localize('k_plus_hand'),
                colour = G.C.BLUE
            }
        end
    end
end

function consumInfo.can_use(self, card)
    return false
end

return consumInfo