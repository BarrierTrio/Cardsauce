local jokerInfo = {
    name = "EAT IT",
    atlas = 'jokers',
	pos = {x = 8, y = 11},
    config = {
        extra = {
            chips = 0,
            chips_mod = 50,
            x_mult = 1,
            x_mult_mod = 0.5,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'HunnyByte'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips_mod, card.ability.extra.x_mult_mod, card.ability.extra.chips, card.ability.extra.x_mult} }
end

function jokerInfo.calculate(self, card, context)
    if (to_big(card.ability.extra.chips) > to_big(0) or to_big(card.ability.extra.x_mult) > to_big(1)) and context.joker_main and context.cardarea == G.jokers then
        return {
            chips = card.ability.extra.chips,
            Xmult = card.ability.extra.x_mult,
        }
    end
end

function jokerInfo.update(self, card, dt)
    if not G.jokers then return end
    local food = 0
    for k, v in pairs(G.jokers.cards) do
        if ArrowAPI.table.contains(G.P_CENTER_POOLS.Food, v.config.center) then
            food = food + 1
        end
    end
    card.ability.extra.chips = card.ability.extra.chips_mod * food
    card.ability.extra.x_mult = 1 + (card.ability.extra.x_mult_mod * food)
end

return jokerInfo