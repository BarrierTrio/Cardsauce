local jokerInfo = {
	name = 'Speed Joker',
	atlas = 'jokers',
	pos = {x = 1, y = 7},
	config = {
		extra = {
			num_cards = 1,
			draw_this_hand = false
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = false,
	unlock_condition = {key = 'j_csau_sohappy'},
	blueprint_compat = false,
	eternal_compat = true,
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
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	return (G.P_CENTERS[self.unlock_condition.unlock_key] or {}).discovered
end

function jokerInfo.calculate(self, card, context)
	if context.before then
		card.ability.extra.draw_this_hand = true
	end

	if context.hand_drawn then
		card.ability.extra.draw_this_hand = false
	end

	if context.drawing_cards and card.ability.extra.draw_this_hand then
		return {
			modify = math.max(context.amount + card.ability.extra.num_cards, 2)
		}
	end
end

return jokerInfo
