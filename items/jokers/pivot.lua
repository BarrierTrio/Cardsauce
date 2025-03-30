local jokerInfo = {
	name = 'Pivyot',
	config = {},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}


function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {G.GAME.probabilities.normal} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_pivot" })
	ach_jokercheck(self, ach_checklists.high)
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not self.debuff then
		if context.scoring_name == "High Card" then
			if pseudorandom('pivot') < G.GAME.probabilities.normal / 3 then
				return {
					card = card,
					level_up = true,
					message = localize('k_level_up_ex')
				}
			end
		end
	end
end



return jokerInfo
	