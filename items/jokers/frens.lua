local jokerInfo = {
    name = "Frens",
    atlas = 'jokers',
	pos = {x = 3, y = 11},
    config = {
        extra = {
            chips_mod = 5,
        },
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
    local faces = 0
    if G.playing_cards then
        for k, v in pairs(G.playing_cards) do
            if v:is_face() then faces = faces+1 end
        end
    end
    return { vars = {card.ability.extra.chips_mod, card.ability.extra.chips_mod * faces} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        if not G.playing_cards then return end
        local faces = 0
        for k, v in pairs(G.playing_cards) do
            if v:is_face() then faces = faces+1 end
        end
        local chips = card.ability.extra.chips_mod * faces
        if to_big(chips) > to_big(0) then
            return {
                message = localize{type='variable',key='a_chips',vars={to_big(chips)}},
                chip_mod = chips,
                colour = G.C.CHIPS
            }
        end
    end
end

return jokerInfo