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
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.chance)} }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.cardarea == G.jokers and context.before and next(context.poker_hands['Pair']) then
		local new_cards = {}
		for _, pair in ipairs(context.poker_hands['Pair']) do
			if SMODS.pseudorandom_probability(card, pseudoseed('csau_miracle'), 1, card.ability.extra.chance) then
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
				if SMODS.pseudorandom_probability(card, pseudoseed('csau_miracle_enhance'), 1, card.ability.extra.chance) then
					miracle_center = pseudorandom_element(pair_enhancements, pseudoseed('csau_miracle_enhancements'))
				end

				local new_card = create_playing_card(
					{
						front = G.P_CARDS[pseudorandom_element(filtered_cards, pseudoseed('csau_miracle_card'))],
						center = G.P_CENTERS[miracle_center]
					},
					G.hand,
					nil,
					#new_cards == 0,
					{G.C.SECONDARY_SET.Enhanced}
				)
				new_cards[#new_cards+1] = new_card

				if #pair_seals > 0 and SMODS.pseudorandom_probability(card, pseudoseed('csau_miracle_seal_1'), 1, card.ability.extra.chance) then
					check_for_unlock({ type = "miracle_inherit" })
					new_card:set_seal(pseudorandom_element(pair_seals, pseudoseed('csau_miracle_seal_2')), true)
				end

				if #pair_editions > 0 and SMODS.pseudorandom_probability(card, pseudoseed('csau_miracle_edition_1'), 1, card.ability.extra.chance) then
					check_for_unlock({ type = "miracle_inherit" })
					new_card:set_edition({[pseudorandom_element(pair_editions, pseudoseed('csau_miracle_edition_2'))] = true}, true, true)
				end
			end
		end

		playing_card_joker_effects(new_cards)

		return {
			message = {type = 'variable', key = 'a_plus_card', vars = {#new_cards}},
			colour = G.C.IMPORTANT,
		}
	end
end

return jokerInfo
	