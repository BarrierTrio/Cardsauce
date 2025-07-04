local jokerInfo = {
	name = 'Emmanuel Blast',
	config = {
		extra = 8
	},
	rarity = 1,
	cost = 4,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = G.P_TAGS.tag_negative
	info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gappie } }
	return { vars = {SMODS.get_probability_vars(card, 1, card.ability.extra)} }
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not card.debuff and not context.individual and not context.repetition then
		if SMODS.pseudorandom_probability(card, pseudoseed('csau_blast'), 1, card.ability.extra) then
			check_for_unlock({ type = "activate_eman" })
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_negative'), colour = HEX('39484e')})
			G.E_MANAGER:add_event(Event({
				trigger = 'before',
				blocking = false,
				func = (function()
					add_tag(Tag('tag_negative'))
					play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
					play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
					return true
				end)
			}))
		end
		return
	end
end



return jokerInfo
	