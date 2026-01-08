local jokerInfo = {
	name = 'Depressed Brother',
	atlas = 'jokers',
	pos = {x = 7, y = 0},
	config = {
		extra = {
			mult_mod = 2,
		}
	},
	rarity = 2,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
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
	artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult_mod } }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or not context.before then return end

	for _, v in ipairs(context.full_hand) do
		if not SMODS.in_scoring(v, context.scoring_hand) then
			v.ability.perma_mult = (v.ability.perma_mult or 0) + card.ability.extra.mult_mod
			card_eval_status_text(v, 'extra', nil, nil, nil, {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				func = function()
					card:juice_up()
				end
			})
		end
	end
end

return jokerInfo
