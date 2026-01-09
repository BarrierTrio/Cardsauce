local jokerInfo = {
	name = 'This Is Crack',
	atlas = 'jokers',
	pos = {x = 7, y = 4},
	soul_pos = {x = 8, y = 4},
	config = {
		extra = {
			x_mult = 1,
			x_mult_mod = 0.1,
			crack_hand = nil
		}
	},
	rarity = 3,
	cost = 8,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	has_shiny = true,
	pools = {
		["Meme"] = true
	},
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
	local key = self.key..(card.ability.extra.crack_hand and '_alt' or '')
	return {
		vars = {
			card.ability.extra.x_mult_mod,
			card.ability.extra.x_mult,
			card.ability.extra.crack_hand and localize(card.ability.extra.crack_hand, 'poker_hands') or nil
		},
		key = key,
	}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.before and not context.blueprint then
		local hand = context.scoring_name
		if hand == card.ability.extra.crack_hand then
			SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_mod",
                message_key = 'a_xmult',
				message_colour = G.C.MULT
            })
			check_for_unlock({type = 'scale_card', card = card, value = card.ability.extra.x_mult})
		else
			card.ability.extra.crack_hand = hand
			if card.ability.extra.x_mult > 1 then
                card.ability.extra.x_mult = 1
            end

			return {
				card = card,
				message = localize(hand, 'poker_hands')..'!'
			}
		end
	end

	if context.joker_main and card.ability.extra.x_mult > 1 then
		return {
			x_mult = card.ability.extra.x_mult,
		}
	end
end



return jokerInfo
