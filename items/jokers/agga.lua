local jokerInfo = {
    name = "AGGA",
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.2,
            prob = 10,
        }
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cejai } }
    return { vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_mod, card.ability.extra.prob} }
end

function jokerInfo.calculate(self, card, context)
    if context.repetition and not (context.end_of_round or context.blueprint) then
        if card.ability.extra.x_mult > 1 and pseudorandom('agga') < G.GAME.probabilities.normal / card.ability.extra.prob then
            card.ability.extra.x_mult = to_big(1)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset'), colour = G.C.IMPORTANT})
        else
            card.ability.extra.x_mult = to_big(card.ability.extra.x_mult) + to_big(card.ability.extra.x_mult_mod)
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {to_big(card.ability.extra.x_mult)}}, colour = G.C.IMPORTANT})
        end
    end
    if context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
            Xmult_mod = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo