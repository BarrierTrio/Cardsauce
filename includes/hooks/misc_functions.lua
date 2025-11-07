-- TODO: use Arrow color APIs to add mug color

-- TODO: maintain this function if it already doesn't exist via jojobal
--- Resets the rank used by the Paper Moon King stand card
function csau_reset_paper_rank()
    G.GAME.current_round.paper_rank = 'Jack'
	local valid_ranks = {}
    for _, rank in pairs(SMODS.Ranks) do
        if rank.face then valid_ranks[#valid_ranks+1] = rank.key end
    end
	G.GAME.current_round.paper_rank = pseudorandom_element(valid_ranks, pseudoseed('papermoon'..G.GAME.round_resets.ante))
end

-- TODO: move fibonacci calculation to arrow

-- TODO: replace stand win sticker stuff with its behavior in arrow

-- TODO: replace stand profile progress with upcoming SMODS doing this automatically
-- probably not a lot of work to be done, but w/e

local ref_alert_space = alert_no_space
alert_no_space = function(card, area)
	if card.config.center.key == 'j_csau_ufo' then
		G.CONTROLLER.locks.no_space = true
		attention_text({
			scale = 0.9, text = localize('k_ufo_alert'), hold = 0.9, align = 'cm',
			cover = area, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.7)
		})
		card:juice_up(0.3, 0.2)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.06*G.SETTINGS.GAMESPEED,
			blockable = false,
			blocking = false,
			func = function()
				play_sound('tarot2', 0.76, 0.4);
				return true
			end
		}))
		play_sound('tarot2', 1, 0.4)

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5*G.SETTINGS.GAMESPEED,
			blockable = false,
			blocking = false,
			func = function()
				G.CONTROLLER.locks.no_space = nil
				return true
			end
		}))
		return
	end

	return ref_alert_space(card, area)
end