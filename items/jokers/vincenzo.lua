local jokerInfo = {
	name = 'Vincenzo',
	atlas = 'jokers',
	pos = {x = 5, y = 5},
	soul_pos = {x = 6, y = 5},
	config = {},
	rarity = 4,
	cost = 20,
	unlocked = false,
	unlock_condition = {type = '', extra = '', hidden = true},
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = "redvox",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_negative
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	ArrowAPI.ui.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and context.main_eval and G.GAME.blind:get_type() == 'Boss' then
		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.add_card{key = 'j_misprint', edition = 'e_negative'}
				return true
			end
		}))

		return {
			message = localize('k_vincenzo'),
			colour = G.C.BLUE
		}
	end
end



return jokerInfo
