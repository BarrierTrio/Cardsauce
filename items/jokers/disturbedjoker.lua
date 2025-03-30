local jokerInfo = {
	name = 'Disturbed Joker',
	config = {},
	rarity = 1,
	cost = 4,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.check_for_unlock(self, args)
	if args.type == "flip_sosad" then
		return true
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_disturbed" })
end

function jokerInfo.calculate(self, card, context)
	if context.pre_discard and not card.getting_sliced and not context.blueprint then
		G.GAME.csau_dj_drawextra = true
	end
end

return jokerInfo
	