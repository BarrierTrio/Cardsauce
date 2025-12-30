local jokerInfo = {
	name = 'Mr. Roger',
	atlas = 'jokers',
	pos = {x = 0, y = 2},
	config = {
		extra = {
			x_mult = 1,
			x_mult_mod = 0.1
		}
	},
	rarity = 2,
	cost = 6,
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
	artist = 'Lyzerus'
}

function jokerInfo.loc_vars(self, info_queue, card)
	local four_fingers = SMODS.four_fingers()
	if not ArrowAPI.config['enabled_DetailedDescs'] then
		info_queue[#info_queue+1] = {key = "rogernote", set = "Other", vars = {four_fingers}}
	end
	return {
		vars = {card.ability.extra.x_mult, four_fingers * card.ability.extra.x_mult_mod},
	}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main and to_big(card.ability.extra.x_mult) > to_big(1) then
		return {
			x_mult = card.ability.extra.x_mult,
		}
	end

	if context.blueprint then return end

	if context.before then
		local scale_table = {x_mult_mod = SMODS.four_fingers() * card.ability.extra.x_mult_mod }
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "x_mult",
			scalar_table = scale_table,
			scalar_value = "x_mult_mod",
		})
	end

	if context.end_of_round and to_big(card.ability.extra.x_mult) > to_big(1) then
		card.ability.extra.x_mult = 1
		return {
			message = localize('k_reset'),
			colour = G.C.RED
		}
	end
end



return jokerInfo
