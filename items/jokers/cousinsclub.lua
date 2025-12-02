local jokerInfo = {
	name = "Cousin's Club",
	atlas = 'jokers',
	pos = {x = 4, y = 2},
	config = {
		extra = {
			suit = 'Clubs',
			chips = 0,
			chip_mod = 1,
			chip_mod_double = 2
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return {
		vars = {
			card.ability.extra.chips,
			card.ability.extra.chip_mod,
			localize(card.abiltiy.extra.suit, 'suits_singular'),
			colours = {
				G.C.SUITS[card.abiltiy.extra.suit]
			}
		}
	}
end

function jokerInfo.calculate(self, card, context)
	if context.debuff then return end

	if context.individual and context.cardarea == G.play and not context.blueprint and context.other_card:is_suit(card.abiltiy.extra.suit) then
		local has_flush = next(context.poker_hands['Flush'])
		SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "chips",
            scalar_value = "chip_mod"..(has_flush and '_double' or ''),
            scaling_message = {
                message = localize(has_flush and 'k_upgrade_double_ex' or 'k_upgrade_ex'),
                colour = G.C.CHIPS
            }
        })
	end

	if context.joker_main and to_big(card.ability.extra.chips) > to_big(0) then
		return {
			chips = card.ability.extra.chips
		}
	end
end



return jokerInfo
