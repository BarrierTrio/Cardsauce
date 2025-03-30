local jokerInfo = {
	name = 'Meat',
	config = {
		extra = {
			cardsRemaining = 3
		}
	},
	rarity = 2,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	streamer = "vinny",
}


function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return {vars = { card.ability.extra.cardsRemaining } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_meat" })
	ach_jokercheck(self, ach_checklists.high)
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff and not context.blueprint then
		if context.scoring_name == "High Card" then
			local seal = {
				[1] = "Gold",
				[2] = "Red",
				[3] = "Blue",
				[4] = "Purple",
			}
			local activate = false
			for k, v in ipairs(context.scoring_hand) do
				if not v.seal then
					activate = true
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							v:set_seal(seal[pseudorandom('meat', 1, 4)], nil, true)
							return true
						end
					}))
				end
			end
			if activate then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_meat_seal'), colour = G.C.MONEY})
				if not next(SMODS.find_card('j_csau_bunji')) then
					card.ability.extra.cardsRemaining = card.ability.extra.cardsRemaining - 1
				end
			end
		end

		if card.ability.extra.cardsRemaining <= 0 then 
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true
						end
					}))
					check_for_unlock({ type = "meat_beaten" })
					return true
				end
			}))
			return {
				message = localize('k_meat_destroy'),
				colour = G.C.MONEY
			}
		end
	end
end



return jokerInfo
	
