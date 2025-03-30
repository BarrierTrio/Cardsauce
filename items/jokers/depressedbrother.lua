local jokerInfo = {
	name = 'Depressed Brother',
	config = {
		extra = {
			chips = 0,
			chip_mod = 2
		}
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cejai } }
	return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
end

function jokerInfo.calculate(self, card, context)
	local bad_context = context.repetition or context.individual or context.blueprint
	if context.cardarea == G.jokers and context.before and not card.debuff and not bad_context then
		local unscored = #context.full_hand - #context.scoring_hand
		if unscored > 0 then
			card.ability.extra.chips = card.ability.extra.chips + unscored*card.ability.extra.chip_mod
			return {
				message = localize('k_upgrade_ex'),
				card = card,
				colour = G.C.CHIPS
			}
		end
	end
	if context.joker_main and card.ability.extra.chips > 0 then
		return {
			chips = card.ability.extra.chips
		}
	end

end

return jokerInfo
	