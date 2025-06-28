local jokerInfo = {
	name = 'Depressed Brother',
	config = {
		extra = {
			mult_mod = 1,
			prob = 2,
		}
	},
	rarity = 2,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	has_shiny = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.cejai } }
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.prob), card.ability.extra.mult_mod } }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or not context.bfore then return end

	for _, v in ipairs(context.full_hand) do
		if not SMODS.in_scoring(v, context.scoring_hand) and SMODS.pseudorandom_probability(G.GAME.blind, pseudoseed('csau_depressed'), 1, card.ability.extra.prob) then
			v.ability.perma_mult = (v.ability.perma_mult or 0) + card.ability.extra.mult_mod
			card_eval_status_text(v, 'extra', nil, nil, nil, {
				message = localize('k_upgrade_ex'),
				colour = G.C.MULT,
				func = function() 
					card:juice_up()
				end
			})
		end
	end
end

return jokerInfo
	