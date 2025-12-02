local jokerInfo = {
    name = "Couple's Joker",
    atlas = 'jokers',
	pos = {x = 0, y = 11},
    config = {
        extra = 1,
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
    artist = 'MightyKingWario'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, (G.GAME and G.GAME.hands and G.GAME.hands.Pair.played*card.ability.extra) or 0} }
end

function jokerInfo.calculate(self, card, context)
    if to_big(G.GAME.hands.Pair.played) > to_big(0) and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = G.GAME.hands.Pair.played*card.ability.extra,
        }
    end
end

return jokerInfo