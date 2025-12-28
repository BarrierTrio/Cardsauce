local jokerInfo = {
	name = 'That\'s Werewolves',
	atlas = 'jokers',
	pos = {x = 0, y = 6},
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
	return { vars = {card.ability.extra.x_mult, localize(card.ability.extra.hand, 'poker_hands')} }
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	local hands = {}
	for _, v in ipairs(G.handlist) do
		if SMODS.is_poker_hand_visible(v) then hands[#hands+1] = v end
	end
	card.ability.extra.hand = pseudorandom_element(hands, (card.area and card.area.config.type == 'title' and 'false_werewolves' or 'werewolves'))
end

function jokerInfo.calculate(self, card, context)
	if context.debuff_hand and context.scoring_name == card.ability.extra.hand then
		return {
			debuff = true,
			debuff_text = localize('k_werewolves'),
			debuff_source = card
		}
	end

	if context.joker_main then
		return {
			x_mult = card.ability.extra.x_mult,
		}
	end

	if context.end_of_round and context.main_eval and G.GAME.blind:get_type() == 'Boss' then
		local hands = {}
		for i, v in ipairs(G.handlist) do
			if SMODS.is_poker_hand_visible(v) then hands[#hands+1] = v end
		end
		card.ability.extra.hand = pseudorandom_element(hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_werewolves' or 'werewolves'))
	end
end



return jokerInfo
