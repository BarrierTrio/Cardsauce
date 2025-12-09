local jokerInfo = {
	name = 'Diaper Joker',
	atlas = 'jokers',
	pos = {x = 2, y = 1},
	config = {
		extra = {
			mult = 0,
			mult_mod = 2,
			tally = 0
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
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "diapernote", set = "Other"}
	return { vars = {ArrowAPI.game.get_rank_tally(card.ability.extra.rank_id) * card.ability.extra.mult_mod, card.ability.extra.mult_mod} }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and not card.debuff then
		local tally = ArrowAPI.game.get_rank_tally(2)
		if tally > 0 then
			return {
				mult = tally * card.ability.extra.mult_mod,
				card = card
			}
		end
	end
end

return jokerInfo