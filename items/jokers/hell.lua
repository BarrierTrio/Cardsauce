local jokerInfo = {
	name = 'Running Hell',
	config = {
		extra = 1
	},
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "other",
}

local cavestorytext = SMODS.Sound({
	key = "cavestorytext",
	path = "cavestorytext.wav"
})

local function hand_level_reset(card, delayMod)
	delayMod = delayMod or 1
	update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3/delayMod}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2/delayMod, func = function()
		play_sound('tarot1')
		card:juice_up(0.8, 0.5)
		G.TAROT_INTERRUPT_PULSE = true
		return true end }))
	update_hand_text({delay = 0}, {mult = '-', StatusText = true})
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9/delayMod, func = function()
		play_sound('tarot1')
		card:juice_up(0.8, 0.5)
		return true end }))
	update_hand_text({delay = 0}, {chips = '-', StatusText = true})
	G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9/delayMod, func = function()
		play_sound('tarot1')
		card:juice_up(0.8, 0.5)
		G.TAROT_INTERRUPT_PULSE = nil
		return true end }))
	update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='1'})
	delay(1.3/delayMod)
	for k, v in pairs(G.GAME.hands) do
		if v.level > 1 then
			level_up_hand(self, k, true, -G.GAME.hands[k].level + 1)
		end
	end
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 1.8,
		blockable = false,
		func = (function()
			play_area_status_text(localize('k_cavestorytext'))
			cavestorytext:play(1, (G.SETTINGS.SOUND.volume/100.0) * (G.SETTINGS.SOUND.game_sounds_volume/50.0),true);
			update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
			return true
		end)
	}))
end

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

function jokerInfo.add_to_deck(self, card, context)
	check_for_unlock({ type = "discover_hell" })
	hand_level_reset(card, G.SETTINGS.GAMESPEED)
	return
end

function jokerInfo.calculate(self, card, context)
	if context.repetition and not card.debuff then
		if context.cardarea == G.play then
			return {
				message = localize('k_again_ex'),
				repetitions = card.ability.extra,
				card = card
			}
		end
		if context.cardarea == G.hand then
			if (next(context.card_effects[1]) or #context.card_effects > 1) then
				return {
					message = localize('k_again_ex'),
					repetitions = card.ability.extra,
					card = card
				}
			end
		end
	end
	if context.end_of_round and G.GAME.blind.boss and not context.blueprint then
		local reset = false
		for k, v in pairs(G.GAME.hands) do
			if v.level > 1 then reset = true end
		end
		if reset then
			hand_level_reset(card)
		end
	end
end

return jokerInfo
	