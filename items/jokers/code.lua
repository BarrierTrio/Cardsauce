local jokerInfo = {
	name = 'Industry Code',
	atlas = 'jokers',
	pos = {x = 5, y = 3},
	config = {
		extra = {
			money = 20
		}
	},
	rarity = 2,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}


function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.money } }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers and not card.debuff then
		local code5 = 0
		local code6 = 0
		local code7 = 0
		local code8 = 0
		for k, v in ipairs(context.full_hand) do
			if v:get_id() == 5 then code5 = code5 + 1 end
			if v:get_id() == 6 then code6 = code6 + 1 end
			if v:get_id() == 7 then code7 = code7 + 1 end
			if v:get_id() == 8 then code8 = code8 + 1 end
		end
		if code5 == 1 and code6 == 1 and code7 == 2 and code8 == 1 then
			check_for_unlock({ type = "activate_code" })
			return {
				dollars = card.ability.extra.money
			}
		end
	end
end



return jokerInfo
