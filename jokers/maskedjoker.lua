local jokerInfo = {
	name = 'Masked Joker',
	config = {
		extra = {
			chips = 29,
			mult = 16
		}
	},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_CENTERS.m_steel
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
	return { vars = {card.ability.extra.chips, card.ability.extra.mult}}
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_claus" })
end

function jokerInfo.in_pool(self, args)
	for _, v in ipairs(G.playing_cards) do
		if v.ability.effect == "Steel Card" then
			return true
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not card.debuff then
		local chimera = true
		for k, v in ipairs(context.full_hand) do
			chimera = chimera and v.ability.name == 'Steel Card'
		end
		if not chimera then
			return nil
		end
		return {
			chips = card.ability.extra.chips,
			mult = card.ability.extra.mult,
			card = card
		}
	end
end



return jokerInfo
	