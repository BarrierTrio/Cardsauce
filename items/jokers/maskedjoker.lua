local jokerInfo = {
	name = 'Masked Joker',
	atlas = 'jokers',
	pos = {x = 7, y = 3},
	config = {
		extra = {
			chips = 29,
			mult = 16,
			ach_count = 5,
			enhancement = 'm_steel'
		}
	},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS[card.ability.extra.enhancement]
	return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.in_pool(self, args)
	if not G.playing_cards then return true end
	for _, v in ipairs(G.playing_cards) do
		if v.config.center.key == self.config.extra.enhancement then
			return true
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.before and not context.blueprint then
		card.ability.csau_masked_steel_tally = 0
		for _, v in ipairs(context.full_hand) do
			if SMODS.has_enhancement(v, card.ability.extra.enhancement) then
				card.ability.csau_masked_steel_tally = card.ability.csau_masked_steel_tally + 1
			end
		end
	end

	if context.individual and context.cardarea == G.play and to_big(card.ability.csau_masked_steel_tally) >= #context.full_hand then
		if to_big(card.ability.csau_masked_steel_tally) >= to_big(card.ability.extra.ach_count) then
			check_for_unlock({ type = "activate_claus" })

			if next(SMODS.find_card('j_csau_chromedup')) then
				check_for_unlock({ type = "ult_choomera" })
			end
		end

		return {
			chips = card.ability.extra.chips,
			mult = card.ability.extra.mult,
			card = card
		}
	end
end



return jokerInfo

