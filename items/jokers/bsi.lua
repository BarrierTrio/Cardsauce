local jokerInfo = {
    name = "Blue Shell Incident",
    atlas = 'jokers',
	pos = {x = 1, y = 12},
    config = {
        extra = {
            rank_id = 14,
            x_mult = 3,
        },
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    has_shiny = true,
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
    artist = 'greek_shmeek'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.x_mult, ArrowAPI.game.get_rank_tally(card.ability.extra.rank_id)} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main then
        local ace_tally = ArrowAPI.game.get_rank_tally(card.ability.extra.rank_id)

        if ace_tally == 0 then
            return {
                x_mult = card.ability.extra.x_mult,
            }
        end

    end
end

return jokerInfo