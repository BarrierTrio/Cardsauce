local jokerInfo = {
	name = 'No No No No No No No No No No No',
	config = {
		extra = 2,
	},
	rarity = 1,
	cost = 0,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.calculate(self, card, context)
	if context.other_joker and not card.debuff and not context.blueprint then
		if (context.other_joker.config.center.name == ('No No No No No No No No No No No') or context.other_joker.ability.name == 'Hanging Chad' or context.other_joker.ability.name == 'Showman') and card ~= context.other_joker then
			check_for_unlock({ type = "chadley_power" })
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))
			return {
				message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
            	Xmult_mod = card.ability.extra
			}
		end
	end
end

return jokerInfo