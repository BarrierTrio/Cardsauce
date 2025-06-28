local jokerInfo = {
    name = 'Business Trading Card',
    config = {
        extra = {
            dollars = 6,
            destroy = 1,
            chance = 3,
            destroyed = {},
        },
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.keku } }
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance)
    return { vars = {card.ability.extra.dollars, num, dom, card.ability.extra.destroy} }
end

local function all_faces(hand)
    for k, v in ipairs(hand) do
        if not v:is_face() then
            return false
        end
    end
    return true
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.before and context.cardarea == G.jokers and to_big(G.GAME.current_round.hands_played) == to_big(0) and all_faces(context.full_hand) then
        card.ability.csau_business_activated = {}
        if SMODS.pseudorandom_probability(card, pseudoseed('csau_business_1'), 1, card.ability.extra.chance) then
            local idx_tbl = {}
            for i=1, #context.full_hand do
                idx_tbl[#idx_tbl+1] = i
            end

            while #idx_tbl > 1 and #idx_tbl > card.ability.extra.destroy do
                table.remove(idx_tbl, pseudorandom(pseudoseed('csau_business_2'), 1, #idx_tbl))
            end

            for _, v in pairs(idx_tbl) do
                card.ability.csau_business_activated[context.full_hand[v]] = true
            end
        end

        
        return {
            dollars = card.ability.extra.dollars
        }
    end

    if context.blueprint then return end

    if context.destroy_card and card.ability.csau_business_activated[context.destroy_card] then
        return {
            remove = true
        }
    end

    if context.end_of_round and not context.individual and not context.repetition then
        card.ability.csau_business_activated = nil
    end
end

return jokerInfo