local jokerInfo = {
	name = 'Quarterdumb',
	atlas = 'jokers',
	pos = {x = 8, y = 5},
	soul_pos = {x = 9, y = 5},
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
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote',
	origin = {
		category = "cardsauce",
		sub_origins = {
			"redvox",
		},
		custom_color = "redvox",
	},
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.hand_mod} }
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
	ArrowAPI.ui.generate_legendary_desc(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.before and next(context.poker_hands['Flush']) then
		ease_hands_played(card.ability.extra.hand_mod)
		return {
			card = context.blueprint_card or card,
			message = localize('k_plus_hand'),
			colour = G.C.BLUE
		}
	end
end

return jokerInfo