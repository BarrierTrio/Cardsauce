local jokerInfo = {
	name = 'Fisheye',
	atlas = 'jokers',
	pos = {x = 2, y = 3},
	config = {
		extra = {
			chips = 15
		}
	},
	rarity = 1,
	cost = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
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
	return { vars = {card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main then
		return {
			chips = card.ability.extra.chips,
		}
	end
end


return jokerInfo
