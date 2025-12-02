local jokerInfo = {
	name = 'Fantabulous Joker',
	atlas = 'jokers',
	pos = {x = 3, y = 7},
	config = {
		money_mod = 3,
		sell_val = 40
	},
	rarity = 1,
	cost = 20,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	pools = { ["Food"] = true },
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.sell_val, card.ability.money_mod} }
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = card.ability.sell_val
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
		card.ability.sell_val = card.ability.sell_val - card.ability.money_mod
		card.sell_cost = card.ability.sell_val
		if SMODS.food_expires(context) then
			if to_big(card.ability.sell_val) > to_big(0) then
				return {
					message = localize('k_val_down'),
					colour = G.C.MONEY,
					card = card
				}
			else
				check_for_unlock({ type = "expire_fantabulous" })
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
						return true
					end
				}))
				return {
					message = localize('k_worthless_ex'),
					colour = G.C.MONEY
				}
			end
		end

	end
end

return jokerInfo
