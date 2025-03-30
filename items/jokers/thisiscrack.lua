local jokerInfo = {
	name = 'This Is Crack',
	config = {
		extra = {
			x_mult = 1,
			crack_hand = nil
		}
	},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	hasSoul = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {card.ability.extra.x_mult, card.ability.extra.crack_hand and localize(card.ability.extra.crack_hand, 'poker_hands') or localize('k_none')} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_crack" })
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not context.blueprint then
		local hand = context.scoring_name
		if hand == card.ability.extra.crack_hand or card.ability.extra.crack_hand == "None" then
			card.ability.extra.x_mult = to_big(card.ability.extra.x_mult) + to_big(0.1)
		else
			card.ability.extra.crack_hand = hand
			if to_big(card.ability.extra.x_mult) > to_big(1) then
                card.ability.extra.x_mult = to_big(1)
                return {
                    card = card,
                    message = localize('k_reset')
                }
            end
		end
		card.ability.extra.crack_hand = hand
	  end
	if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra.x_mult) > to_big(1) then
		return {
			message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
			Xmult_mod = card.ability.extra.x_mult,
		}
	end
end



return jokerInfo
	