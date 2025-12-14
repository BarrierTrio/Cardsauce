local jokerInfo = {
    name = 'Kerosene',
    atlas = 'jokers',
	pos = {x = 1, y = 4},
    config = {
        extra = {
            chips = 0,
            chip_mod = 20,
            flame = false,
        }
    },
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = {
		category = "cardsauce",
		sub_origins = {
			"redvox",
		},
		custom_color = "redvox",
	},
    dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
    artist = 'WhimsyCherry'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod} }
end

function jokerInfo.calculate(self, card, context)
    if card.debuff then return end

    if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
        return {
            message = localize{type='variable',key='a_chips',vars={to_big(card.ability.extra.chips)}},
            chip_mod = card.ability.extra.chips,
            colour = G.C.CHIPS
        }
    end

    if context.after and hand_chips*mult > G.GAME.blind.chips then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_value = "chip_mod",
            scaling_message = {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        })
    end
end

return jokerInfo