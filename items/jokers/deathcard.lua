local jokerInfo = {
	name = 'Deathcard',
	config = {
		id = nil,
		timesSold = nil,
		extra = {
			money_mod = 5,
			mult = 4,
			mult_mod = 10
		},
	},
	rarity = 2,
	cost = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "other",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {card.ability.extra.money_mod, card.ability.extra.mult, card.ability.extra.mult_mod} }
end

function jokerInfo.add_to_deck(self, card)
	card.sell_cost = math.max(1, math.floor(card.cost/2))
	check_for_unlock({ type = "discover_deathcard" })
	if card.ability.timesSold and card.ability.timesSold >= 5 then
		check_for_unlock({ type = "five_deathcard" })
	end
	if not card.ability.id then
		if not G.GAME.uniqueDeathcardsAcquired then
			G.GAME.uniqueDeathcardsAcquired = 1
		else
			G.GAME.uniqueDeathcardsAcquired = G.GAME.uniqueDeathcardsAcquired + 1
		end
		card.ability.id = G.GAME.uniqueDeathcardsAcquired
	else
		local other_dc = find_joker('Deathcard')
		if other_dc[1] then
			if other_dc[1].Mid.ability.id == card.ability.id then
				G.GAME.uniqueDeathcardsAcquired = G.GAME.uniqueDeathcardsAcquired + 1
				card.ability.id = G.GAME.uniqueDeathcardsAcquired
			end
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_mult',vars={to_big(card.ability.extra.mult)}},
			colour = G.C.MULT,
			mult_mod = card.ability.extra.mult,
			card = card
		}
	end
	if context.selling_self then
		local stop = false
		if G.GAME.deathsold then
			for i, v in ipairs(G.GAME.deathsold) do
				if v['id'] == card.ability.id then
					stop = true
				end
			end
		end
		if not stop then
			if card.ability.timesSold then
				card.ability.timesSold = card.ability.timesSold + 1
			else
				card.ability.timesSold = 1
			end
			if not G.GAME.deathsold then
				G.GAME.deathsold = {}
			end
			G.GAME.deathsold[#G.GAME.deathsold+1] = {id=card.ability.id, timesSold=card.ability.timesSold, edition=card.edition and card.edition.type or nil}
			if G.GAME.spawnDeathcards then
				G.GAME.spawnDeathcards = G.GAME.spawnDeathcards + 1
			else
				G.GAME.spawnDeathcards = 1
			end
		end
	end
end

function jokerInfo.update(self, card)
	if card.area and card.area.config.type == "shop" and G.GAME.deathsold then
		if #G.GAME.deathsold > 0 and not card.ability.id and not card.ability.timesSold then
			local death = G.GAME.deathsold[1]
			local id = death['id']
			if death['edition'] then
				if death['edition'] == "foil" then
					card:set_edition({foil = true}, true, true)
				elseif death['edition'] == "holo" then
					card:set_edition({holo = true}, true, true)
				elseif death['edition'] == "polychrome" then
					card:set_edition({polychrome = true}, true, true)
				elseif death['edition'] == "negative" then
					card:set_edition({negative = true}, true, true)
				end
			end
			card.ability.id = id
			local timesSold = death['timesSold']
			card.ability.timesSold = timesSold
			local newcost = card.cost + (card.ability.extra.money_mod * card.ability.timesSold)
			card.cost = newcost
			local newmult = card.ability.extra.mult + (card.ability.extra.mult_mod * card.ability.timesSold)
			card.ability.extra.mult = newmult
			table.remove(G.GAME.deathsold, 1)
		end
	end
end

return jokerInfo
	