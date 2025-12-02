local jokerInfo = {
	name = 'No No No No No No No No No No No',
	atlas = 'jokers',
	pos = {x = 3, y = 3},
	config = {
		extra = {
			x_mult = 2
		},
	},
	rarity = 1,
	cost = 0,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end
	if context.other_joker and card ~= context.other_joker then
		if context.other_joker.config.center.key == 'j_csau_chad'
		or context.other_joker.config.center.key == 'j_hanging_chad'
		or context.other_joker.config.center.key == 'j_ring_master' then
			check_for_unlock({ type = "chadley_power" })
			G.E_MANAGER:add_event(Event({
				func = function()
					context.other_joker:juice_up(0.5, 0.5)
					return true
				end
			}))

			return {
				x_mult = card.ability.extra.x_mult,
			}
		end
	end
end

return jokerInfo