local jokerInfo = {
	name = 'Be Someone Forever',
	atlas = 'jokers',
	pos = {x = 7, y = 1},
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
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
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.calculate(self, card, context)
	if context.return_card_to_hand and context.scoring_name == 'High Card' and SMODS.in_scoring(context.card, context.scoring_hand) then
		return {
			return_card = true
		}
	end
end

return jokerInfo