local jokerInfo = {
    name = "No. 2 Joker",
    config = {
        extra = 1,
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "otherjoel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cejai } }
end

function jokerInfo.calculate(self, card, context)
    if context.retrigger_joker_check and context.other_card ~= card then
        if context.other_card.ability.set == "Stand" then
            return {
                repetitions = card.ability.extra,
                card = context.other_card,
                juice_card = card,
            }
        end
    end
end

return jokerInfo