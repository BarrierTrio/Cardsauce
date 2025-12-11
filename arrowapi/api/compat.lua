-- Talisman compat
to_big = to_big or function(num)
	return num
end

local has_pl = SMODS.find_mod('plantain')
if next(has_pl) and has_pl[1].can_load then
	local pl_ref = SMODS.Centers.j_pl_plantain.calculate
	SMODS.Joker:take_ownership('pl_plantain', {
		calculate = function(self, card, context)
			if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
				if SMODS.food_expires(card) then
					return pl_ref(self, card, context)
				end
			else
				return pl_ref(self, card, context)
			end
		end
	}, true)

	local ap_ref = SMODS.Centers.j_pl_apple_pie.calculate
	SMODS.Joker:take_ownership('pl_apple_pie', {
		calculate = function(self, card, context)
			if context.pl_cash_out and not context.blueprint then
				if SMODS.food_expires(card) then
					return ap_ref(self, card, context)
				end
			else
				return ap_ref(self, card, context)
			end
		end
	}, true)

	local gs_ref = SMODS.Centers.j_pl_grape_soda.calculate
	SMODS.Joker:take_ownership('pl_grape_soda', {
		calculate = function(self, card, context)
			if context.skip_blind and not context.blueprint then
				G.E_MANAGER:add_event(Event({
					func = function()
						for i=1, #G.jokers.cards do
							other_soda = G.jokers.cards[i]
							if other_soda.ability.name == card.ability.name and other_soda ~= card and card.ability.extra.should_destroy then
								other_soda.ability.extra.should_destroy = false
							end
						end

						if SMODS.food_expires(card) then
							card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize('pl_grape_soda_gulp'), colour = G.C.RED})
							card:start_dissolve({G.C.RED}, card)
							play_sound('whoosh2')
						else
							card:juice_up()
						end
						G.E_MANAGER:add_event(Event({delay = 0.2,
							 func = function()
								 G.GAME.pl_grape_used = G.GAME.blind_on_deck
								 save_run()
								 return true
							 end}))
					return true
				end}))
			end
			if context.setting_blind and SMODS.food_expires(card) then
				card.ability.extra.should_destroy = true
			end
		end
	}, true)
end
