local jokerInfo = {
    name = 'Business Trading Card',
    atlas = 'jokers',
	pos = {x = 6, y = 0},
    config = {
        extra = {
            dollars = 6,
            destroy = 1,
            chance = 3,
        },
    },
    rarity = 1,
    cost = 6,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Kekulism',
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'csau_business_1')
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
        if not context.blueprint and not context.retrigger_joker and SMODS.pseudorandom_probability(card, 'csau_business_1', 1, card.ability.extra.chance) then
            local idx_tbl = {}
            for i=1, #context.full_hand do
                idx_tbl[#idx_tbl+1] = i
            end

            while #idx_tbl > 1 and #idx_tbl > card.ability.extra.destroy do
                table.remove(idx_tbl, pseudorandom(pseudoseed('csau_business_2'), 1, #idx_tbl))
            end

            for _, v in pairs(idx_tbl) do
                context.full_hand[v].csau_removed_by_business = true
            end
        end

        return {
            dollars = card.ability.extra.dollars
        }
    end

    if context.blueprint then return end

    if context.destroy_card and context.destroy_card.csau_removed_by_business then
        return {
            remove = true
        }
    end
end

return jokerInfo