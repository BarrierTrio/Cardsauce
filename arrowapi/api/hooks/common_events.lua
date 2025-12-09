---------------------------
--------------------------- card created context
---------------------------

local ref_create_card = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ...)
    local ret = ref_create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ...)

    SMODS.calculate_context({created_card = ret, area = area})

    if G.GAME.modifiers.consumable_selection_mod and G.GAME.modifiers.consumable_selection_mod ~= 0
    and ret.ability and ret.ability.consumeable and ret.ability.max_highlighted then
        ret.ability.max_highlighted = ret.ability.max_highlighted + G.GAME.modifiers.consumable_selection_mod
    end

    return ret
end





---------------------------
--------------------------- Extra boss support
---------------------------

local ref_background_blind = ease_background_colour_blind
function ease_background_colour_blind(state, blind_override)
    if state == G.STATES.ROUND_EVAL then
        -- reset the table references so the gradients aren't active anymore
        if G.GAME.arrow_gradient_background then
            G.C.BACKGROUND.L = { G.C.BACKGROUND.L[1], G.C.BACKGROUND.L[2], G.C.BACKGROUND.L[3], G.C.BACKGROUND.L[4] }
            G.C.BACKGROUND.D = { G.C.BACKGROUND.D[1], G.C.BACKGROUND.D[2], G.C.BACKGROUND.D[3], G.C.BACKGROUND.D[4] }
            G.C.BACKGROUND.C = { G.C.BACKGROUND.C[1], G.C.BACKGROUND.C[2], G.C.BACKGROUND.C[3], G.C.BACKGROUND.C[4] }
            G.C.BACKGROUND.contrast = G.C.BACKGROUND.contrast
            G.GAME.arrow_gradient_background = nil
        end

        if G.GAME.arrow_gradient_ui then
            G.C.DYN_UI.MAIN = { G.C.DYN_UI.MAIN[1], G.C.DYN_UI.MAIN[2], G.C.DYN_UI.MAIN[3], G.C.DYN_UI.MAIN[4] }
            G.C.DYN_UI.DARK = { G.C.DYN_UI.DARK[1], G.C.DYN_UI.DARK[2], G.C.DYN_UI.DARK[3], G.C.DYN_UI.DARK[4] }
            G.C.DYN_UI.BOSS_MAIN = { G.C.DYN_UI.BOSS_MAIN[1], G.C.DYN_UI.BOSS_MAIN[2], G.C.DYN_UI.BOSS_MAIN[3], G.C.DYN_UI.BOSS_MAIN[4] }
            G.C.DYN_UI.BOSS_DARK = { G.C.DYN_UI.BOSS_DARK[1], G.C.DYN_UI.BOSS_DARK[2], G.C.DYN_UI.BOSS_DARK[3], G.C.DYN_UI.BOSS_DARK[4] }
            G.GAME.arrow_gradient_ui = nil
            ArrowAPI.ui.manual_ui_reload(0)
        end
    elseif G.GAME.blind and G.GAME.blind.in_blind then
        local blind = G.P_BLINDS[G.GAME.blind.config.blind.key]
        local col_primary = blind.boss_colour and blind.boss_colour.colours and blind.boss_colour or nil
        local col_special = blind.special_colour and blind.special_colour.colours and blind.special_colour or nil
        local col_tertiary = blind.tertiary_colour and blind.tertiary_colour.colours and blind.tertiary_colour or nil

        if col_primary or col_special or col_tertiary then
            G.GAME.arrow_gradient_background = true

            if col_primary and col_primary ~= G.C.BACKGROUND.L then
                local predict_primary = ArrowAPI.misc.predict_gradient(col_primary, 0.8)
                ease_value(G.C.BACKGROUND.L, 1, predict_primary[1]*1.3 - G.C.BACKGROUND.L[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 2, predict_primary[2]*1.3 - G.C.BACKGROUND.L[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 3, predict_primary[3]*1.3 - G.C.BACKGROUND.L[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.L = col_primary
						return true
					end
				}))
            elseif blind.boss_colour ~= G.C.BACKGROUND.L then
                ease_value(G.C.BACKGROUND.L, 1, blind.boss_colour[1]*1.3 - G.C.BACKGROUND.L[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 2, blind.boss_colour[2]*1.3 - G.C.BACKGROUND.L[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.L, 3, blind.boss_colour[3]*1.3 - G.C.BACKGROUND.L[3], false, nil, true, 0.8)
            end

            if col_special and col_special ~= G.C.BACKGROUND.C then
                local predict_special = ArrowAPI.misc.predict_gradient(col_special, 0.8)
                ease_value(G.C.BACKGROUND.C, 1, predict_special[1]*1.3 - G.C.BACKGROUND.C[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 2, predict_special[2]*1.3 - G.C.BACKGROUND.C[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 3, predict_special[3]*1.3 - G.C.BACKGROUND.C[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.C = col_special
						return true
					end
				}))
            elseif (blind.special_colour or blind.boss_colour) ~= G.C.BACKGROUND.C then
                col_special = blind.special_colour or blind.boss_colour
                ease_value(G.C.BACKGROUND.C, 1, col_special[1]*0.9 - G.C.BACKGROUND.C[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 2, col_special[2]*0.9 - G.C.BACKGROUND.C[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.C, 3, col_special[3]*0.9 - G.C.BACKGROUND.C[3], false, nil, true, 0.8)
            end

            if col_tertiary and col_tertiary ~= G.C.BACKGROUND.D then
                local predict_tertiary = ArrowAPI.misc.predict_gradient(col_tertiary, 0.8)
                ease_value(G.C.BACKGROUND.D, 1, predict_tertiary[1]*0.4 - G.C.BACKGROUND.D[1], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.D, 2, predict_tertiary[2]*0.4 - G.C.BACKGROUND.D[2], false, nil, true, 0.8)
                ease_value(G.C.BACKGROUND.D, 3, predict_tertiary[3]*0.4 - G.C.BACKGROUND.D[3], false, nil, true, 0.8)
                G.E_MANAGER:add_event(Event({
					trigger = 'after',
					blockable = false,
					blocking = false,
					delay =  0.85,
					func = function()
						G.C.BACKGROUND.D = col_tertiary
						return true
					end
				}))
            elseif (blind.tertiary_colour or blind.boss_colour) ~= G.C.BACKGROUND.D then
                col_tertiary = blind.tertiary_colour or blind.boss_colour
                ease_value(G.C.BACKGROUND.D, 1, col_tertiary[1]*0.4 - G.C.BACKGROUND.D[1], false, nil, true, 0.6)
                ease_value(G.C.BACKGROUND.D, 2, col_tertiary[2]*0.4 - G.C.BACKGROUND.D[2], false, nil, true, 0.6)
                ease_value(G.C.BACKGROUND.D, 3, col_tertiary[3]*0.4 - G.C.BACKGROUND.D[3], false, nil, true, 0.6)
            end

            G.C.BACKGROUND.contrast = blind.contrast or G.C.BACKGROUND.contrast
            return
        end
    end

    -- basically just copies the vanilla logic to replace with the showdown colors
    local blindname = ((blind_override or (G.GAME.blind and G.GAME.blind.name ~= '' and G.GAME.blind.name)) or 'Small Blind')
	blindname = (blindname == '' and 'Small Blind' or blindname)

	for _, v in pairs(G.P_BLINDS) do
		if v.name == blindname and v.boss and v.boss.showdown then
			if G.GAME.blind then
                G.GAME.blind:change_colour()
            end

            ease_background_colour{new_colour = G.C.BLIND.SHOWDOWN_COL_1, special_colour = G.C.BLIND.SHOWDOWN_COL_2, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3}
            return
		end
	end

    return ref_background_blind(state, blind_override)
end

-- evil bad overwrite
function get_new_boss(replace_type)
    G.GAME.perscribed_bosses = G.GAME.perscribed_bosses or {}
    if G.GAME.perscribed_bosses and G.GAME.perscribed_bosses[G.GAME.round_resets.ante] then
        local ret_boss = G.GAME.perscribed_bosses[G.GAME.round_resets.ante]
        G.GAME.perscribed_bosses[G.GAME.round_resets.ante] = nil
        G.GAME.bosses_used[ret_boss] = G.GAME.bosses_used[ret_boss] + 1
        return ret_boss
    elseif G.FORCE_BOSS then return G.FORCE_BOSS end

    replace_type = replace_type or 'Boss'
    local get_showdown = (replace_type == 'Boss' and (G.GAME.modifiers.all_showdown or ((G.GAME.round_resets.ante%G.GAME.win_ante) == 0 and G.GAME.round_resets.ante >= 1)))

    local eligible_bosses = {}
    local num_bosses = 0
    local min_use = 1000

    for k, v in pairs(G.P_BLINDS) do
		local res, options = SMODS.add_to_pool(v)
        options = options or {}

        if res and v.boss and not G.GAME.banned_keys[k] and G.GAME.bosses_used[k] <= min_use then
            if options.ignore_showdown_check or ((get_showdown and v.boss.showdown) or (not get_showdown and not v.boss.showdown and v.boss.min <= math.max(1, G.GAME.round_resets.ante))) then
                if G.GAME.bosses_used[k] < min_use then
                    min_use = G.GAME.bosses_used[k]
                    eligible_bosses = {}
                end
                eligible_bosses[k] = true
                num_bosses = num_bosses + 1
            end
        end
    end

    if num_bosses < 1 then return 'bl_small' end

    local _, boss = pseudorandom_element(eligible_bosses, pseudoseed('boss'))
    G.GAME.bosses_used[boss] = G.GAME.bosses_used[boss] + 1
    return boss
end

local ref_reset_blinds = reset_blinds
function reset_blinds(...)
    local boss_defeated = G.GAME.round_resets.blind_states.Boss == 'Defeated'
    local ret = ref_reset_blinds(...)

    if boss_defeated and G.GAME.modifiers.all_bosses then
        G.GAME.round_resets.blind_choices.Small = get_new_boss('Small')
        G.GAME.round_resets.blind_choices.Big = get_new_boss('Big')
    end

    return ret
end





---------------------------
--------------------------- Force clear main_start and main_end
---------------------------
local ref_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
    local not_full = not full_UI_table
    if not_full then
        if _c.loc_vars and type(_c.loc_vars) == 'function' then
            main_start = nil
            main_end = nil
        end
    end

    return ref_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card, ...)
end





---------------------------
--------------------------- Alternate win conditions
---------------------------

local ref_check_unlock = check_for_unlock
function check_for_unlock(args)
    local ret = ref_check_unlock(args)

    if G.GAME.challenge and G.STATE ~= G.STATES.GAME_OVER then
        local ch = G.CHALLENGES[get_challenge_int_from_id(G.GAME.challenge)]
        if ch.gameover and type(ch.gameover) == 'table' and (ch.gameover.type or args.type) == args.type then
            local gameover = ch.gameover.func(ch)
            if gameover ~= nil then
                ArrowAPI.game.game_over(gameover, true)
            end
        end
    end

    return ret
end