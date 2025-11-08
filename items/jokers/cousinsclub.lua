local jokerInfo = {
	name = "Cousin's Club",
	config = {
		extra = {
			chips = 0,
			chip_mod = 1
		}
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chips, card.ability.extra.chip_mod, localize(G.GAME and G.GAME.wigsaw_suit or "Clubs", 'suits_singular'), colours = {G.C.SUITS[G.GAME and G.GAME.wigsaw_suit or "Clubs"]}} }
end

function jokerInfo.calculate(self, card, context)
	if context.individual and context.cardarea == G.play and not card.debuff and not context.blueprint and context.other_card:is_suit(G.GAME and G.GAME.wigsaw_suit or "Clubs") then
		local chip = to_big(card.ability.extra.chip_mod)
		if next(context.poker_hands['Flush']) then
			chip = to_big(chip) * to_big(2)
		end
		card.ability.extra.chips = to_big(card.ability.extra.chips) + to_big(chip)
		return {
			extra = {focus = card, message = next(context.poker_hands['Flush']) and localize('k_upgrade_double_ex') or localize('k_upgrade_ex'), colour = G.C.CHIPS},
			card = card
		}
	end
	if context.joker_main and context.cardarea == G.jokers and to_big(card.ability.extra.chips) > to_big(0) then
		return {
			message = localize{type='variable',key='a_chips',vars={to_big(card.ability.extra.chips)}},
			chip_mod = card.ability.extra.chips,
			colour = G.C.CHIPS
		}
	end
end



return jokerInfo
