local jokerInfo = {
    name = "7 Funny Story",
    atlas = 'jokers',
	pos = {x = 4, y = 7},
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
    artist = 'Akai (Balatrostuck)'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local num, dom = SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'csau_grand')
    return { vars = {num, dom, card.ability.extra.x_mult, card.ability.extra.cardid} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main then
        local trigger = false
        for _, v in ipairs(context.full_hand) do
            if v:get_id() == 7 then
                trigger = true
                break
            end
        end

        if trigger and SMODS.pseudorandom_probability(card, 'csau_grand', 1, card.ability.extra.chance) then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end
end

return jokerInfo