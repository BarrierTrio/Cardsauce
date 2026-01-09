local jokerInfo = {
	name = 'Fantabulous Joker',
	atlas = 'jokers',
	pos = {x = 3, y = 7},
	config = {
		extra = {
			money_mod = 3,
			sell_val = 40
		}
	},
	rarity = 1,
	cost = 8,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	pools = { ["Food"] = true },
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
	if not self.csau_fantabulous_sell then
		card:set_cost()
	end
	return { vars = {card.ability.extra.sell_val, card.ability.extra.money_mod, card.csau_fantabulous_sell} }
end

function jokerInfo.add_to_deck(self, card)
	card:set_cost()
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end

	if context.end_of_round and context.main_eval and SMODS.food_expires(card) then
		SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = "sell_val",
            scalar_value = "sell_val",
			operation = '-',
            no_message = true
        })

		card:set_cost()

		if card.ability.extra.sell_val > 0 then
			return {
				message = localize('k_val_down'),
				colour = G.C.MONEY,
				card = card
			}
		else
			check_for_unlock({ type = "expire_fantabulous" })
			ArrowAPI.game.card_expire(card, 'k_worthless_ex', G.C.MONEY)
		end

	end
end

return jokerInfo
