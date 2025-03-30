local jokerInfo = {
    name = 'BITCONNEEEEEEEEEEEEEEEEE',
    config = {
        extra = 5,
        scam_hands = {
            "High Card",
            "Pair",
            "Two Pair",
        }
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.plunch } }
    return { vars = { card.ability.extra } }
end

local function validHand(card, context)
    if not context.scoring_name then return false end
    for i, v in ipairs(card.ability.scam_hands) do
        if context.scoring_name == v then
            return true
        end
    end
    return false
end

function jokerInfo.calculate(self, card, context)
    if context.cardarea == G.jokers and context.before and not card.debuff then
        local money = card.ability.extra
        if validHand(card, context) then
            money = -money
        end
        return {
            dollars = money
        }
    end
end

return jokerInfo