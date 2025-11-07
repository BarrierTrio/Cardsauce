local ref_can_buy = G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
    local ret = ref_can_buy(e)
    if e.config.ref_table.ability.set=='VHS' then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
    return ret
end

-- Modified Code from Malverk
local ref_use_sell_buttons = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    if card.ability.set == "VHS" then
        if (card.area == G.pack_cards and G.pack_cards) and card.ability.consumeable then --Add a use button
            use = {n=G.UIT.R, config={align = 'cm'}, nodes={
                {n=G.UIT.C, config={align = "cm"}, nodes={
                    {n=G.UIT.C, config={align = "bm", maxw = G.CARD_W * 0.65, shadow = true, padding = 0.1, r=0.08, minw = 0.5 * G.CARD_W, minh = 0.8, hover = true, colour = G.C.GREEN, button = "use_card", func = "can_select_from_booster", ref_table = card}, nodes={
                        {n=G.UIT.T, config={text = localize('b_select'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                    }}
                }}
            }}
            local t = {n=G.UIT.ROOT, config = {align = 'cm', padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={align = 'cm'}, nodes={
                    use,
                }},
            }}
            return t
        end
    end

    if card.ability.set == "Stand" then
        if (card.area == G.pack_cards and G.pack_cards) then
            return {n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.3*card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'use_card', func = 'can_select_from_booster'}, nodes={
                    {n=G.UIT.T, config={text = localize('b_select'),colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
                }},
            }}
        end
        local sell = {n=G.UIT.C, config={align = "cr"}, nodes={
            {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'sell_card', func = 'can_sell_card'}, nodes={
                {n=G.UIT.B, config = {w=0.1,h=0.6}},
                {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                        {n=G.UIT.T, config={text = localize('b_sell'),colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
                    }},
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.T, config={text = localize('$'),colour = G.C.WHITE, scale = 0.4, shadow = true}},
                        {n=G.UIT.T, config={ref_table = card, ref_value = 'sell_cost_label',colour = G.C.WHITE, scale = 0.55, shadow = true}}
                    }}
                }}
            }},
        }}
        local t = {
            n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config={padding = 0.15, align = 'cl'}, nodes={
                    {n=G.UIT.R, config={align = 'cl'}, nodes={
                        sell
                    }},
                }},
            }}
        return t
    end
    return ref_use_sell_buttons(card)
end


---------------------------
--------------------------- The Creek score modifiers
---------------------------

local ref_uibox_blind = create_UIBox_blind_popup
function create_UIBox_blind_popup(...)
    local ret = ref_uibox_blind(...)

    local args = { ... }
    local blind = args[1]
    local discovered = args[2]

    if discovered and blind.special_colour then
        local ability_text = ret.nodes[2].nodes[1].nodes[4]
        if ability_text then
            ability_text.config.colour = blind.special_colour
        end
    end

    return ret
end

local ref_blind_choice = create_UIBox_blind_choice
function create_UIBox_blind_choice(...)
    local ret = ref_blind_choice(...)

    local args = { ... }
    local type = args[1]
    if G.P_BLINDS[G.GAME.round_resets.blind_choices[type]].score_invisible then
        local info_node = ret.nodes[1].nodes[3].nodes[1].nodes[2]
        info_node.config.colour = G.C.CLEAR
        info_node.nodes = {}
    end

    return ret
end

---------------------------
--------------------------- Multi line attention text support
---------------------------

