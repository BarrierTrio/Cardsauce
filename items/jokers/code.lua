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
	origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
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
	if context.before and not card.debuff then
		local codes = {
			[5] = 0,
			[6] = 0,
			[7] = 0,
			[8] = 0
		}
		for k, v in ipairs(context.full_hand) do
			if not v.debuff then
				local id = v:get_id()
				if codes[id] then
					codes[id] = codes[id] + 1
				end
			end
		end
		if codes[5] == 1 and codes[6] == 1 and codes[7] == 2 and codes[8] == 1 then
			check_for_unlock({ type = "activate_code" })
			return {
				dollars = card.ability.extra.money
			}
		end
	end
end



return jokerInfo
