local jokerInfo = {
	name = 'That\'s Werewolves',
	config = {
		extra = {
			x_mult = 3,
			hand = "Flush"
		}
	},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
	return { vars = {card.ability.extra.x_mult, localize(card.ability.extra.hand, 'poker_hands')} }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then _poker_hands[#_poker_hands+1] = k end
	end
	card.ability.extra.hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_werewolves' or 'werewolves'))
end

-- TODO: reimplement werewolves debuff hand with modern SMODS contexts

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
			Xmult_mod = card.ability.extra.x_mult,
		}
	end
	if context.end_of_round and G.GAME.blind.boss and not context.other_card then
		local _poker_hands = {}
		for k, v in pairs(G.GAME.hands) do
			if v.visible then _poker_hands[#_poker_hands+1] = k end
		end
		card.ability.extra.hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_werewolves' or 'werewolves'))
	end
end



return jokerInfo
