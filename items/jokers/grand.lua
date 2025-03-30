local jokerInfo = {
    name = "7 Funny Story",
    config = {
        rate = 7,
        cardid = 7,
        extra = {
            x_mult = 7,
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.akai } }
    return { vars = {G.GAME.probabilities.normal, card.ability.rate, card.ability.extra.x_mult, card.ability.cardid} }
end

function jokerInfo.add_to_deck(self, card)
    check_for_unlock({ type = "discover_grand" })
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and not context.before and context.joker_main and not context.repetition then
        local trigger = false
        for k, v in ipairs(context.full_hand) do
            if not table.contains(context.scoring_hand, v) then
                if v:get_id() == 7 then
                    trigger = true
                end
            end
        end
        if trigger then
            if pseudorandom('fleentstones') < G.GAME.probabilities.normal / card.ability.rate then
                return {
                    message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
                    Xmult_mod = card.ability.extra.x_mult,
                }
            end
        end
    end
end

return jokerInfo