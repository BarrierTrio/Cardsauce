local jokerInfo = {
	name = 'Wings of Time',
	config = {},
	rarity = 3,
	cost = 10,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	hasSoul = true,
	streamer = "vinny",
	artist = 'GuffNFluff'
}

function jokerInfo.check_for_unlock(self, args)
	if args.type == "unlock_epoch" then
		return true
	end
end

function jokerInfo.in_pool(self, args)
	if not G.GAME.pool_flags.wingsoftimeused then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.blueprint then return end

	if context.game_over and to_big(G.GAME.chips)/to_big(G.GAME.blind.chips) >= to_big(0.23) then
		if SMODS.find_card('j_csau_wingsoftime')[1] ~= card then
			return
		end

		check_for_unlock({ type = "activate_wot" })
		return {
			saved = 'ph_saved_wings',
			colour = G.C.RED,
			extra = {
				func = function()
					G.E_MANAGER:add_event(Event({
						func = function()
							G.hand_text_area.blind_chips:juice_up()
							G.hand_text_area.game_chips:juice_up()
							play_sound('tarot1')
							card:start_dissolve()
							ante_dec = G.GAME.round_resets.ante - 1
							ease_ante(-ante_dec)
							G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
							G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante-ante_dec
							ease_dollars(-to_big(G.GAME.dollars), true)
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
								if to_big(v.level) > to_big(1) then
									level_up_hand(self, k, true, to_big(-G.GAME.hands[k].level) + to_big(1))
								end
							end
							update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 1.8}, {mult = 0, chips = 0, handname = '', level = ''})
							G.GAME.pool_flags.wingsoftimeused = true
							return true
						end
					}))
				end
			}
		}
	end
end

return jokerInfo