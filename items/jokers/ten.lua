local jokerInfo = {
    name = '10 ARROWS!?!?',
    atlas = 'jokers',
	pos = {x = 5, y = 7},
    config = {
        extra = {
            mult = 0,
            mult_mod = 10
        }
    },
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    has_shiny = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'Swizik'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult }}
end

function jokerInfo.calculate(self, card, context)
    if (context.using_consumeable or context.vhs_death) and not G.shop and not card.debuff then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "mult",
            scalar_value = "mult_mod",
            scaling_message = {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT
            }
        })
    end

    if context.joker_main and not card.debuff and to_big(card.ability.extra.mult) > to_big(0) then
        return {
            mult = card.ability.extra.mult,
        }
    end

    if context.blueprint then return end

    if context.end_of_round and context.main_eval and to_big(card.ability.extra.mult) > to_big(0) then
        card.ability.extra.mult = 0
        return {
            message = localize('k_reset'),
            colour = G.C.RED
        }
    end
end

return jokerInfo