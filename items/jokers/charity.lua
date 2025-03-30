local jokerInfo = {
	name = 'Charity Stream',
	config = {extra = {
		mult = 0,
		mult_gain = 0
	}},
	rarity = 3,
	cost = 7,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	unlock_condition = {type = 'win_deck', deck = 'b_green'},
	streamer = "other",
}

function jokerInfo.check_for_unlock(self, args)
	if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) or args.type == "actuallyunlocksorry" then
		return true
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = { card.ability.extra.mult } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_charity" })
	if not G.GAME.selected_back.effect.config.no_interest then
		G.GAME.modifiers.no_interest = true
	end
end

function jokerInfo.remove_from_deck(self, card)
	if not G.GAME.selected_back.effect.config.no_interest then
		G.GAME.modifiers.no_interest = false
	end
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
		card.ability.extra.mult_gain = 0
		if G.GAME.modifiers.no_interest then
			card.ability.extra.mult_gain = to_big(G.GAME.interest_amount)*math.min(math.floor(to_big(G.GAME.dollars)/to_big(5)), to_big(G.GAME.interest_cap)/to_big(5))
		end
		card.ability.extra.mult = to_big(card.ability.extra.mult) + to_big(card.ability.extra.mult_gain)
		if to_big(card.ability.extra.mult_gain) ~= 0 then
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{ type = 'variable', key = 'a_mult', vars = {to_big(card.ability.extra.mult_gain)} }, colour = G.C.MULT})
		end
	end
	
	if context.joker_main and context.cardarea == G.jokers then
		if to_big(card.ability.extra.mult) ~= to_big(0) then
			return {
				message = localize { type = 'variable', key = 'a_mult', vars = {to_big(card.ability.extra.mult)} },
				mult_mod = card.ability.extra.mult,
			}
		end
	end
end



return jokerInfo
	