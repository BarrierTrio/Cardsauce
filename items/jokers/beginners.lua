local jokerInfo = {
    name = "Beginner's Luck",
    config = {
        prob_mult = 3,
        disabled = false
    },
    rarity = 2,
    cost = 4,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = { } }
end

function jokerInfo.in_pool(self, args)
    if G.GAME.round_resets.ante <= 4 then
        return true
    end
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_beginners" })
    for k, v in pairs(G.GAME.probabilities) do
        G.GAME.probabilities[k] = v * card.ability.prob_mult
    end
end

function jokerInfo.remove_from_deck(self, card)
    if not card.ability.disabled then
        for k, v in pairs(G.GAME.probabilities) do
            G.GAME.probabilities[k] = v / card.ability.prob_mult
        end
    end
end

function jokerInfo.calculate(self, card, context)
    if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
        if G.GAME.round_resets.ante >= 4 and G.GAME.blind.boss then
            for k, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[k] = v / card.ability.prob_mult
            end
            card.ability.disabled = true
            return {
                message = localize('k_noluck_ex'),
                colour = G.C.MONEY
            }
        end
    end
end

function jokerInfo.update(self, card)
    if card.ability.disabled and not card.debuff then
        card.debuff = true
    end
end

return jokerInfo