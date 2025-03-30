local jokerInfo = {
	name = "I'm So Happy",
	config = {
		extra = {
			side = 'happy',
			plus = 2,
			minus = 1,
			flip = 3,
			calc = true
		},
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

SMODS.Atlas({ key = 'sosad', path ="jokers/sosad.png", px = 71, py = 95 })

local function changeHandsAndDiscards(handcrement, discardcrement)
	G.GAME.round_resets.hands = G.GAME.round_resets.hands + handcrement
	ease_hands_played(handcrement)
	G.GAME.round_resets.discards = G.GAME.round_resets.discards + discardcrement
	ease_discard(discardcrement)
end

function jokerInfo.loc_vars(self, info_queue)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_sohappy" })
	card.ability.extra.deschappy = G.localization.descriptions["Joker"]["j_csau_sohappy"]
	if card.ability.extra.side == 'happy' then
		changeHandsAndDiscards(card.ability.extra.plus, -card.ability.extra.minus)
	elseif card.ability.side == 'sad' then
		changeHandsAndDiscards(-card.ability.extra.minus, card.ability.extra.plus)
	end
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		if card.ability.extra.side == 'sad' then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
				 func = function()
					 card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_flip'), colour = G.C.CHIPS, instant = true})
					 G.localization.descriptions["Joker"]["j_sohappy"] = card.ability.extra.deschappy
					 card:juice_up(1, 1)
					 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
												  func = function()
													  card.ability.extra.side = 'happy'
													  return true; end}))
					 return true; end}))
			changeHandsAndDiscards(card.ability.extra.flip, -card.ability.extra.flip)
		elseif card.ability.extra.side == 'happy' then
			check_for_unlock({ type = "flip_sosad" })
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
				 func = function()
					 card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_flip'), colour = G.C.CHIPS, instant = true})
					 G.localization.descriptions["Joker"]["j_csau_sohappy"] = G.localization.descriptions["Joker"]["j_csau_sosad"]
					 card:juice_up(1, 1)
					 G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
												  func = function()
													  card.ability.extra.side = 'sad'
													  return true; end}))
					 return true; end}))
			changeHandsAndDiscards(-card.ability.extra.flip, card.ability.extra.flip)
		end
	end
	if context.selling_self then
		if card.ability.extra.side == 'sad' then
			changeHandsAndDiscards(card.ability.extra.minus, -card.ability.extra.plus)
		elseif card.ability.extra.side == 'happy' then
			changeHandsAndDiscards(-card.ability.extra.minus, card.ability.extra.plus)
		end
	end
end

function jokerInfo.update(self, card)
	if card.ability.extra.side == 'happy' then
		if G.localization.descriptions["Joker"]["j_csau_sohappy"] ~= G.localization.descriptions["Joker"]["j_csau_sohappy2"] then
			G.localization.descriptions["Joker"]["j_csau_sohappy"] = G.localization.descriptions["Joker"]["j_csau_sohappy2"]
		end
		if card.config.center.atlas ~= "csau_sohappy" then
			card.config.center.atlas = "csau_sohappy"
			card:set_sprites(card.config.center)
		end
	elseif card.ability.extra.side == 'sad' then
		if G.localization.descriptions["Joker"]["j_csau_sohappy"] ~= G.localization.descriptions["Joker"]["j_csau_sosad"] then
			G.localization.descriptions["Joker"]["j_csau_sohappy"] = G.localization.descriptions["Joker"]["j_csau_sosad"]
		end
		if card.config.center.atlas ~= "csau_sosad" then
			card.config.center.atlas = "csau_sosad"
			card:set_sprites(card.config.center)
		end
	end
end



return jokerInfo
	