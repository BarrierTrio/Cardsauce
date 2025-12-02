local jokerInfo = {
	name = 'Fisheye',
	atlas = 'jokers',
	pos = {x = 2, y = 3},
	config = {
		extra = {
			chips = 15
		}
	},
	rarity = 1,
	cost = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}


function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.chips} }
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_chips',vars={to_big(card.ability.extra.chips)}},
			chip_mod = card.ability.extra.chips,
			colour = G.C.CHIPS
		}
	end
end


return jokerInfo
