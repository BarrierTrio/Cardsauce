local jokerInfo = {
	name = 'Two-Faced Joker',
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_twoface" })
end

function jokerInfo.calculate(self, card, context)
	if context.final_scoring_step then
		G.E_MANAGER:add_event(Event({
			func = function()
				local two, ace = false, false
				local convert = {}
				for i, v in ipairs(G.play.cards) do
					if v:get_id() == 14 then
						convert[i] = true
						ace = true
					elseif v:get_id() == 2 then
						convert[i] = true
						two = true
					else
						convert[i] = false
					end
				end
				if (two or ace) and #convert > 0 then
					for i, v in ipairs(G.play.cards) do
						if convert[i] then
							v:juice_up()
							local suit_prefix = string.sub(v.base.suit, 1, 1)..'_'
							if v:get_id() == 14 then
								v:set_base(G.P_CARDS[suit_prefix..2])
							elseif v:get_id() == 2 then
								v:set_base(G.P_CARDS[suit_prefix..'A'])
							end
						end
					end
					if two and ace then
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_twoed_aced'), colour = G.C.MONEY, instant = true})
					elseif two and not ace then
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_aced'), colour = G.C.MONEY, instant = true})
					elseif ace and not two then
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_twoed'), colour = G.C.MONEY, instant = true})
					end
				end
				return true
			end
		}))
	end
end



return jokerInfo
	