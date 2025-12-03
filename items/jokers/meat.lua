local jokerInfo = {
	name = 'Meat',
	atlas = 'jokers',
	pos = {x = 8, y = 0},
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
	pools = { ["Food"] = true },
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return {vars = { card.ability.extra.cardsRemaining } }
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
					v.seal_delay = true
					v:set_seal(seal[pseudorandom('meat', 1, 4)], nil, nil, {set_func = function()
						card:juice_up()
					end} )
				end
			end
			if activate then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_meat_seal'), colour = G.C.MONEY})
				if SMODS.food_expires(card) then
					card.ability.extra.cardsRemaining = card.ability.extra.cardsRemaining - 1
				end
			end
		end

		if to_big(card.ability.extra.cardsRemaining) <= to_big(0) then
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

