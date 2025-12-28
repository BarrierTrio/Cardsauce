local jokerInfo = {
	name = 'PAC-MAN Incident',
	atlas = 'jokers',
	pos = {x = 6, y = 1},
	config = {
		extra = {
			mult = 0,
			mult_mod = 5
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
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
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.end_of_round and context.main_eval and not context.blueprint
	and to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 1.1) then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "mult",
				scalar_value = "mult_mod",
				message_colour = G.C.MULT
			})
	end

	if context.joker_main and to_big(card.ability.extra.mult) > to_big(0) then
		return {
			mult = card.ability.extra.mult,
		}
	end
end

return jokerInfo
