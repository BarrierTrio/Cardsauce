local jokerInfo = {
	name = 'DIS JOAKERRR',
	config = {extra = {messageIndex = 0}},
	rarity = 1,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	streamer = "vinny",
}

local function detect2or5(scoring_hand)
	for k, v in ipairs(scoring_hand) do
		if (v:get_id() == 2 or v:get_id() == 5) and v.ability.effect == "Base" and not v.debuff then
			return true
		end
	end
	return false
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
	return { vars = {}, key = self.key..(csau_config['detailedDescs'] and '_detailed' or '') }
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff and not context.blueprint then
		if detect2or5(context.scoring_hand) then
			local enhancements = {
				[1] = G.P_CENTERS.m_bonus,
				[2] = G.P_CENTERS.m_mult,
				[3] = G.P_CENTERS.m_wild,
				[4] = G.P_CENTERS.m_glass,
				[5] = G.P_CENTERS.m_steel,
				[6] = G.P_CENTERS.m_stone,
				[7] = G.P_CENTERS.m_gold,
				[8] = G.P_CENTERS.m_lucky,
			}
			for i, v in ipairs(context.scoring_hand) do
				if (v:get_id() == 2 or v:get_id() == 5) and v.ability.effect == "Base" and not v.debuff then
					v:set_ability(enhancements[pseudorandom('OONDORTOOL', 1, 8)], nil, true)
					G.E_MANAGER:add_event(Event({
						func = function()
							v:juice_up()
							return true
						end
					}))
				end
			end
			card.ability.extra.messageIndex = card.ability.extra.messageIndex + 1
			return {
				message = localize('k_disguy_'..((card.ability.extra.messageIndex % 2) + 1)),
				colour = G.C.MONEY,
				card = card,
			}
		end
	end
end

return jokerInfo