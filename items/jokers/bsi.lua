local jokerInfo = {
    name = "Blue Shell Incident",
    config = {
        extra = {
            x_mult = 3,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
    streamer = "joel",
}


local function ace_tally()
    local tally = 0
    if not G.playing_cards then return tally end

    for _, v in ipairs(G.playing_cards) do
        if v:get_id() == 14 then tally = tally+1 end
    end

    return tally
end

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.greeky } }
    return { vars = {card.ability.extra.x_mult, ace_tally()} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers and ace_tally() == 0 then
        return {
            message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
            Xmult_mod = card.ability.extra.x_mult,
        }
    end
end

return jokerInfo