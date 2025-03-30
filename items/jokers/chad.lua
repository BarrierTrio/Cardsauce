local jokerInfo = {
	name = 'No No No No No No No No No No No',
	config = {
		extra = 2,
	},
	rarity = 1,
	cost = 0,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = { } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_chad" })
	ach_jokercheck(self, ach_checklists.ff7)
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	G.FUNCS.csau_generate_detail_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.calculate(self, card, context)
	if context.other_joker and not card.debuff and not context.blueprint then
		if (context.other_joker.config.center.name == ('No No No No No No No No No No No') or context.other_joker.ability.name == 'Hanging Chad' or context.other_joker.ability.name == 'Showman') and card ~= context.other_joker then
			check_for_unlock({ type = "chadley_power" })
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
            	Xmult_mod = card.ability.extra
			}
		end
	end
end

return jokerInfo