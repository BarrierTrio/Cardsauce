local jokerInfo = {
    name = "That Fucking Koffing Again",
    config = {extra = {rerolled = false}},
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

-- TODO: implement koffing's reroll behavior using only contexts

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    info_queue[#info_queue+1] = {key = "codercredit", set = "Other", vars = { G.csau_team.myst } }
end

function jokerInfo.calculate(self, card, context)
    if context.ending_shop and not context.blueprint then
        card.ability.extra.rerolled = false
    end
end

return jokerInfo