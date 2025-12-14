local jokerInfo = {
    name = "Mr. Kill",
    atlas = 'jokers',
	pos = {x = 7, y = 11},
    config = {
        extra = {
            chips = 0,
        },
    },
    rarity = 2,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
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
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.first_hand_drawn then
        local eval = function() return to_big(G.GAME.current_round.discards_used) == to_big(0) and not G.RESET_JIGGLES end
        juice_card_until(card, eval, true)
    end

    if context.pre_discard and to_big(G.GAME.current_round.discards_used) <= to_big(0) and #context.full_hand == 1 and not context.blueprint then
        local destroy = context.full_hand[1]
        local rank = SMODS.Ranks[destroy.base.value]
        local scale_table = {chip_mod = (SMODS.has_no_rank(destroy) and 0 or rank.nominal) + destroy.ability.bonus + (destroy.ability.perma_bonus or 0)}

        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_table = scale_table,
            scalar_value = "chip_mod",
            message_key = 'a_chips',
            message_colour = G.C.CHIPS
        })
    end

    if to_big(card.ability.extra.chips) > to_big(0) and context.joker_main then
        return {
            chips = card.ability.extra.chips,
        }
    end
end

return jokerInfo