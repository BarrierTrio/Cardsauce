local jokerInfo = {
	name = 'Two-Faced Joker',
	atlas = 'jokers',
	pos = {x = 1, y = 0},
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.calculate(self, card, context)
	if card.debuff or context.blueprint then return end

	if context.after then
		local two, ace = false, false
		for _, v in ipairs(G.play.cards) do
			if v:get_id() == 14 then
				two = true
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.change_base(v, nil, '2')
						v:juice_up()
						return true
					end
				}))
			elseif v:get_id() == 2 then
				ace = true
				G.E_MANAGER:add_event(Event({
					func = function()
						SMODS.change_base(v, nil, 'Ace')
						v:juice_up()
						return true
					end
				}))
			end
		end

		if two or ace then
			return {
				message = localize((two and (ace and 'k_twoed_aced' or 'k_twoed')) or 'k_aced'),
				colour = G.C.MONEY,
			}
		end
	end
end

return jokerInfo
