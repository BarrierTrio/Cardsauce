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
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.e_negative
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_vincenzo" })
	ach_jokercheck(self, ach_checklists.band)
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	if specific_vars and not specific_vars.not_hidden then
		localize{type = 'unlocks', key = 'joker_locked_legendary', set = 'Other', nodes = desc_nodes, vars = {}}
	else
		localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
	end
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
	