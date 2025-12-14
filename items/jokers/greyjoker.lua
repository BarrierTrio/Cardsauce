local jokerInfo = {
	name = 'Grey Joker',
	atlas = 'jokers',
	pos = {x = 0, y = 1},
	soul_pos = {x = 1, y = 1},
	config = {d_size = 3},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
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
	artist = 'SagaciousCejai'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.d_size} }
end

function jokerInfo.add_to_deck(self, card, from_discard)
	card_eval_status_text(card, 'extra', nil, nil, nil, {
		message = "+"..card.ability.d_size.." "..localize('k_hud_discards'),
		colour = G.C.RED
	})
end

return jokerInfo
