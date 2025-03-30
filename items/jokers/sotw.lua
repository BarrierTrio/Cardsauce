local jokerInfo = {
    name = "Stand of the Week",
    config = {
        extra = {
            x_mult = 1,
            x_mult_mod = 0.25
        },
    },
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = {card.ability.extra.x_mult_mod, card.ability.extra.x_mult} }
end

function jokerInfo.calculate(self, card, context)
    if card.ability.extra.x_mult > 1 and context.joker_main and context.cardarea == G.jokers then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
            Xmult_mod = card.ability.extra.x_mult,
        }
    end
end

function jokerInfo.update(self, card, dt)
    local stands_obtained = 0
    for k, v in pairs(G.GAME.consumeable_usage) do if v.set == 'Stand' then stands_obtained = stands_obtained + 1 end end
    card.ability.extra.x_mult = 1 + (card.ability.extra.x_mult_mod*stands_obtained)
end

return jokerInfo


