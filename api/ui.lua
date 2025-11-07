-- Mod Icon in Mods tab
SMODS.Atlas({
    key = "modicon",
    path = "arrow_icon.png",
    px = 32,
    py = 32
})

function G.UIDEF.preview_cardarea(preview_num, scale)
    local preview_cards = {}
    local count = 0
    local deck_size = #G.deck.cards

    while count < preview_num and deck_size >= 1 do
        local card = G.deck.cards[deck_size]
        if card then
            table.insert(preview_cards, card)
            count = count + 1
        end
        deck_size = deck_size - 1
    end

    if count < 1 then
        return nil
    end

    local scale = scale or 0.7
    local preview_area = CardArea(
            0, 0,
            (math.min(preview_num, #preview_cards) * G.CARD_W)*scale,
            G.CARD_H*scale,
            {card_limit = #preview_cards, type = 'title', highlight_limit = 0, card_w = G.CARD_W*scale}
    )

    for i=1, #preview_cards do
        local copied_card = copy_card(preview_cards[i], nil, nil, G.playing_card)
        copied_card:hard_set_T(copied_card.T.x, copied_card.T.y, G.CARD_W*scale, G.CARD_H*scale)
        preview_area:emplace(copied_card)
    end

    return {{
        n=G.UIT.R,
        config = {align = "cm", colour = G.C.CLEAR, r = 0.0, padding = 0.5},
        nodes={{
            n=G.UIT.O, config = {object = preview_area}
        }}
    }}
end


local function calc_scale_fac(text, size)
    local size = size or 0.9
    local font = G.LANG.font
    local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
    local calced_text_width = 0
    -- Math reproduced from DynaText:update_text
    for _, c in utf8.chars(text) do
        local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
                + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
        calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
    end
    local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
    return scale_fac
end

-- helper functions for ui generation
ArrowAPI.ui = {
     --- Create dynamic badge for a center based on its 'origin' property
    --- @param center table Center table representing the item
    --- @return table # badge UI tree
    dynamic_badge = function(center, text_scale, maxw)
        local scale_fac = {}
        local min_scale_fac = 2
        local strings = { }
        local badge_colour = HEX('32A852')
        local text_colour = G.C.WHITE

        local mod = center.original_mod or center.mod

        if center.origin then
            if type(center.origin) == 'table' then
                strings[#strings+1] = ' '..localize('ba_'..center.origin.category)..' '
                for _, v in ipairs(center.origin.sub_origins or {}) do
                    strings[#strings+1] = ' '..localize('ba_'..v)..' '
                end

                local color_key = center.origin.custom_color or center.origin.category
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..color_key] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..color_key] or text_colour
            else
                strings[#strings + 1] = ' '..localize('ba_'..center.origin)..' '
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..center.origin] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..center.origin] or text_colour
            end
        end

        for i = 1, #strings do
            scale_fac[i] = calc_scale_fac(strings[i], text_scale)
            min_scale_fac = math.min(min_scale_fac, scale_fac[i])
        end

        local ct = {}
        for i = 1, #strings do
            ct[i] = {
                string = strings[i],
            }
        end

        return {
            n = G.UIT.R,
            config = {
                align = "cm",
                colour = badge_colour,
                id = 'arrow_badge_color_node',
                r = 0.1,
                minw = 1.4/min_scale_fac,
                minh = 0.36,
                emboss = 0.05,
                padding = 0.03 * 0.9,
            },
            nodes = {
                { n = G.UIT.B, config = { h = 0.1, w = 0.01 } },
                {
                    n = G.UIT.O,
                    config = {
                        object = DynaText({
                            string = ct or "ERROR",
                            colours = { text_colour },
                            silent = true,
                            float = true,
                            shadow = true,
                            maxw = maxw,
                            offset_y = -0.03,
                            spacing = 1,
                            scale = 0.33 * (text_scale or 0.9),
                        }),
                    },
                },
                { n = G.UIT.B, config = { h = 0.1, w = 0.01 } },
            },
        }
    end,

    --- Allows Modded Legendaries to show ????? unlock descriptions, but shows the joker_locked_legendary msg on the unlock notifications
    generate_legendary_desc = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table, key)
        key = key or card.config.center.key
        if card.area and card.area == G.jokers or (card.config.center.discovered or card.bypass_discovery_center) then
            -- If statement makes it so that this function doesnt activate in the "Joker Unlocked" UI and cause 'Not Discovered' to be stuck in the corner
            full_UI_table.name = localize{type = 'name', key = key, set = self.set, name_nodes = {}, vars = specific_vars or {}}
        end
        if (specific_vars and not specific_vars.not_hidden) and not (card.config.center.discovered or card.bypass_discovery_center) then
            localize{type = 'unlocks', key = 'joker_locked_legendary', set = 'Other', nodes = desc_nodes, vars = {}}
        else
            localize{type = 'descriptions', key = key, set = self.set, nodes = desc_nodes, vars = (self.loc_vars(self, info_queue, card) and self.loc_vars(self, info_queue, card).vars) or {}}
        end
    end,

    --- Helper function that reloads the main Balatro UI
    --- @param hud_offset number Starting y offset of the hud
    manual_ui_reload = function(hud_offset)
        if G.HUD then G.HUD:remove(); G.HUD = nil end
        if G.HUD_blind then
            -- manually nil out the blind object so this remove call doesn't destroy it unnecessarily
            G.HUD_blind.UIRoot.children[2].children[2].children[1].config.object = nil
            G.HUD_blind:remove();
            G.HUD_blind = nil
        end
        G.HUD = UIBox{
            definition = create_UIBox_HUD(),
            config = {align=('cli'), offset = {x=-0.7,y=0}, major = G.ROOM_ATTACH}
        }
        G.HUD_blind = UIBox{
            definition = create_UIBox_HUD_blind(),
            config = {major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = {x=0,y=hud_offset or -10}, bond = 'Weak'}
        }

        G.hand_text_area = {
            chips = G.HUD:get_UIE_by_ID('hand_chips'),
            mult = G.HUD:get_UIE_by_ID('hand_mult'),
            ante = G.HUD:get_UIE_by_ID('ante_UI_count'),
            round = G.HUD:get_UIE_by_ID('round_UI_count'),
            chip_total = G.HUD:get_UIE_by_ID('hand_chip_total'),
            handname = G.HUD:get_UIE_by_ID('hand_name'),
            hand_level = G.HUD:get_UIE_by_ID('hand_level'),
            game_chips = G.HUD:get_UIE_by_ID('chip_UI_count'),
            blind_chips = G.HUD_blind:get_UIE_by_ID('HUD_blind_count'),
            blind_spacer = G.HUD:get_UIE_by_ID('blind_spacer')
        }
    end,

    -- A table of badge_colors. Backgrounds are prefixed with `co_`, text is prefixed with `te_`
    badge_colors = {
        ArrowAPI = {
            co_rlm = HEX('FFFFFF'),
            te_rlm = HEX('b1212a'),

            -- badge colors for jojo parts
            co_jojo = G.C.STAND,
            te_jojo = HEX('FFFFFF'),
            co_diamond = HEX('BEE5E5'),
            te_diamond = HEX('C479BE'),
            co_stone = HEX('0076b2'),
            te_stone = HEX('97c348'),
            co_lion = HEX('dcf5fc'),
            te_lion = HEX('7832c4'),
        },
    },

    add_badge_colors = function(mod, args)
        ArrowAPI['ui']['badge_colors'][mod.id] = copy_table(args)
    end
}

local function recursive_text_tint(ui_tree, color, percentage)
	if ui_tree.n == G.UIT.T then
		ui_tree.config.colour = mix_colours(ui_tree.config.colour, color, percentage or 0.5)
		return
	elseif ui_tree.n == G.UIT.O then
		ui_tree.config.object.colours = {mix_colours(ui_tree.config.object.colours[1], color, percentage or 0.5)}
		return
	end

	for _, v in ipairs(ui_tree.nodes or {}) do
		recursive_text_tint(v, color, percentage)
	end
end

local ref_ach_tab = buildAchievementsTab
function buildAchievementsTab(mod, current_page)
    local is_arrow_mod = false
    for _, x in ipairs(mod.dependencies or {}) do
        for _, y in ipairs(x) do
            if y.id == 'ArrowAPI' then
                is_arrow_mod = true
                break
            end
        end

        if is_arrow_mod then break end
    end

    if not is_arrow_mod then
        return ref_ach_tab(mod, current_page)
    end

    current_page = current_page or 1
    fetch_achievements()
    local num_per_row = 6
	local num_rows = 2
	local num_per_page = num_per_row * num_rows
    local achievements_pool = {}
    for _, v in pairs(G.ACHIEVEMENTS) do
        if v.mod and v.mod.id == mod.id then achievements_pool[#achievements_pool+1] = v end
    end

    table.sort(achievements_pool, function(a, b)
        local a_rarity = a.rarity or 0
        local b_rarity = b.rarity or 0

        if a_rarity ~= b_rarity then
            return a_rarity < b_rarity
        end

        local a_order = a.order or 1
        local b_order = b.order or 1
        if a_order ~= b_order then
            return a_order < b_order
        end

		return false
	end)

	local current_rarity = achievements_pool[1].rarity
	local achievement_pages = {}
	local page = 1
	local page_index = 1
	for i = 1, #achievements_pool do
		if not achievement_pages[page] then
			achievement_pages[page] = {rarity = current_rarity, start_index = i}
		end

		local next_page = false
		if i == #achievements_pool then
			achievement_pages[page].stop_index = i
			break
		elseif achievements_pool[i+1].rarity > current_rarity then
			current_rarity = current_rarity + 1
			next_page = true
		elseif not next_page and page_index >= num_per_page then
			next_page = true
		end

		if next_page then
			achievement_pages[page].stop_index = i
			page = page + 1
			page_index = 1
		else
			page_index = page_index + 1
		end
	end

    local row = 1
	local page_info = achievement_pages[current_page]
	local title_color = G.C[string.upper(mod.prefix)..'_ACH_RARE_'..page_info.rarity] or mod.badge_colour
	local achievement_matrix = {{},{}}
    for i = page_info.start_index, page_info.stop_index do
        local ach = achievements_pool[i]
        if not ach then break end

        local ach_sprite = Sprite(0, 0, 1.1, 1.1, G.ASSET_ATLAS[ach.atlas or "achievements"], ach.earned and ach.pos or ach.hidden_pos)
        ach_sprite:define_draw_steps({
            {shader = 'dissolve', shadow_height = 0.05},
            {shader = 'dissolve'}
        })
        if i == 1 then
            G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                G.CONTROLLER:snap_to{node = ach_sprite}
                return true
            end)
            }))
        end
        ach_sprite.float = true
        ach_sprite.states.hover.can = true
        ach_sprite.states.drag.can = false
        ach_sprite.states.collide.can = true
        ach_sprite.hover = function()
            if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                if not ach_sprite.hovering and ach_sprite.states.visible then
                    ach_sprite.hovering = true
                    ach_sprite.hover_tilt = 1.5
                    ach_sprite:juice_up(0.05, 0.02)
                    play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                    Node.hover(ach_sprite)
                    if ach_sprite.children.alert then
                        ach_sprite.children.alert:remove()
                        ach_sprite.children.alert = nil
                        ach.alerted = true
                        G:save_progress()
                    end
                end
            end
        end

		ach_sprite.stop_hover = function()
			ach_sprite.hovering = false
			Node.stop_hover(ach_sprite)
			ach_sprite.hover_tilt = 0
		end

        -- Description
		local name_nodes
		local desc_nodes = { }

		local loc_vars = {}
		if ach.loc_vars and type(ach.loc_vars) == 'function' then
			loc_vars = ach:loc_vars()
		end

        local badge_colour = mod.badge_colour
        local text_colour = G.C.WHITE
        local text = ''
		if ach.origin then
            if type(ach.origin) == 'table' then
                text = ' '..((ach.origin.sub_origins or {})[1] and localize('ba_'..ach.origin.sub_origins[1]) or ach.origin.category)..' '

                local color_key = ach.origin.custom_color or ach.origin.category
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..color_key] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..color_key] or text_colour
            else
                text = ' '..localize('ba_'..ach.origin)..' '
                badge_colour = ArrowAPI.ui.badge_colors[mod.id]['co_'..ach.origin] or badge_colour
                text_colour = ArrowAPI.ui.badge_colors[mod.id]['te_'..ach.origin] or text_colour
            end
        end

		local key = ach.key..(G.localization.descriptions.Achievements[ach.key..'_hidden'] and not ach.earned and '_hidden' or '')
		local name_text = localize{type = 'name_text', key = key, set = 'Achievements', vars = loc_vars.vars}
        name_nodes = localize{type = 'name', key = key, set = 'Achievements', vars = loc_vars.vars, colors = loc_vars.vars and loc_vars.vars.colours, scale = math.min(0.48, calc_scale_fac(name_text))}
		localize{type = 'descriptions', key = key, set = "Achievements", vars = loc_vars.vars, colors = loc_vars.vars and loc_vars.vars.colours, nodes = desc_nodes, scale = 0.95}

		local desc = {}
		for _, desc_row in ipairs(desc_nodes) do
			desc[#desc+1] = {n=G.UIT.R, config={align = "cm"}, nodes=desc_row}
		end

		recursive_text_tint({nodes = name_nodes}, title_color, ach.earned and 0 or 0.6)
		if not ach.earned then
			recursive_text_tint({nodes = desc}, G.C.WHITE, 0.5)
		end

        local badge_scale = 0.9 * math.min(0.25, calc_scale_fac(text))

        table.insert(achievement_matrix[row], {
            n = G.UIT.C,
            config = { align = "cm", padding = 0.05 },
            nodes = {
                {n=G.UIT.R, config = {align = "cm", colour = not ach.earned and G.C.UI.BACKGROUND_INACTIVE or G.C.WHITE, r = 0.1, emboss = 0.05}, nodes = {
                    {n=G.UIT.R, config = {align = "cm", minw = 2.6, maxw = 2.6, padding = 0.025}, nodes = {
                        {n=G.UIT.R, config={align = "cm", maxw = 2.5, minw =  2.5, padding = 0.025}, nodes = name_nodes},
                        {n=G.UIT.R, config = {align = "cm", maxw = 2.5, minw =  2.5, padding = 0.05}, nodes =
                            {{ n = G.UIT.O, config = { object = ach_sprite, focus_with_object = true }}}
                        },
						{n=G.UIT.R, config={align = "cm", r = 0.1, emboss = 0.025, minh = 1.05, maxh = 1.05, filler = true, main_box_flag = true}, nodes={
							{n=G.UIT.R, config={align = "cm", maxw = 2, padding = 0.025 }, nodes=desc}
						}},
                        {n=G.UIT.R, config={align = "cm", padding = 0.05 }, nodes={
                            {n = G.UIT.R, config = { align = "cm", colour = badge_colour, minh = 0.35, maxh = 0.35, maxw = 2.5, minw =  2.5, r = 0.1, emboss = 0.05, padding = 0.05}, nodes = {
                                {n=G.UIT.T, config={text = text, shadow = true, colour = text_colour, align = "cm", scale = badge_scale, maxw = 2, padding = 0.025}, nodes=desc}
                            }}
                        }}
					}},
                }},
            },
        })
        if #achievement_matrix[row] == num_per_row then
            row = row + 1
            max_lines = 2
        end
    end

    local achievements_options = {}
    for i = 1, #achievement_pages do
        table.insert(achievements_options, localize('k_page')..' '..tostring(i)..'/'..tostring(#achievement_pages))
    end

	-- needs localization for "Achievments"
	local title = page_info.rarity > 0 and localize(mod.prefix..'_ach_rare_'..page_info.rarity) or nil

    local t = {{n=G.UIT.C, config={align = "cm", minw = 15}, nodes={
        {n=G.UIT.C, config={align = "cm"}, nodes={
        	{n=G.UIT.R, config={align = "cm"}, nodes={
				title and {n=G.UIT.R, config={align = "tm", minh = 0.6 }, nodes = {
					{n=G.UIT.R, config={align = "cm", colour = title_color, r = 0.1, shadow = true, minw = 7.5, minh = 0.5 }, nodes = {
						{n=G.UIT.T, config = {align = "cm", text = title, scale = 0.48}}
					}}
				}} or nil,
            	{n=G.UIT.R, config={align = "tm", padding = 0.05, minh = 3.15 }, nodes=achievement_matrix[1]},
            	{n=G.UIT.R, config={align = "tm", padding = 0.05, minh = 3.15 }, nodes=achievement_matrix[2]},
            	not title and {n=G.UIT.R, config={align = "tm", minh = 1 }, nodes = {}} or nil,
				create_option_cycle({options = achievements_options, w = 4.5, cycle_shoulders = true, opt_callback = 'achievments_tab_page', focus_args = {snap_to = true, nav = 'wide'}, current_option = current_page, colour = G.C.RED})
        	}}
        }}
    }}}
    return {
        n = G.UIT.ROOT,
        config = {
            emboss = 0.05,
            minh = 6,
            r = 0.1,
            minw = 9,
            align = "tm",
            padding = 0.2,
            colour = G.C.BLACK
        },
        nodes = t
    }
end