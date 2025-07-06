local jokerInfo = {
	name = 'Miracle of Life',
	config = {
		extra = {
			chance = 2
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.fenix } }
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance, 'csau_miracle')} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.cardarea == G.jokers and context.before and next(context.poker_hands['Pair']) then
		local new_cards = {}
		for _, pair in ipairs(context.poker_hands['Pair']) do
			if SMODS.pseudorandom_probability(card, 'csau_miracle', 1, card.ability.extra.chance) then
				local pair_suits = {}
				local pair_enhancements = {}
				local pair_seals = {}
				local pair_editions = {}

				for _, item in ipairs({pair[1], pair[2]}) do
					pair_suits[SMODS.Suits[item.base.suit].card_key] = true

					if item.config.center.key ~= 'c_base' then
						table.insert(pair_enhancements, item.config.center.key)
					end
					
					if item.seal then
						table.insert(pair_seals, item.seal)
					end

					if item.edition then
						table.insert(pair_editions, item.edition.type)
					end
				end

				local filtered_cards = {}

				for k, _ in pairs(G.P_CARDS) do
					local suit_key = string.sub(k, 1, 1)
					if pair_suits[suit_key] then
						table.insert(filtered_cards, k)
					end
				end

				local miracle_center = 'c_base'
				if #pair_enhancements > 0 and SMODS.pseudorandom_probability(card, 'csau_miracle_enhance', 1, card.ability.extra.chance) then
					miracle_center = #pair_enhancements == 1 and pair_enhancements[1] or pseudorandom_element(pair_enhancements, pseudoseed('csau_miracle_enhancements'))
				end

				local seal = nil
				if #pair_seals > 0 and SMODS.pseudorandom_probability(card, 'csau_miracle_seal_1', 1, card.ability.extra.chance) then
					check_for_unlock({ type = "miracle_inherit" })
					seal = #pair_seals == 1 and pair_seals[1] or pseudorandom_element(pair_seals, pseudoseed('csau_miracle_seal_2'))
				end

				local edition = nil
				if #pair_editions > 0 and SMODS.pseudorandom_probability(card, 'csau_miracle_edition_1', 1, card.ability.extra.chance) then
					check_for_unlock({ type = "miracle_inherit" })
					edition = #pair_editions == 1 and pair_editions[1] or pseudorandom_element(pair_editions, pseudoseed('csau_miracle_edition_2'))
				end

				local new_card = SMODS.add_card({
					set = 'Enhanced',
					enhancement = miracle_center,
					key = miracle_center,
					front = pseudorandom_element(filtered_cards, pseudoseed('csau_miracle_card')),
					skip_materialize = true,
					edition = edition,
					seal = seal
				})
				new_cards[#new_cards+1] = new_card

				new_card.states.visible = nil
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					func = function()
						new_card:start_materialize()
						return true
					end
				}))
				delay(0.2)
			end
		end

		playing_card_joker_effects(new_cards)

		return {
			message = localize{type = 'variable', key = 'a_plus_card', vars = {#new_cards}},
			colour = G.C.IMPORTANT,
		}
	end
end

return jokerInfo
	