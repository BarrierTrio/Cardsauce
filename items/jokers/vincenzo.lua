local jokerInfo = {
	name = 'Vincenzo',
	config = {},
	rarity = 4,
	cost = 20,
	unlocked = false,
	unlock_condition = {type = '', extra = '', hidden = true},
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "vinny",
	origin = "redvox",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_negative
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_vincenzo" })
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	G.FUNCS.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and G.GAME.blind.boss and (not context.individual) and (not context.repetition) then
		G.GAME.joker_buffer = G.GAME.joker_buffer + 1
		G.E_MANAGER:add_event(Event({
		func = function()
			local card = create_card('Joker', G.jokers, nil, 0, nil, nil, 'j_misprint', 'rif')
			card:set_edition({negative = true}, true, true)
			card:add_to_deck()
			G.jokers:emplace(card)
			card:start_materialize()
			G.GAME.joker_buffer = 0
		return true
		end}))
		card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_vincenzo'), colour = G.C.BLUE})
	end
end



return jokerInfo
