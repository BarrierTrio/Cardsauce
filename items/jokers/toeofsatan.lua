local jokerInfo = {
    name = 'Toe of Satan',
    atlas = 'jokers',
	pos = {x = 7, y = 9},
    config = {
        extra = {
            discards = 3,
            discards_mod = 1
        }
    },
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    has_shiny = true,
    pools = { ["Food"] = true },
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
    artist = 'PaperMoon'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return {vars = { card.ability.extra.discards, card.ability.extra.discards_mod } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.setting_blind then
        ease_discard(card.ability.extra.discards)
        return {
            message = localize{type = 'variable', key = 'a_plus_discard', vars = {card.ability.extra.discards}},
            colour = G.C.RED,
            card = context.blueprint_card or card
        }
    end

    if context.blueprint then return end

    if context.end_of_round and context.main_eval and SMODS.food_expires(card) then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "discards",
            scalar_value = "discards_mod",
            operation = '-',
            no_message = true,
        })

        if to_big(card.ability.extra.discards) > to_big(0) then
            return {
                message = "-"..card.ability.extra.discards_mod,
                colour = G.C.RED
            }
        else
            ArrowAPI.game.card_expire(card)
        end
    end
end

return jokerInfo