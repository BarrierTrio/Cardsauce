local jokerInfo = {
    name = '10 ARROWS!?!?',
    config = {
        extra = {
            mult = 0,
            mult_mod = 10
        }
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "guestartist20", set = "Other"}
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult }}
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_ten" })
end

function jokerInfo.calculate(self, card, context)
    if context.using_consumeable and not G.shop then
        card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
    end
    if context.joker_main and context.cardarea == G.jokers and not card.debuff then
        if card.ability.extra.mult > 0 then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
            }
        end
    end
    if context.end_of_round and not context.blueprint and card.ability.extra.mult > 0 then
        card.ability.extra.mult = 0
        return {
            message = localize('k_reset'),
            colour = G.C.RED
        }
    end
end

return jokerInfo