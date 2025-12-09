local jokerInfo = {
	name = 'Very Expensive Joker',
	atlas = 'jokers',
	pos = {x = 9, y = 1},
	config = {
		extra = {
			x_mult = 1,
			x_mult_mod = 0.5,
			cost = 4
		},
	},
	rarity = 2,
	cost = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.x_mult } }
end

function jokerInfo.in_pool(self, args)
	return not args or args.source ~= 'jud'
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff then return end

	if to_big(G.GAME.dollars) >= to_big(60) then
		check_for_unlock({ type = "purchase_dink" })
	end

	card.ability.extra.x_mult = 1 + math.floor(G.GAME.dollars/10) * card.ability.extra.x_mult_mod
	card.base_cost = G.GAME.dollars
	card.cost = card.base_cost
	card.sell_cost = math.min(10, card.cost/2)
	card_eval_status_text(card, 'extra', nil, nil, nil, {
		message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
		colour = G.C.MONEY,
	})
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main then
		return {
			x_mult = card.ability.extra.x_mult,
		}
	end
end

return jokerInfo