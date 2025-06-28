local jokerInfo = {
	name = 'Quarterdumb',
	config = {
		extra = {
			hand_mod = 1
		}
	},
	rarity = 4,
	cost = 20,
	unlocked = false,
	unlock_condition = {type = '', extra = '', hidden = true},
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "othervinny",
	origin = "redvox",
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.hand_mod} }
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	G.FUNCS.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.cardarea == G.jokers and context.before and next(context.poker_hands['Flush']) then
		ease_hands_played(card.ability.extra.hand_mod)
		return {
			card = card,
			message = localize('k_plus_hand'),
			colour = G.C.BLUE
		}
	end
end

return jokerInfo