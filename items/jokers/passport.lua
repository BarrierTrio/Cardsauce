local jokerInfo = {
    name = "Passport",
    atlas = 'jokers',
	pos = {x = 7, y = 13},
    config = {
        extra = {
            x_mult_mod = 0.75,
            x_mult = 0,
        },
    },
    rarity = 2,
    cost = 6,
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
    artist = 'SoloDimeKuro'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.x_mult_mod, card.ability.extra.x_mult_mod } }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.buying_card and not context.blueprint and context.card.ability.set == "Voucher" then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "x_mult",
            scalar_value = "x_mult_mod",
            message_key = 'a_xmult',
            message_colour = G.C.MULT
        })
    end

    if context.joker_main and card.ability.extra.x_mult > 0 then
        return {
            x_mult = 1 + card.ability.extra.x_mult,
        }
    end
end

return jokerInfo