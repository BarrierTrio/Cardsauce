local jokerInfo = {
	name = 'Disturbed Joker',
	atlas = 'jokers',
	pos = {x = 2, y = 7},
	config = {
		extra = {
			num_cards = 1,
			draw_this_discard = false
		}
	},
	rarity = 1,
	cost = 4,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	streamer = "vinny",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	if args.type == "flip_sosad" then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.pre_discard then
		card.ability.extra.draw_this_discard = true
	end

	if context.hand_drawn then
		card.ability.extra.draw_this_discard = false
	end

	if context.drawing_cards then
		return {
			amount = context.amount + card.ability.extra.num_cards
		}
	end
end

return jokerInfo
