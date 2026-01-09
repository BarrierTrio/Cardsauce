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
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'MightyKingWario'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra, (G.GAME.hands['Pair'].played*card.ability.extra)} }
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and G.GAME.hands['Pair'].played > 0 then
        local mult = G.GAME.hands['Pair'].played * card.ability.extra
        check_for_unlock({type = 'scale_card', card = card, ref_table = {mult = mult}, ref_value = 'mult'})
        return {
            mult = mult,
        }
    end
end

return jokerInfo