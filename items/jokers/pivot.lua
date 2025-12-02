local jokerInfo = {
	name = 'Pivyot Joker',
	atlas = 'jokers',
	pos = {x = 2, y = 0},
	config = {
		extra = {
			chance = 3
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}


function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'csau_pivyot')} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.cardarea == G.jokers and context.before and context.scoring_name == "High Card"
	and	SMODS.pseudorandom_probability(card, 'csau_pivyot', 1, card.ability.extra.chance) then
		return {
			card = card,
			level_up = true,
			message = localize('k_level_up_ex')
		}
	end
end

return jokerInfo
