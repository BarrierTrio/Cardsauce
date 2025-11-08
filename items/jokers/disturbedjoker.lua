local jokerInfo = {
	name = 'Disturbed Joker',
	config = {},
	rarity = 1,
	cost = 4,
	unlocked = false,
	blueprint_compat = false,
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
	if context.pre_discard and not card.getting_sliced and not context.blueprint then
		G.GAME.csau_dj_drawextra = true
	end
end

return jokerInfo
