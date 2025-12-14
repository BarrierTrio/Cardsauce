local jokerInfo = {
	name = "Don't Mind If I Do",
	atlas = 'jokers',
	pos = {x = 9, y = 3},
	soul_pos = {x = 0, y = 4},
	config = {},
	rarity = 2,
	cost = 4,
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
	artist = 'Gappie',
}

function jokerInfo.calculate(self, card, context)
	if context.modify_level_increment and context.hand == "High Card" then
		return {
			message = localize("k_dontmind"),
			colour = G.C.SECONDARY_SET.Planet,
			mult_inc = 2,
		}
	end
end

return jokerInfo