local ref_attention_text = attention_text
function attention_text(args)
    if not args or not args.text or (args.text and type(args.text) ~= 'table') then
        return ref_attention_text(args)
    end

    args.scale = args.scale or 1
    args.colour = SMODS.shallow_copy(args.colour or G.C.WHITE)
    args.hold = (args.hold or 0) + 0.1*(G.SPEEDFACTOR)
    args.pos = args.pos or {x = 0, y = 0}
    args.align = args.align or 'cm'
    args.emboss = args.emboss or nil
    args.fade = 1

    if args.cover then
        args.cover_colour = SMODS.shallow_copy(args.cover_colour or G.C.RED)
        args.cover_colour_l = SMODS.shallow_copy(lighten(args.cover_colour, 0.2))
        args.cover_colour_d = SMODS.shallow_copy(darken(args.cover_colour, 0.2))
    else
        args.cover_colour = copy_table(G.C.CLEAR)
    end

    args.uibox_config = {
        align = args.align or 'cm',
        offset = args.offset or {x=0,y=0},
        major = args.cover or args.major or nil,
    }

    local nodes = {}
    for _, line in ipairs(args.text) do
        nodes[#nodes+1] = {{
            n=G.UIT.C,
            config={align = "m"},
            nodes={{
                n=G.UIT.O,
                config={
                    object = DynaText({
                        string = line,
                        colours = {args.colour},
                        silent = not args.noisy,
                        pop_in = 0,
                        pop_in_rate = 6,
                        rotate = args.rotate or nil,
                        maxw = args.maxw,
                        float = true,
                        shadow = true,
                        scale = args.scale
                    })
                }
            }}
        }}
    end

    local final_text = {
        n=G.UIT.ROOT,
        config = {
            align = args.cover_align or 'cm',
            minw = (args.cover and args.cover.T.w or 0.001) + (args.cover_padding or 0),
            minh = (args.cover and args.cover.T.h or 0.001) + (args.cover_padding or 0),
            padding = 0.03,
            r = 0.1,
            emboss = args.emboss,
            colour = args.cover_colour
        },
        nodes={}
    }

    for _, line in ipairs(nodes) do
        final_text.nodes[#final_text.nodes+1] = {n=G.UIT.R, config={align = "m"}, nodes=line}
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            args.AT = UIBox{
                T = {args.pos.x,args.pos.y, 0, 0},
                definition = final_text,
                config = args.uibox_config
            }
            args.AT.attention_text = true

            args.text = args.AT.UIRoot.children
            for _, v in ipairs(args.text) do
                v.children[1].children[1].config.object:pulse(0.5)
            end

            if args.cover then
            Particles(args.pos.x,args.pos.y, 0,0, {
                timer_type = 'TOTAL',
                timer = 0.01,
                pulse_max = 15,
                max = 0,
                scale = 0.3,
                vel_variation = 0.2,
                padding = 0.1,
                fill=true,
                lifespan = 0.5,
                speed = 2.5,
                attach = args.AT.UIRoot,
                colours = {args.cover_colour, args.cover_colour_l, args.cover_colour_d},
            })
            end
            if args.backdrop_colour then
            args.backdrop_colour = SMODS.shallow_copy(args.backdrop_colour)
            Particles(args.pos.x,args.pos.y,0,0,{
                timer_type = 'TOTAL',
                timer = 5,
                scale = 2.4*(0.75 + 0.25 * #args.text),
                lifespan = 5,
                speed = 0,
                attach = args.AT,
                colours = {args.backdrop_colour}
            })
            end
            return true
        end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = args.hold,
        blockable = false,
        blocking = false,
        func = function()
            if not args.start_time then
                args.start_time = G.TIMERS.TOTAL
                for _, v in ipairs(args.text) do
                    v.children[1].children[1].config.object:pop_out(3)
                end
            else
                --args.AT:align_to_attach()
                args.fade = math.max(0, 1 - 3*(G.TIMERS.TOTAL - args.start_time))
                if args.cover_colour then args.cover_colour[4] = math.min(args.cover_colour[4], 2*args.fade) end
                if args.cover_colour_l then args.cover_colour_l[4] = math.min(args.cover_colour_l[4], args.fade) end
                if args.cover_colour_d then args.cover_colour_d[4] = math.min(args.cover_colour_d[4], args.fade) end
                if args.backdrop_colour then args.backdrop_colour[4] = math.min(args.backdrop_colour[4], args.fade) end
                args.colour[4] = math.min(args.colour[4], args.fade)
                if args.fade <= 0 then
                    args.AT:remove()
                    return true
                end
            end
        end
    }))
