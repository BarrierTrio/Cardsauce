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
	cost = 20,
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
	return { vars = {card.ability.extra.sell_val, card.ability.extra.money_mod} }
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = card.ability.extra.sell_val
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end

	if context.end_of_round and context.main_eval and SMODS.food_expires(card) then
		card.ability.extra.sell_val = card.ability.extra.sell_val - card.ability.extra.money_mod
		card.sell_cost = card.ability.extra.sell_val
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
