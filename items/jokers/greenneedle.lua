local jokerInfo = {
	name = 'Green Needle',
	config = {},
	rarity = 3,
	cost = 10,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	unlock_condition = {type = 'win_deck', deck = 'b_green'},
	streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.check_for_unlock(self, args)
	if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) or args.type == "actuallyunlocksorry" then
		return true
	end
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_greenneedle" })
end

function jokerInfo.calculate(self, card, context)
	local rightmost_joker = G.jokers.cards[#G.jokers.cards]
	if rightmost_joker and rightmost_joker ~= card and not context.no_blueprint then
		context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
		context.blueprint_card = context.blueprint_card or card
		if context.blueprint > #G.jokers.cards + 1 then return end
		local other_joker_ret = rightmost_joker:calculate_joker(context)
		context.blueprint = nil
		local eff_card = context.blueprint_card or card
		context.blueprint_card = nil
		if other_joker_ret then
			other_joker_ret.card = eff_card
			other_joker_ret.colour = G.C.BLUE
			return other_joker_ret
		end
	end
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	if card.config.center.discovered then
		-- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
		full_UI_table.name = localize{type = 'name', key = self.key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
	end
	localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = self.loc_vars(self, info_queue, card)}
	if card.area and card.area == G.jokers then
		desc_nodes[#desc_nodes+1] = {
			{n=G.UIT.C, config={align = "bm", minh = 0.4}, nodes={
				{n=G.UIT.C, config={ref_table = self, align = "m", colour = card.ability.blueprint_compat == 'compatible' and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06}, nodes={
					{n=G.UIT.T, config={text = ' '..localize('k_'..card.ability.blueprint_compat)..' ',colour = G.C.UI.TEXT_LIGHT, scale = 0.32*0.8}},
				}}
			}}
		}
	end
end

function jokerInfo.update(self, card)
	if G.STAGE == G.STAGES.RUN then
		local other_joker = G.jokers.cards[#G.jokers.cards]
		if other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat then
			card.ability.blueprint_compat = 'compatible'
		else
			card.ability.blueprint_compat = 'incompatible'
		end
	end
end

return jokerInfo
	