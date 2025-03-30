local jokerInfo = {
    name = "Bald Joker",
    config = {
        extra = 3,
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
    return { vars = { card.ability.extra } }
end

function jokerInfo.calculate(self, card, context)
    if context.pre_discard and #context.full_hand >= 5 then
        local non_face_count = 0
        for i, v in ipairs(context.full_hand) do
            if not v:is_face() then non_face_count = non_face_count + 1 end
        end
        if non_face_count >= 5 then
            local mod = math.floor(non_face_count / 5)
            local dollars = card.ability.extra*mod
            return {
                dollars = to_big(dollars),
                colour = G.C.MONEY,
                card = card
            }
        end
    end
end

return jokerInfo