local jokerInfo = {
	name = 'Wings of Time',
	atlas = 'jokers',
	pos = {x = 1, y = 5},
	soul_pos = {x = 2, y = 5},
	config = {},
	rarity = 3,
	cost = 10,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
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

							ArrowAPI.game.batch_level_up(card, G.handlist, 0)

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