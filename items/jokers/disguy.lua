local jokerInfo = {
	name = 'DIS JOAKERRR',
	atlas = 'jokers',
	pos = {x = 4, y = 0},
	config = {
		extra = {
			messageIndex = 0
		}
	},
	rarity = 1,
	cost = 6,
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
	if not context.before or card.debuff or context.blueprint then return end

	local enhanced = 0
	for i, v in ipairs(context.scoring_hand) do
		if not v.debuff and (v:get_id() == 2 or v:get_id() == 5) and v.config.center.key == 'c_base' then
			enhanced = enhanced + 1
			local rand_enhancement = pseudorandom_element(G.P_CENTER_POOLS['Enhanced'], pseudoseed('csau_disguy'))
			G.E_MANAGER:add_event(Event({
				func = function()
					v:set_ability(rand_enhancement, nil, true)
					v:juice_up()
					return true
				end
			}))
		end
	end

	if enhanced == 0 then return end

	card.ability.extra.messageIndex = card.ability.extra.messageIndex + 1
	return {
		message = localize('k_disguy_'..((card.ability.extra.messageIndex % 2) + 1)),
		colour = G.C.MONEY,
		card = card,
	}
end

return jokerInfo