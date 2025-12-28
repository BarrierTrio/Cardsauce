--- Resets the rank used by the Paper Moon King stand card
function jojobal_reset_paper_rank()
    G.GAME.current_round.jojobal_paper_rank = 'Jack'
	local valid_ranks = {}
    for _, rank in pairs(SMODS.Ranks) do
        if rank.face then valid_ranks[#valid_ranks+1] = rank.key end
    end
	G.GAME.current_round.jojobal_paper_rank = pseudorandom_element(valid_ranks, pseudoseed('papermoon'..G.GAME.round_resets.ante))
end

local ref_alert_space = alert_no_space
function alert_no_space(card, area)
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


---------------------------
--------------------------- Wigsaw hooks
---------------------------

local ref_localize = localize
function localize(args, misc_cat)
	if type(args) ~= 'table' and misc_cat == 'suits_singular' or misc_cat == 'suits_plural' then
		args = G.GAME.wigsaw_suit or args
	end
	return ref_localize(args, misc_cat)
end





---------------------------
--------------------------- pool modification
---------------------------

local ref_current_pool = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append, ...)
	local pool, key = ref_current_pool(_type, _rarity, _legendary, _append, ...)

	local frich = _type == 'Food' and next(SMODS.find_card('j_csau_frich'))
	if G.GAME.starting_params.csau_jokers_rate or G.GAME.starting_params.csau_all_rate or frich then
		local new_pool = {}
		for _, v in ipairs(pool) do
			local rate = frich and 2 or 1
			local center = G.P_CENTERS[v]
			if center.original_mod and center.original_mod.id == 'cardsauce'
			and (G.GAME.starting_params.csau_all_rate or (center and center.set == 'Joker')) then
				rate = rate * (G.GAME.starting_params.csau_jokers_rate or 1) * (G.GAME.starting_params.csau_all_rate or 1)
			end

			for i=1, rate-1 do
				new_pool[#new_pool+1] = v
			end
		end

		return new_pool, key
	end

	return pool, key
end