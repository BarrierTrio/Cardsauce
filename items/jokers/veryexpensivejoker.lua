local jokerInfo = {
	name = 'Very Expensive Joker',
	atlas = 'jokers',
	pos = {x = 9, y = 1},
	config = {
		extra = {
			x_mult = nil,
			cost = 4
		},
		wasShop = false
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

local function get_xmult(card)
	if card.area == G.jokers and card.ability.wasShop and card.ability.extra.x_mult then
		return card.ability.extra.x_mult
	elseif card.area == G.shop_jokers and card.ability.wasShop then
		return ((math.floor(to_big(card.cost)/to_big(10))/to_big(2)) + to_big(1)) or to_big(1)
	else
		return 1
	end
end


function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { get_xmult(card) } }
end

function jokerInfo.add_to_deck(self, card)
	if to_big(G.GAME.dollars) == to_big(card.cost) and card.ability.wasShop then
		if card.cost >= to_big(60) then
			check_for_unlock({ type = "purchase_dink" })
		end
		card.ability.extra.x_mult = (math.floor(to_big(card.cost)/to_big(10))/to_big(2)) + to_big(1)
		card.sell_cost = math.max(to_big(1), math.floor(to_big(card.cost)/to_big(2)))
		if to_big(card.sell_cost) > to_big(10) then
			card.sell_cost = to_big(10)
		end
		G.E_MANAGER:add_event(Event({
			func = function()
				card:juice_up()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}}, colour = G.C.MONEY, instant = true})
				return true
			end
		}))
	end
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
			Xmult_mod = card.ability.extra.x_mult,
		}
	end
end

function jokerInfo.update(self, card)
	if card.area and card.area.config.type ~= "joker" then
		if (card.area == G.shop_jokers or card.area == G.morshu_area) and card.ability.wasShop == false then
			card.ability.wasShop = true
		end
		if to_big(card.cost) ~= to_big(G.GAME.dollars) and to_big(G.GAME.dollars) ~= to_big(0) then
			card.ability.extra.cost = to_big(G.GAME.dollars)
			card.cost = to_big(card.ability.extra.cost)
		end
	end
end


return jokerInfo