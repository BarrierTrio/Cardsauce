local jokerInfo = {
	name = 'Rekoj Gnorts',
	config = {},
	rarity = 1,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_gnorts" })
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
	info_queue[#info_queue+1] = {key = "guestartist7", set = "Other"}
end

return jokerInfo
	