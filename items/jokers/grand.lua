local jokerInfo = {
    name = "7 Funny Story",
    config = {
        extra = {
            chance = 7,
            cardid = 7,
            x_mult = 7,
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    pools = {
        ["Meme"] = true
    },
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.akai } }
    return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance), card.ability.extra.x_mult, card.ability.extra.cardid} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.cardarea == G.jokers and context.joker_main then
        local trigger = false
        for _, v in ipairs(context.full_hand) do
            if v:get_id() == 7 then
                trigger = true
                break;
            end
        end

        if trigger and SMODS.pseudorandom_probability(card, pseudoseed('csau_grand'), 1, card.ability.extra.chance) then
            return {
                message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
                Xmult_mod = card.ability.extra.x_mult,
            }
        end
    end
end

return jokerInfo