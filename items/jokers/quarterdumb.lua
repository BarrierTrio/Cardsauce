local jokerInfo = {
	name = 'Quarterdumb',
	config = {},
	rarity = 4,
	cost = 20,
	unlocked = false,
	unlock_condition = {type = '', extra = '', hidden = true},
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "othervinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {G.GAME.probabilities.normal} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_quarterdumb" })
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
		info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
		localize{type = 'descriptions', key = self.key, set = self.set, nodes = desc_nodes, vars = {G.GAME.probabilities.normal}}
	end
end

local function textIsFlush(text)
	if text == "Flush" or text == "Straight Flush" or text == "Royal Flush" or text == "Flush House" or text == "Flush Five" then
		return true
	else
		return false
	end
end


function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff then
		local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(context.scoring_hand)
		if next(poker_hands["Flush"]) then
			ease_hands_played(1)
			return {
				card = card,
				message = localize('k_plus_hand'),
				colour = G.C.BLUE
			}
		end
	end
end



return jokerInfo
	