local jokerInfo = {
	name = 'Miracle of Life',
	config = {},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.fenix } }
	return { vars = {G.GAME.probabilities.normal} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_miracle" })
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff then
		if next(context.poker_hands["Pair"]) then
			local id_count = {}
			local pair_count = 0
			local pairs_list = {}

			for k, v in ipairs(context.scoring_hand) do
				local id = v:get_id()

				if not id_count[id] then
					id_count[id] = {count = 0, items = {}}
				end
				id_count[id].count = id_count[id].count + 1
				table.insert(id_count[id].items, v)
			end

			for id, data in pairs(id_count) do
				local num_pairs = math.floor(data.count / 2)
				pair_count = pair_count + num_pairs

				for i = 1, num_pairs do
					table.insert(pairs_list, {data.items[2 * i - 1], data.items[2 * i]})
				end
			end
			local counter = 0
			for i, pair in ipairs(pairs_list) do
				local item1 = pair[1]
				local item2 = pair[2]
				local items = {item1, item2}

				local pair_suits = {}
				local pair_effects = {}
				local pair_seals = {}
				local pair_editions = {}

				for _i, item in ipairs(items) do
					table.insert(pair_suits, item.base.suit)
					table.insert(pair_effects, item.ability.effect)
					if item.seal then
						table.insert(pair_seals, item.seal)
					end
					if item.edition then
						table.insert(pair_editions, item.edition.type)
					end
				end
				if pseudorandom('miracle') < G.GAME.probabilities.normal / 2 then
					counter = counter + 1
					local filtered_cards = {}
					for k, v in pairs(G.P_CARDS) do
						if string.find(v.name, pair_suits[1]) or string.find(v.name, pair_suits[2]) then
							table.insert(filtered_cards, k)
						end
					end
					local _card = create_playing_card({front = G.P_CARDS[pseudorandom_element(filtered_cards, pseudoseed('miracle_card'))], center = G.P_CENTERS.c_base}, G.hand, nil, nil, {G.C.SECONDARY_SET.Enhanced})
					if pseudorandom('miracle_eff') < G.GAME.probabilities.normal / 2 then
						local rand_eff = pseudorandom_element(pair_effects, pseudoseed('miracle_effects'))
						if rand_eff ~= "Base" then
							check_for_unlock({ type = "miracle_inherit" })
							if rand_eff == "Bonus" then
								_card:set_ability(G.P_CENTERS.m_bonus, nil, false)
							elseif rand_eff == "Mult" then
								_card:set_ability(G.P_CENTERS.m_mult, nil, false)
							elseif rand_eff == "Wild Card" then
								_card:set_ability(G.P_CENTERS.m_wild, nil, false)
							elseif rand_eff == "Glass Card" then
								_card:set_ability(G.P_CENTERS.m_glass, nil, false)
							elseif rand_eff == "Steel Card" then
								_card:set_ability(G.P_CENTERS.m_steel, nil, false)
							elseif rand_eff == "Stone Card" then
								_card:set_ability(G.P_CENTERS.m_stone, nil, false)
							elseif rand_eff == "Gold Card" then
								_card:set_ability(G.P_CENTERS.m_gold, nil, false)
							elseif rand_eff == "Lucky Card" then
								_card:set_ability(G.P_CENTERS.m_lucky, nil, false)
							end
						end
						_card:juice_up()
					end
					if #pair_seals > 0 then
						if pseudorandom('miracle_s') < G.GAME.probabilities.normal / 2 then
							check_for_unlock({ type = "miracle_inherit" })
							local rand_seal = pseudorandom_element(pair_seals, pseudoseed('miracle_seals'))
							_card:set_seal(rand_seal, true)
						end
					end
					if #pair_editions > 0 then
						if pseudorandom('miracle_e') < G.GAME.probabilities.normal / 2 then
							check_for_unlock({ type = "miracle_inherit" })
							local rand_edition = pseudorandom_element(pair_editions, pseudoseed('miracle_editions'))
							if rand_edition == "foil" then
								_card:set_edition({foil = true}, true, true)
							elseif rand_edition == "holo" then
								_card:set_edition({holo = true}, true, true)
							elseif rand_edition == "polychrome" then
								_card:set_edition({polychrome = true}, true, true)
							end
						end
					end
					G.GAME.blind:debuff_card(_card)
					G.hand:sort()
					if context.blueprint_card then context.blueprint_card:juice_up() else card:juice_up() end
				end
			end
			if counter == 1 then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_one')..localize('k_child'), colour = G.C.IMPORTANT})
			elseif counter == 2 then
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_two')..localize('k_child'), colour = G.C.IMPORTANT})
			end
		end
	end
end

return jokerInfo
	