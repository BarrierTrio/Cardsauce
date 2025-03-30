local jokerInfo = {
	name = 'Shrimp Joker',
	texture = 'shrimp-',
	config = {},
	rarity = 2,
	cost = 6,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "vinny",
}

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_shrimp" })
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.check_for_unlock(self, args)
	if args.type == "meat_beaten" then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.repetition and not self.debuff then
		if context.end_of_round and context.cardarea == G.hand then
			if (next(context.card_effects[1]) or #context.card_effects > 1) then
				if context.other_card.seal == 'Blue' then 
					return {
						message = localize('k_again_ex'),
						repetitions = 1,
						card = card
					}
				end
			end
		end
		if context.cardarea == G.play then
			if context.other_card.seal == 'Red' then 
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
			if context.other_card.seal == 'Gold' then
				ease_dollars(3)
				return {
					message = localize('k_again_ex'),
					repetitions = 0,
					card = card
				}
			end
		end
		if context.cardarea == G.hand then
			if context.other_card.seal == 'Red' then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
	if context.discard and not card.debuff then
		if context.other_card.seal == 'Purple' and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.0,
				func = (function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
					local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
					_card:add_to_deck()
					G.consumeables:emplace(_card)
					G.GAME.consumeable_buffer = 0
					return true
					end)}))
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
		end
	end
end

return jokerInfo
	