end





---------------------------
--------------------------- Custom Challenge display behavior
---------------------------

local ref_challenge_desc = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
    local ret = ref_challenge_desc(args)

    local ch = G.CHALLENGES[args._id]
    if args._tab == 'Rules' and G.localization.descriptions.Challenge[ch.key] then
        ret.nodes[1].nodes[1].config.minw = 2.5
        local custom_rules = (ch.rules and ch.rules.custom and next(ch.rules.custom)) or false
        local rule_node = ret.nodes[1].nodes[1].nodes[2]
        rule_node.config.minw = custom_rules and 3.65 or 3.8
        rule_node.config.maxw = custom_rules and 3.65 or 3.8
        rule_node.config.minh = custom_rules and 4 or 4.1
        ret.nodes[1].nodes[1].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", padding = custom_rules and 0.05 or 0, colour = G.C.WHITE, r = 0.1 },
            nodes = { rule_node }
        }

        ret.nodes[1].nodes[2].config.minw = 1.75
        local modifier_node = ret.nodes[1].nodes[2].nodes[2]
        modifier_node.config.minw = 2.3
        modifier_node.config.maxw = 2.3
        modifier_node.config.minh = 4.1
        ret.nodes[1].nodes[2].nodes[2] = {
            n = G.UIT.R,
            config = {align = "cm", colour = G.C.WHITE, r = 0.1 },
            nodes = { modifier_node }
        }

        local story_text = {{}}
        localize{type = 'descriptions', set = 'Challenge', key = ch.key, nodes = story_text[#story_text], text_colour = G.C.BLACK }
        story_text[#story_text] = desc_from_rows(story_text[#story_text], nil, 4.2)
        story_text[#story_text].config.colour = G.C.CLEAR
        if not next(story_text[#story_text].nodes) then
            story_text[#story_text].nodes[1] = {n = G.UIT.T, config = { align = "cm", text = ''}}
        end

        local story_node = {n=G.UIT.C, config={align = "cm", minw = 3, r = 0.1, colour = G.C.BLUE}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.08, minh = 0.6}, nodes={
                {n=G.UIT.T, config={text = localize('k_challenge_story'), scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.075, colour = G.C.WHITE, r = 0.1 }, nodes={
                ch.origin and ArrowAPI.ui.dynamic_badge(ch) or nil,
                {n = G.UIT.R, config = {align = "cm", minh = ch.origin and 3.45 or 3.95, minw = 4.4, maxw = 4.4, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes = story_text}
            }},
        }}

        table.insert(ret.nodes[1].nodes, 1, story_node)
    end

    if args._tab == 'Restrictions' and ch.restrictions then
        if ch.restrictions.allowed_cards then
            local banned_nodes = ret.nodes[1].nodes[1].nodes[2].nodes

            -- make sure to remove them to make sure
            for _, v in ipairs(banned_nodes) do v.nodes[1].config.object:remove() end
            ArrowAPI.table.clear(banned_nodes)

            table.insert(banned_nodes, {
                n=G.UIT.R, config={align = "tm", minh = 0.3}, nodes= localize{type = 'text', key = 'banned_except', vars = {}}
            })
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1}})

            local row_cards = {}
            local n_rows = math.max(1, math.floor(#ch.restrictions.allowed_cards/10) + 2 - math.floor(math.log(6, #ch.restrictions.allowed_cards)))
            local max_width = 1
            for k, v in ipairs(ch.restrictions.allowed_cards) do
                local _row = math.floor((k-1)*n_rows/(#ch.restrictions.allowed_cards)+1)
                row_cards[_row] = row_cards[_row] or {}
                row_cards[_row][#row_cards[_row]+1] = v
                if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
            end

            local card_size = math.max(0.2, 0.65 - 0.01*(max_width*n_rows))
            for _, row_card in ipairs(row_cards) do
                local allow_area = CardArea(
                    0,0,
                    6,
                    3/n_rows,
                    {
                        card_limit = nil,
                        type = 'title_2',
                        view_deck = true,
                        highlight_limit = 0,
                        card_w = G.CARD_W*card_size
                    }
                )

                for _, v in ipairs(row_card) do
                    local card = Card(0, 0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v.id],
                        {bypass_discovery_center = true, bypass_discovery_ui = true}
                    )
                    allow_area:emplace(card)
                end


                table.insert(banned_nodes,
                    {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                        {n=G.UIT.O, config={object = allow_area}}
                    }}
                )

            end
        end

        if ch.restrictions.allowed_other then
            local banned_nodes = ret.nodes[1].nodes[3].nodes[2].nodes
            for _, v in ipairs(banned_nodes) do v.nodes[1].config.object:remove() end
            ArrowAPI.table.clear(banned_nodes)

            table.insert(banned_nodes, {n=G.UIT.R, config={align = "tm", minh = 0.2, maxw = 2}, nodes= localize{type = 'text', key = 'blinds_except', vars = {}}})
            table.insert(banned_nodes, {n=G.UIT.R, config={align = "cm", minh = 0.1, maxw = 2}})

            local allowed_blinds = {}
            for _, v in pairs(ch.restrictions.allowed_other) do
                allowed_blinds[#allowed_blinds+1] = G.P_BLINDS[v.id]
            end

            table.sort(allowed_blinds, function (a, b) return a.order < b.order end)
            for _, v in ipairs(allowed_blinds) do
                local temp_blind = AnimatedSprite(0,0,1,1, G.ANIMATION_ATLAS[v.atlas or ''] or G.ANIMATION_ATLAS['blind_chips'], v.pos)
                temp_blind:define_draw_steps({{shader = 'dissolve', shadow_height = 0.05},{shader = 'dissolve'}})
                temp_blind.float = true
                temp_blind.states.hover.can = true
                temp_blind.states.drag.can = false
                temp_blind.states.collide.can = true
                temp_blind.config = {blind = v, force_focus = true}
                temp_blind.hover = function()
                    if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
                        if not temp_blind.hovering and temp_blind.states.visible then
                        temp_blind.hovering = true
                        temp_blind.hover_tilt = 3
                        temp_blind:juice_up(0.05, 0.02)
                        play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
                        temp_blind.config.h_popup = create_UIBox_blind_popup(v, true)
                        temp_blind.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = temp_blind}
                        Node.hover(temp_blind)
                        end
                    end
                end

                temp_blind.stop_hover = function()
                    temp_blind.hovering = false
                    Node.stop_hover(temp_blind)
                    temp_blind.hover_tilt = 0
                end

                table.insert(banned_nodes,
                {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
                    {n=G.UIT.O, config={object = temp_blind}}
                }})
            end
        end
    end

    return ret
end


local ref_ui_button = UIBox_button
function UIBox_button(args)
    local ret = ref_ui_button(args)
    if not args.count and args.button == 'change_challenge_description' and G.CHALLENGES[args.id].original_mod then
        local ch = G.CHALLENGES[args.id]
        local mod = ch.original_mod or ch.mod or {}

        -- copy new animated modicon style
        local atlas_key = mod.prefix and mod.prefix .. '_modicon' or 'modicon'
        local modicon
        if G.ANIMATION_ATLAS[atlas_key] then
            modicon = AnimatedSprite(0, 0, 0.5, 0.5, G.ANIMATION_ATLAS[atlas_key] or G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        else
            modicon = Sprite(0, 0, 0.5, 0.5, G.ASSET_ATLAS[atlas_key] or G.ASSET_ATLAS['tags'], tag_pos)
        end

        local origin = type(ch.origin) == 'table' and (ch.origin.custom_color or ch.origin.category) or ch.origin
        local text_colour = origin and ArrowAPI.ui.badge_colors[mod.id]['te_'..origin] or args.text_colour or G.C.WHITE
        local text_nodes = ret.nodes[1].nodes
        for _, v in ipairs(text_nodes) do
            v.config.minw = math.max(0, v.config.minw - 1.2)
            v.config.maxw = math.max(v.config.minw, 2)
            v.nodes[1].config.colour = text_colour
        end


        local badge_color = origin and ArrowAPI.ui.badge_colors[mod.id]['co_'..origin] or nil
        local new_nodes = {
            {n= G.UIT.C, config={ minw = 0.8, align = 'cm', padding = args.padding or 0 }, nodes = {
                { n=G.UIT.O, config = {align = 'rm', can_collide = true, object = modicon, tooltip = {text = {mod.display_name}}}}
            }},
            {n= G.UIT.C, config={ minw = 0.8, colour = badge_color, r = 0.1, minh = args.minh, align = 'cm' }, nodes = {
                badge_color and {n = G.UIT.C, config={minw = 0.2, align = 'cm'}} or nil,
                {n = G.UIT.C, config={align = 'cm'}, nodes = text_nodes},
                {n = G.UIT.C, config={minw = badge_color and 0.2 or 0.4, align = 'cm'}}
            }},
        }

        ret.config.padding = 0
        ret.nodes[1].nodes = new_nodes
    end

    return ret
end



---------------------------
--------------------------- Deck crediting
---------------------------

local ref_run_setup = G.UIDEF.run_setup_option
function G.UIDEF.run_setup_option(...)
    local ret = ref_run_setup(...)

    if G.GAME.viewed_back then
        local args = {...}

        local credit = {
            n = G.UIT.R,
            config = {align = "cm"},
            nodes = {{
                n = G.UIT.O,
                config = {
                    id = nil,
                    func = 'RUN_SETUP_check_artist',
                    object = Moveable()
                }
            }}
        }

        if args[1] == 'Continue' and V(G.SAVED_GAME.GAME.smods_version or '0.0.0') == V(SMODS.version) then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[#back_desc_nodes+1] = credit
        elseif args[1] == 'New Run' then
            local back_desc_nodes = ret.nodes[1].nodes[1].nodes[1].nodes[2].nodes[1].nodes[1].nodes[1].nodes[2].nodes
            back_desc_nodes[#back_desc_nodes+1] = credit
        end
    end

    return ret
end

function G.UIDEF.deck_credit(back)
    -- set the artists
    local vars = {}
    local mod = back.original_mod or back.mod
    if type(back.artist) == 'table' then
        for i, v in ipairs(back.artist) do
            vars[i] = ArrowAPI.credits[ mod.id][v]
        end
    else
        vars[1] = ArrowAPI.credits[ mod.id][back.artist]
    end

    local name_nodes = localize{type = 'name', key = "artistcredit_"..#vars, set = 'Other', scale = 0.6}
    local desc_nodes = {}
    localize{type = 'descriptions', key = "artistcredit_"..#vars, set = "Other", vars = vars, nodes = desc_nodes, scale = 0.7}
    local credit = {
        n = G.UIT.ROOT,
        config = {id = back.name, align = "cm", minw = 4, r = 0, colour = G.C.CLEAR },
        nodes = {
            name_from_rows(name_nodes, nil),
            desc_from_rows(desc_nodes, nil),
        }
    }

    -- customized measurements
    credit.nodes[1].config.padding = 0.035
    credit.nodes[2].config.padding = 0.03
    credit.nodes[2].config.minh = 0.15
    credit.nodes[2].config.minw = 4
    credit.nodes[2].config.r = 0.005

    return credit
end

--- this is needed to fix a bug in vanilla which will crash this whole tree if recalculate is called
local ref_toggle_seeded = G.FUNCS.toggle_seeded_run
function G.FUNCS.toggle_seeded_run(e)
    if e.config.object and not G.run_setup_seed then
        e.config.object:remove()
        e.config.object = nil
        e.UIT = G.UIT.R
        e.UIBox:recalculate()
    elseif G.run_setup_seed then
        e.UIT = G.UIT.O
    end

    return ref_toggle_seeded(e)
end


function G.UIDEF.deck_artist_popup(center)
    local vars = {}
    local mod = center.original_mod or center.mod
    if type(center.artist) == 'table' then
        for i, v in ipairs(center.artist) do
            vars[i] = ArrowAPI.credits[mod.id][v]
        end
    else
        vars[1] = ArrowAPI.credits[mod.id][center.artist]
    end

    local info_nodes = {}
    localize{type = 'descriptions', key = "artistcredit_"..#vars, set = "Other", vars = vars, nodes = info_nodes}
    info_nodes.name = localize{type = 'name_text', key = "artistcredit_"..#vars, set = 'Other'}

    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.JOKER_GREY, 0.5), r = 0.1, padding = 0.05, emboss = 0.05}, nodes={
            info_tip_from_rows(info_nodes, info_nodes.name),
        }}
    }}
end

function create_UIBox_notify_alert(key, type)
    local _c, _atlas

    local is_arrow_achievement = false
    if SMODS.Achievements[key] then
        _c = SMODS.Achievements[key]
        if _c.original_mod then
            for _, x in ipairs(_c.original_mod.dependencies or {}) do
                for _, y in ipairs(x) do
                    if y.id == 'ArrowAPI' then
                        is_arrow_achievement = true
                        break
                    end
                end
            end
        end
        _atlas = G.ASSET_ATLAS[_c.atlas]
    else
        _c = G.P_CENTERS[key]
        _atlas = ((type == 'Joker' or type == 'Voucher') and G.ASSET_ATLAS[type])
        or (type == 'Back' and G.ASSET_ATLAS['centers']) or G.ASSET_ATLAS['icons']

        local _smods_atlas = _c and ((G.SETTINGS.colourblind_option and _c.hc_atlas or _c.lc_atlas) or _c.atlas)
        if _smods_atlas then
            _atlas = G.ASSET_ATLAS[_smods_atlas] or _atlas
        end
    end

    local t_s = Sprite(0,0,1.5*(_atlas.px/_atlas.py),1.5,_atlas, _c and _c.pos or {x=3, y=0})
    t_s.states.drag.can = false
    t_s.states.hover.can = false
    t_s.states.collide.can = false

    local subtext = type == 'achievement' and localize(G.F_TROPHIES and 'k_trophy' or 'k_achievement') or
        (type == 'Joker' or type == 'Voucher') and localize('k_'..type:lower()) or
        type == 'Back' and localize('k_deck') or
        _c.set and localize('k_' .. _c.set:lower()) or
        'ERROR'
    if key == 'b_challenge' then subtext = localize('k_challenges') end

    local name_text = is_arrow_achievement
    and localize{type = 'name_text', key = key, set = 'Achievements'}
    or localize(key, 'achievement_names')

    local t = {n=G.UIT.ROOT, config = {align = 'cl', r = 0.1, padding = 0.06, colour = G.C.UI.TRANSPARENT_DARK}, nodes={
        {n=G.UIT.R, config={align = "cl", padding = 0.2, minw = 20, r = 0.1, colour = G.C.BLACK, outline = 1.5, outline_colour = G.C.GREY}, nodes={
            {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
                {n=G.UIT.R, config={align = "cm", r = 0.1}, nodes={
                    {n=G.UIT.O, config={object = t_s}},
                }},
                type ~= 'achievement' and {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = subtext, scale = 0.5, colour = G.C.FILTER, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
                    }}
                }}
                or {n=G.UIT.R, config={align = "cm", padding = 0.04}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4, padding = 0.1}, nodes={
                        {n=G.UIT.T, config={text = name_text, scale = 0.4, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = subtext, scale = 0.3, colour = G.C.FILTER, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 3.4}, nodes={
                        {n=G.UIT.T, config={text = localize('k_unlocked_ex'), scale = 0.35, colour = G.C.FILTER, shadow = true}},
                    }}
                }}
            }}
        }}
    }}
    return t
end