local jokerInfo = {
	name = 'PAC-MAN Incident',
	config = {
		extra = {
			mult = 0,
			mult_mod = 5
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.mult} }
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not card.debuff and not context.individual and not context.repetition and not context.blueprint then
		if to_big(G.GAME.chips) <= to_big(G.GAME.blind.chips * 1.1) then
			card.ability.extra.mult = to_big(card.ability.extra.mult) + to_big(card.ability.extra.mult_mod)
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.MULT})
		end
	end
	if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra.mult) > to_big(0) then
		return {
			message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}},
			mult_mod = card.ability.extra.mult,
		}
	end
end

return jokerInfo
