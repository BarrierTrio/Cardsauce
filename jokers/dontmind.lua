local jokerInfo = {
	name = "Don't Mind If I Do",
	config = {},
	rarity = 2,
	cost = 4,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist9", set = "Other"}
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_dontmind" })
	ach_jokercheck(self, ach_checklists.high)
end

function jokerInfo.calculate(self, card, context)
	if context.skip_blind then
		for i, tag in ipairs(G.GAME.tags) do
			if tag.name == "tag_orbital" and tag.ability.orbital_hand == "High Card" then
				G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.3, blockable = false, blocking = true,
					func = function()
						card:juice_up()
						card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_dontmind"), colour = G.C.BLUE, instant = true})
						return true
					end
				}))
			end
		end
	end
	if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Planet' and context.consumeable.ability.name == 'Pluto' then
		G.E_MANAGER:add_event(Event({trigger = 'before', delay = 0.3, blockable = false, blocking = true,
			func = function()
				card:juice_up()
				card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_dontmind"), colour = G.C.BLUE, instant = true})
				return true
			end
		}))
	end
end

return jokerInfo