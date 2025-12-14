local jokerInfo = {
	name = 'Garbage Hand',
	atlas = 'jokers',
	pos = {x = 4, y = 3},
	config = {
		extra = {
			mult = 4
		}
	},
	rarity = 1,
	cost = 4,
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
	artist = 'Global-Trance'
}


function jokerInfo.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.mult}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.individual and context.cardarea == G.play
	and to_big(context.other_card.base.nominal) <= to_big(8)
	and not next(SMODS.get_enhancements(context.other_card)) then
		return {
			mult = card.ability.extra.mult,
			card = card
		}
	end
end



return jokerInfo
