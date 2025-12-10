---------------------------
--------------------------- Maggie Speech Bubble Support
---------------------------

function G.UIDEF.jok_speech_bubble(text_key, loc_vars, extra)
    local text = {}
    extra = extra or {}

    localize{type = 'quips', key = text_key, vars = loc_vars or {}, nodes = text}
    local row = {}
    for k, v in ipairs(text) do
        --v[1].config.colour = extra.text_colour or v[1].config.colour or G.C.JOKER_GREY
        row[#row+1] =  {n=G.UIT.R, config={align = extra.text_alignment or "cl"}, nodes=v}
    end
    local t = {n=G.UIT.ROOT, config = {align = "cm", minh = 1, r = 0.3, padding = 0.07, minw = 1, colour = extra.root_colour or G.C.JOKER_GREY, shadow = true}, nodes={
        {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.1, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes={
            {n=G.UIT.C, config={align = "cm", minh = 1, r = 0.2, padding = 0.03, minw = 1, colour = extra.bg_colour or G.C.WHITE}, nodes=row}}
        }
    }}
    return t
end





---------------------------
---------------------------  General custom interaction behavior
---------------------------

local ref_can_buy = G.FUNCS.can_buy_and_use
G.FUNCS.can_buy_and_use = function(e)
    local ret = ref_can_buy(e)
    if e.config.ref_table.ability.set == 'VHS' then
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

SMODS.Atlas({key = 'arrow_mystery', atlas_table = "ANIMATION_ATLAS", path = "blinds/mystery.png", px = 34, py = 34, frames = 21, prefix_config = false })

local ref_blind_choice = create_UIBox_blind_choice
function create_UIBox_blind_choice(...)
    local args = { ... }
    local type = args[1]
    local obj = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]]


    SMODS.hide_blind = obj.hide_blind or SMODS.blind_hidden(obj) or nil
    local ret
    if SMODS.hide_blind then
        local atlas = obj.atlas or 'blind_chips'
        local old_atlas = G.ANIMATION_ATLAS[atlas]
        G.ANIMATION_ATLAS[atlas] = G.ANIMATION_ATLAS['arrow_mystery']
        ret = ref_blind_choice(...)
        G.ANIMATION_ATLAS[atlas] = old_atlas
    else
        ret = ref_blind_choice(...)
    end

    if obj.score_invisible or SMODS.hide_blind then
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

local ref_challenge_desc = G.UIDEF.challenge_description
function G.UIDEF.challenge_description(_id, daily, is_row)
    ArrowAPI.eternal_compat_bypass = true
    local ret = ref_challenge_desc(_id, daily, is_row)
    ArrowAPI.eternal_compat_bypass = nil
    return ret
end

local ref_challenge_tab = G.UIDEF.challenge_description_tab
function G.UIDEF.challenge_description_tab(args)
    local ret = ref_challenge_tab(args)

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
    local vars = type(back.artist) == 'table' and back.artist or {back.artist}

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





---------------------------
--------------------------- Draws credits for a given area
---------------------------

function create_UIBox_credit_tooltip(contributor_data)
    play_sound('cardSlide2')
    local centers = {}
    for i = 1, #contributor_data do
        local data = contributor_data[i]
        if G.P_CENTERS[data.key] then
            centers[#centers+1] = data.key
        end
    end

    local credit_cards = {}
    local row_cards = {}
    local n_rows = math.max(1, math.floor(#centers/10) + 2 - math.floor(math.log(6, #centers)))
    local max_width = 1
    for i, v in ipairs(centers) do
        local _row = math.floor((i-1)*n_rows/(#centers)+1)
        row_cards[_row] = row_cards[_row] or {}
        row_cards[_row][#row_cards[_row]+1] = v
        if #row_cards[_row] > max_width then max_width = #row_cards[_row] end
    end

    local card_size = math.max(0.3, 0.75 - 0.01*(max_width*n_rows))

    for _, row_card in ipairs(row_cards) do
        local credit_area = CardArea(
        0,0,
        6.7,
        3.3/n_rows,
        {card_limit = nil, type = 'title_2', view_deck = true, highlight_limit = 0, card_w = G.CARD_W*card_size})
        table.insert(credit_cards,
        {n=G.UIT.R, config={align = "cm", padding = 0}, nodes={
        {n=G.UIT.O, config={object = credit_area}}
        }}
        )
        for k, v in ipairs(row_card) do
            local card = Card(0,0, G.CARD_W*card_size, G.CARD_H*card_size, nil, G.P_CENTERS[v])
            credit_area:emplace(card)
        end
    end

    local nodes = {n=G.UIT.C, config={align = "cm", r = 0.1}, nodes={
      {n=G.UIT.R, config={align = "cm", minh = 5, minw = 8, padding = 0.05, r = 0.1, colour = G.C.WHITE}, nodes=
        credit_cards
      }
    }}

    return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
      nodes
    }}
end





---------------------------
--------------------------- New settings tab with some below features
---------------------------

local ref_settings_tab = G.UIDEF.settings_tab
function G.UIDEF.settings_tab(tab)
    if tab == 'Audio' then
        return {n=G.UIT.ROOT, config={align = "cm", padding = 0.05, colour = G.C.CLEAR}, nodes={
            create_slider({label = localize('b_set_master_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'volume', min = 0, max = 100}),
            create_slider({label = localize('b_set_music_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'music_volume', min = 0, max = 100}),
            create_slider({label = localize('b_set_game_vol'), w = 5, h = 0.4, ref_table = G.SETTINGS.SOUND, ref_value = 'game_sounds_volume', min = 0, max = 100}),
            {n = G.UIT.R, config = {align = "cm", padding = 0.1, minh = 2}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, minh = 2.5}, nodes = {
                    UIBox_button{ label = {localize("tnsmi_manager_pause")}, button = "tnsmi_packs_button", minw = 4, colour = G.C.PALE_GREEN},
                }},
                {n = G.UIT.C, config = {align = "cm", padding = 0.1, minh = 2.5}, nodes = {
                    {n = G.UIT.R, config = {align = "cl", padding = 0.1}, nodes = {
                        {n = G.UIT.C, config = {align = "cl", minw = 2.5}, nodes = {
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.T, config = {align = "cr", text = localize("tnsmi_cfg_rows")..": ", colour = G.C.WHITE, scale = 0.3}}}},
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.O, config = {align = "cr", object = DynaText{string = {{ref_table = TNSMI.config, ref_value = "rows"}}, colours = {G.C.WHITE}, scale = 0.3}}}}},
                        }},
                        {n = G.UIT.C, config = {align = "cl", minw = 0.4}, nodes = {
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"-"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"rows",-1}}}},
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"+"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"rows",1}}}},
                        }},
                    }},
                    {n = G.UIT.R, config = {align = "cl", padding = 0.1}, nodes = {
                        {n = G.UIT.C, config = {align = "cl", minw = 2.5}, nodes = {
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.T, config = {align = "cr", text = localize("tnsmi_cfg_cols")..": ", colour = G.C.WHITE, scale = 0.3}}}},
                            {n = G.UIT.C, config = {align = "cl"}, nodes = {{n = G.UIT.O, config = {align = "cr", object = DynaText{string = {{ref_table = TNSMI.config, ref_value = "cols"}}, colours = {G.C.WHITE}, scale = 0.3}}}}},
                        }},
                        {n = G.UIT.C, config = {align = "cl", minw = 0.4}, nodes = {
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"-"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"cols",-1}}}},
                            {n = G.UIT.C, config = {align = "cl", minw = 0.65}, nodes = {UIBox_button{ label = {"+"}, button = "tnsmi_change_pack_display", minw = 0.6, minh = 0.4, ref_table = {"cols",1}}}},
                        }},
                    }},
                }},
            }},
        }}
    end

    if tab == 'Palettes' then
        G.SETTINGS.paused = true
        ArrowAPI.palette_ui_config.open_palette = nil
        if G.OVERLAY_MENU then G.OVERLAY_MENU:remove() end
        G.FUNCS.overlay_menu{
            definition = arrow_create_UIBox_palette_menu(),
            config = {offset = {x = 0, y = 10}}
        }
        G.OVERLAY_MENU:get_UIE_by_ID('arrow_selected_colour').config.button_ref = G.OVERLAY_MENU:get_UIE_by_ID('arrow_palette_button_1')
        return  {n=G.UIT.ROOT, config = {align = "cm"}, nodes={}}
	end

    return ref_settings_tab(tab)
end






---------------------------
--------------------------- Tonsmith UI
---------------------------

-- Creates a fake soundpack card partially based on the approach Malverk takes
function tnsmi_create_soundpack_card(area, pack, pos)
    local atlas = G.ANIMATION_ATLAS[pack.atlas] or G.ASSET_ATLAS[pack.atlas]

    -- this card is provided a "fake" SoundPack center
    -- rather than registering an unused item, it fills in the
    -- fields SMODS.GameObject normally needs to display
    -- and localize UI for centers
    local card = Card(
        area.T.x,
        area.T.y,
        G.CARD_W * 0.8,
        G.CARD_W * 0.8,
        nil,
        {key = pack.key, name = "Sound Pack", atlas = pack.atlas, pos={x=0,y=0}, set = "SoundPack", label = 'Sound Pack', config = {}, generate_ui = SMODS.Center.generate_ui},
        {tnsmi_soundpack = pack.key}
    )

    card.states.drag.can = area == TNSMI.cardareas.priority
    if atlas.frames then
        --card.T.w = W
        --card.T.h = H
        card.children.animatedSprite = AnimatedSprite(card.T.x, card.T.y, card.T.w, card.T.h, atlas, atlas.pos)
        card.children.animatedSprite.T.w = W
        card.children.animatedSprite.T.h = H
        card.children.animatedSprite:set_role({major = card, role_type = 'Glued', draw_major = card})
        card.children.animatedSprite:rescale()
        card.children.animatedSprite.collide.can = false
        card.children.animatedSprite.drag.can = false
        card.children.center:remove()
        card.children.back:remove()
        card.no_shadow = true
        area:emplace(card, pos)
        return card
    end

    area:emplace(card, pos)

    -- This delay is set in G.FUNCS.tnsmi_toggle_soundpack for juice
    -- when TNSMI.dissolve_flag is set, the next pack created of that key
    -- will materialize rather than instantly appearing
    -- so it appears to pop out of one cardarea and pop into the next
    if TNSMI.dissolve_flag == pack.key then
        card.states.visible = false
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            blocking = false,
            blockable = false,
            func = (function()
                card:start_materialize(nil, nil, 0.25)
                return true
            end)
        }))

        TNSMI.dissolve_flag = nil
    end
end

--- Definition for the Soundpack Overlay Menu
function tnsmi_create_UIBox_soundpacks()

    -- creates cardareas only once upon menu load to prevent any unnecessary calc
    -- updates occur within the existing cardareas
    if TNSMI.cardareas.priority then TNSMI.cardareas.priority:remove() end
    TNSMI.cardareas.priority = CardArea(0, 0, G.CARD_W * TNSMI.config.cols * 0.965, G.CARD_H * 0.725,
        {card_limit = TNSMI.config.cols, type = 'soundpack', highlight_limit = 99}
    )

    for _, v in ipairs(TNSMI.config.loaded_packs) do
        tnsmi_create_soundpack_card(TNSMI.cardareas.priority, TNSMI.SoundPacks[v], 'front')
    end

    -- these are likely unnecessary because area references get cleaned when UI is removed (I think)
    for i = #TNSMI.cardareas, 1, -1 do
        TNSMI.cardareas[i]:remove()
        TNSMI.cardareas[i] = nil
    end

    local area_nodes = {}
    for i=1, TNSMI.config.rows do
        TNSMI.cardareas[i] = CardArea(0, 0, G.CARD_W * TNSMI.config.cols * 0.965, G.CARD_H * 0.725,
            {card_limit = TNSMI.config.cols, highlight_limit = 99, type = 'soundpack'}
        )

        area_nodes[#area_nodes+1] = {n = G.UIT.R, config = {align = "cl", colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.O, config = {id = 'tnsmi_area_'..i, object = TNSMI.cardareas[i]}}
        }}
    end

    -- Cycle config is stored in this global variable in order to change the state of the
    -- option cycle on the fly when filtering search results. Vanilla balatro expects
    -- they're only changed upon complete menu reload
    TNSMI.cycle_config = {
        options = {},
        w = 4.5,
        cycle_shoulders = true,
        opt_callback = 'tnsmi_soundpacks_page',
        focus_args = {snap_to = true, nav = 'wide'},
        current_option = 1,
        colour = G.C.RED,
        no_pips = true,
    }

    G.FUNCS.tnsmi_reload_soundpack_cards()

    local opt_cycle = create_option_cycle(TNSMI.cycle_config)
    opt_cycle.nodes[2].nodes[1].nodes[1].config.func = 'tnsmi_shoulder_buttons'
    opt_cycle.nodes[2].nodes[1].nodes[3].config.func = 'tnsmi_shoulder_buttons'


    local t = {
        {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, r = 0.2, minh = 0.8, padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cl"}, nodes = {
                {n = G.UIT.T, config = {align = 'cl', text = localize("tnsmi_manager_loaded"), padding = 0.1, scale = 0.25, colour = lighten(G.C.GREY,0.2), vert = true}},
            }},
            {n = G.UIT.C, config = {align = "cr", func = 'tnsmi_change_priority'}, nodes = {
                {n = G.UIT.O, config = {align = 'cr', minw = 6, object = TNSMI.cardareas.priority}}
            }},
        }},
        {n = G.UIT.R, config = {align = "cr", padding = 0}, nodes = {
            {n = G.UIT.C, config = {align = "cr", padding = 0.1}, nodes = {
                 {n = G.UIT.T, config = {ref_table = TNSMI, ref_value = 'search_text', scale = 0.25, colour = lighten(G.C.GREY, 0.2)}},
            }},
            {n = G.UIT.C, config = {align = "cr", colour = {G.C.L_BLACK[1], G.C.L_BLACK[2], G.C.L_BLACK[3], 0.5}, r = 0.2, padding = 0.1, minw = 3.5}, nodes = {
                create_text_input({max_length = 12, w = 3.5, ref_table = TNSMI, ref_value = 'prompt_text_input'}),
                {n = G.UIT.C, config = {align = "cm", minw = 0.2, minh = 0.2, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, shadow = true, button = "tnsmi_reload_soundpack_cards"}, nodes = {
                    {n = G.UIT.R, config = {align = "cm", padding = 0.05, minw = 1.5}, nodes = {
                        {n = G.UIT.T, config = {text = localize("tnsmi_filter_label"), scale = 0.4, colour = G.C.UI.TEXT_LIGHT}}
                    }}
                }},
            }},

        }},

        {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, r = 0.2, minh = 4, padding = 0.1}, nodes = {
            {n = G.UIT.C, config = {align = "cm", colour = G.C.CLEAR}, nodes = area_nodes}
        }},
        opt_cycle
    }

    -- uses the same function as most Overlay Menu calls
    return create_UIBox_generic_options({ contents = t, back_func = 'settings', snap_back = nil })
end

--- Definition for the soundpack button that appears in the Options > Audio menu
function G.UIDEF.tnsmi_soundpack_button(card)
    local priority = card.area and card.area == TNSMI.cardareas.priority
    local text = priority and 'b_remove' or 'b_select'
    local color = priority and  G.C.RED or G.C.GREEN
    return {
        n=G.UIT.ROOT, config = {padding = 0, colour = G.C.CLEAR}, nodes={
            {n=G.UIT.R, config={ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5*card.T.w - 0.15, maxw = 0.9*card.T.w - 0.15, minh = 0.5*card.T.h, hover = true, shadow = true, colour = color, one_press = true, button = 'tnsmi_toggle_soundpack'}, nodes={
                {n=G.UIT.T, config={text = localize(text), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true}}
            }},
        }
    }
end

-- This function is weird as hell
-- there's no easy way to set a tab other than in the tab definition function
-- So this kinda fudges it to set the audio tab as chosen if tabs are being created from the soundpack menu (I.E. back to the settings menu)
local ref_create_tabs = create_tabs
function create_tabs(args)
    if args.tabs then
        local reset_chosen = false
        for i = #args.tabs, 1, -1 do
            if args.tabs[i].tab_definition_function_args == 'Audio' and G.OVERLAY_MENU.config.id == 'tnsmi_soundpack_menu' then
                args.tabs[i].chosen = true
                reset_chosen = true
                break
            end
        end

        if reset_chosen then
           for i = #args.tabs, 1, -1 do
                if args.tabs[i].tab_definition_function_args ~= 'Audio' then
                    args.tabs[i].chosen = false
                end
            end
        end
    end

    return ref_create_tabs(args)
end





---------------------------
--------------------------- Palette editor
---------------------------

SMODS.Atlas({key = 'arrow_slider_point', path = 'slider_point.png', px = 18, py = 18, prefix_config = false})

function arrow_create_rgb_slider(args)
    args.w = args.w or 1
    args.h = args.h or 0.5
    args.text_scale = args.text_scale or 0.3
    args.min = args.min
    args.max = args.max
    args.text = string.format("%.0f", args.ref_table[args.ref_value])

    local arrow_sprite = Sprite(0, 0, 0.25, 0.25, G.ASSET_ATLAS['arrow_slider_point'], {x = 0, y = 0})
    arrow_sprite.role.offset = {x = args.w * (args.ref_table[args.ref_value] / args.max) - 0.125, y = 0}
    arrow_sprite.states.drag.can = false

    return {n=G.UIT.C, config={align = "cm", minw = args.w, padding = 0.03, r = 0.1, colour = G.C.CLEAR, focus_args = {type = 'slider'}}, nodes={
        {n=G.UIT.C, config={align = "bm", minh = args.h * 1.3}, nodes={
            {n=G.UIT.R, config = {align = "cl", w = args.w, h = args.h*0.3}, nodes = {
                {n=G.UIT.O, config={colour = G.C.BLUE, object = arrow_sprite, refresh_movement = true}},
            }},
            {n=G.UIT.R, config={id = args.id, align = "cl", minw = args.w, r = 0.1, minh = args.h, collideable = true, hover = true, colour = G.C.BLACK, emboss = 0.05, func = 'arrow_rgb_slider', refresh_movement = true}, nodes={
                {n=G.UIT.B, config={id = 'arrow_rgb_slider', w = args.w, h = args.h, r = 0.1, colour = G.C.UI.TEXT_LIGHT, ref_table = args, refresh_movement = true}},
            }}
        }},
        {n=G.UIT.C, config={align = "bm", minh = args.h * 1.3}, nodes={
            {n=G.UIT.R, config = {align = "cm", r = 0.05, minw = 0.6, minh = args.h, colour = G.C.UI.TEXT_LIGHT, emboss = 0.05}, nodes = {
                {n=G.UIT.T, config={ref_table = args, ref_value = 'text', scale = args.text_scale, colour = G.C.UI.TEXT_DARK, decimal_places = 0}}
            }}
        }},
    }}
end

function arrow_create_UIBox_palette_menu()
    local palette_tabs = {}
    for k, v in pairs(ArrowAPI.colors.palettes) do
        if (v.items and #v.items > 0) or k == 'Background' then
            if not ArrowAPI.palette_ui_config.open_palette then
                ArrowAPI.palette_ui_config.open_palette = {set = k, idx = 1}
            end
            local loc = localize('b_arrow_pal_'..tostring(k))
            palette_tabs[#palette_tabs+1] = {
                label = loc ~= 'ERROR' and loc or k,
                chosen = k == ArrowAPI.palette_ui_config.open_palette.set,
                tab_definition_function = G.UIDEF.arrow_palette_tab,
                tab_definition_function_args = k
            }
        end
    end

    local tabs = create_tabs(
        {tabs = palette_tabs,
        snap_to_nav = true}
    )

    -- set the tabs to be the set colors
    local tab_buttons = tabs.nodes[1].nodes[2].nodes
    for i = 1, #tab_buttons do
        if palette_tabs[i].tab_definition_function_args ~= 'Background' then
            tab_buttons[i].nodes[1].config.colour = G.C.SECONDARY_SET[palette_tabs[i].tab_definition_function_args]
        end
    end


    return create_UIBox_generic_options({back_func = 'settings', contents = {tabs}})
end

function G.UIDEF.arrow_palette_tab(tab)
    ArrowAPI.colors.use_custom_palette(tab, ArrowAPI.config.saved_palettes[tab].saved_index)
    local palette = ArrowAPI.colors.palettes[tab]

    if tab ~= ArrowAPI.palette_ui_config.open_palette.set then
        ArrowAPI.palette_ui_config.open_palette = {set = tab, idx = 1}
    end
    local start_idx = ArrowAPI.palette_ui_config.open_palette.idx

    local current_palette = palette.current_palette
    local button_color = (start_idx == 0 and copy_table(current_palette.badge_colour)) or not current_palette[start_idx].default and current_palette[start_idx] or palette.default_palette[start_idx]

    -- adjust for badge colour
    if start_idx == 0 then
        button_color[1] = button_color[1] * 255
        button_color[2] = button_color[2] * 255
        button_color[3] = button_color[3] * 255
        button_color[4] = 1
    end

    ArrowAPI.palette_ui_config.rgb = {button_color[1], button_color[2], button_color[3]}

    -- set first hex input
    local new_hex_string = string.upper(tostring(string.format("%02x", button_color[1])..string.format("%02x", button_color[2])..string.format("%02x", button_color[3])))
    ArrowAPI.palette_ui_config.last_hex_input = new_hex_string
    ArrowAPI.palette_ui_config.hex_input = new_hex_string

    local deck_tables = {}
    local cards_per_page = 0
    local items = {}

    if tab ~= 'Background' then
        local w_mod = 1
        local h_mod = 0.95
        items = palette.items

        G.arrow_palette_collection = {}
        local rows = {6, 6}
        local row_totals = {}
        for i = 1, #rows do
            if cards_per_page >= #items then
                rows[i] = nil
            else
                row_totals[i] = cards_per_page
                cards_per_page = cards_per_page + rows[i]
                G.arrow_palette_collection[i] = CardArea(
                    G.ROOM.T.x + 0.2*G.ROOM.T.w/2,
                    G.ROOM.T.h,
                    (w_mod*rows[i]+0.25)*G.CARD_W,
                    h_mod*G.CARD_H,
                    {card_limit = rows[i], type = 'title', highlight_limit = 0, collection = true}
                )
                table.insert(deck_tables,
                {n=G.UIT.R, config={align = "cm", padding = 0.07, no_fill = true}, nodes={
                    {n=G.UIT.O, config={object = G.arrow_palette_collection[i]}}
                }})
            end
        end

        local options = {}
        for i = 1, math.ceil(#items/cards_per_page) do
            table.insert(options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(#items/cards_per_page)))
        end

        G.FUNCS.arrow_palette_page = function(e)
            for j = 1, #G.arrow_palette_collection do
                for i = #G.arrow_palette_collection[j].cards, 1, -1 do
                local c = G.arrow_palette_collection[j]:remove_card(G.arrow_palette_collection[j].cards[i])
                c:remove()
                c = nil
                end
            end
            for j = 1, #rows do
                for i = 1, rows[j] do
                    local item = items[i+row_totals[j] + (cards_per_page*(e.cycle_config.current_option - 1))]
                    if not item then break end

                    local disp_card = Card(
                        G.arrow_palette_collection[j].T.x + G.arrow_palette_collection[j].T.w/2,
                        G.arrow_palette_collection[j].T.y,
                        G.CARD_W,
                        G.CARD_H,
                        G.P_CARDS.empty,
                        (G.P_CENTERS[item.table == 'SEALS' and 'c_base' or item.key])
                    )

                    if item.table == 'SEALS' then disp_card:set_seal(item.key, true) end

                    --disp_card:start_materialize(nil, i>1 or j>1)
                    G.arrow_palette_collection[j]:emplace(disp_card)
                end
            end
        end

        G.FUNCS.arrow_palette_page{cycle_config = { current_option = 1 }}
    end

    local width = 4
    local color_nodes = {}
    local row_count = 8
    local row_idx = 0
    local count = 0

    local button_size = width * 0.9 / row_count
    local default_palette = palette.default_palette

    for i=1, #default_palette do
        sendDebugMessage('setting default color: '..tostring(current_palette[i].default))
        local color = default_palette[i]
        local custom_color = not current_palette[i].default and current_palette[i] or color

        if count % row_count == 0 then
            row_idx = row_idx + 1
            color_nodes[row_idx] = {n=G.UIT.R, config={align = "cm", padding = 0.025}, nodes={}}
        end

        color_nodes[row_idx].nodes[#color_nodes[row_idx].nodes+1] = {n=G.UIT.C, config={align = "cm"}, nodes={
            {n = G.UIT.R,
                config = {
                    palette_idx = i,
                    button = 'arrow_palette_reset',
                    align = "cm",
                    minw = button_size,
                    minh = button_size*0.6,
                    hover = true,
                    button_dist = 0.05,
                    colour = {color[1]/255, color[2]/255, color[3]/255, 1},
                },
                nodes = {}
            },
            {n = G.UIT.R,
                config = {
                    palette_idx = i,
                    id = 'arrow_palette_button_'..i,
                    align = "cm",
                    minw = button_size,
                    minh = button_size,
                    colour = {custom_color[1]/255, custom_color[2]/255, custom_color[3]/255, 1},
                    button = 'arrow_palette_button',
                    button_dist = 0.05,
                    hover = true,
                },
                nodes = {}
            }
        }}
        custom_color = nil
        count = count + 1

        if i == #default_palette and tab ~= 'Background' and type(current_palette.badge_colour) == 'table' then
            local badge_default = default_palette.badge_colour
            local badge_colour = current_palette.badge_colour
            color_nodes[row_idx].nodes[#color_nodes[row_idx].nodes+1] = {n = G.UIT.C, config={align = "cm"}, nodes={
                {n = G.UIT.R,
                    config = {
                        palette_idx = 0,
                        button = 'arrow_palette_reset',
                        align = "cm",
                        minw = button_size,
                        minh = button_size*0.6,
                        hover = true,
                        button_dist = 0.05,
                        colour = {badge_default[1], badge_default[2], badge_default[3], 1},
                    },
                    nodes = {}
                },
                {n = G.UIT.R,
                    config = {
                        palette_idx = 0,
                        id = 'arrow_palette_button_0',
                        align = "cm",
                        minw = button_size,
                        minh = button_size,
                        colour = {badge_colour[1], badge_colour[2], badge_colour[3], 1},
                        button = 'arrow_palette_button',
                        button_dist = 0.05,
                        hover = true,
                    },
                    nodes = {}
                }
            }}
        end
    end

    ArrowAPI.palette_ui_config.hex_input_config = {
        id = 'arrow_hex_input',
        max_length = 6,
        all_caps = true,
        w = width * 0.6,
        colour = G.C.UI.BACKGROUND_DARK,
        hooked_colour = darken(G.C.UI.BACKGROUND_DARK, 0.3),
        ref_table = ArrowAPI.palette_ui_config,
        ref_value = 'hex_input',
        callback = function()
            ArrowAPI.palette_ui_config.hex_input = string.format("%06s", ArrowAPI.palette_ui_config.hex_input)
            local hex = ArrowAPI.palette_ui_config.hex_input
            ArrowAPI.palette_ui_config.rgb[1] = math.min(255, math.max(0, tonumber(hex:sub(1, 2), 16) or 0))
            ArrowAPI.palette_ui_config.rgb[2] = math.min(255, math.max(0, tonumber(hex:sub(3, 4), 16) or 0))
            ArrowAPI.palette_ui_config.rgb[3] = math.min(255, math.max(0, tonumber(hex:sub(5, 6), 16) or 0))
            ArrowAPI.palette_changed_flag = true
            TRANSPOSE_TEXT_INPUT(0)
            G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('r_slider'), true)
             G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('g_slider'), true)
            G.FUNCS.arrow_rgb_slider(G.OVERLAY_MENU:get_UIE_by_ID('b_slider'), true)
        end
    }

    ArrowAPI.palette_ui_config.name_input_config = {
        id = 'arrow_save_name_input',
        max_length = 12,
        h = 1,
        w = 2.65,
        colour = G.C.UI.BACKGROUND_DARK,
        hooked_colour = darken(G.C.UI.BACKGROUND_DARK, 0.3),
        prompt_text = 'Enter Name',
        ref_table = ArrowAPI.palette_ui_config,
        ref_value = 'name_input'
    }

    ArrowAPI.palette_ui_config.name_input = ArrowAPI.config.saved_palettes[tab][ArrowAPI.config.saved_palettes[tab].saved_index].name

    local preset_options = {}
    for _, v in ipairs(ArrowAPI.config.saved_palettes[tab]) do
        preset_options[#preset_options+1] = v.name
    end

    local preset_cycle = create_option_cycle({
        options = preset_options,
        w = 6.5,
        cycle_shoulders = true,
        current_option = ArrowAPI.config.saved_palettes[tab].saved_index,
        colour = G.C.ORANGE,
        opt_callback = 'arrow_load_palette_preset',
        focus_args = {snap_to = true, nav = 'wide'}
    })
    preset_cycle.nodes[1].config.minw = nil
    preset_cycle.nodes[3].config.minw = nil

    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.C, config={align = "cm"}, nodes={
                {n=G.UIT.R, config={align = "cm", minw = 7}, nodes={
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            preset_cycle
                        }},
                        tab ~= 'Background' and {n=G.UIT.C, config={align = "cl"}, nodes={
                            {n=G.UIT.C, config={align = "cl", minw = 2.8}, nodes={
                                create_text_input(ArrowAPI.palette_ui_config.name_input_config)
                            }},
                        }} or nil,
                        tab ~= 'Background' and {n=G.UIT.C, config={align = "cm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "cm", minw = 1.4, h = 1, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = 'arrow_save_palette', func = 'arrow_can_save_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'cm', text = localize('b_save_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }} or nil,
                        tab ~= 'Background' and {n=G.UIT.C, config={align = "cm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "cm", minw = 1.4, h = 1, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = 'arrow_delete_palette', func = 'arrow_can_delete_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'cm', text = localize('b_delete_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }} or nil,
                    }},
                    tab == 'Background' and {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm"}, nodes={
                            {n=G.UIT.C, config={align = "cl", minw = 2.8}, nodes={
                                create_text_input(ArrowAPI.palette_ui_config.name_input_config)
                            }},
                        }},
                        {n=G.UIT.C, config={align = "cm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "cm", minw = 1.4, h = 1, padding = 0.1, r = 0.1, hover = true, colour = G.C.BLUE, button = 'arrow_save_palette', func = 'arrow_can_save_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'cm', text = localize('b_save_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }},
                        {n=G.UIT.C, config={align = "cm", minw = 1.575}, nodes={
                            {n=G.UIT.C, config={align = "cm", minw = 1.4, h = 1, padding = 0.1, r = 0.1, hover = true, colour = G.C.RED, button = 'arrow_delete_palette', func = 'arrow_can_delete_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                                {n=G.UIT.T, config={align = 'cm', text = localize('b_delete_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                            }},
                        }},
                    }} or nil,
                    tab ~= 'Background' and {n=G.UIT.R, config={align = "cm", r = 0.1, padding = 0.2, colour = G.C.BLACK, emboss = 0.05}, nodes=deck_tables} or nil,
                    tab ~= 'Background' and cards_per_page < #items and {n=G.UIT.R, config={align = "cm"}, nodes={
                        create_option_cycle({options = options, w = 4.5, cycle_shoulders = true, opt_callback = 'arrow_palette_page', current_option = 1, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
                    }} or nil
                }}
            }},
            {n=G.UIT.C, config={align = "cm", minw = 0.4}, nodes = {}},
            {n=G.UIT.C, config={align = "cm", padding = 0.05}, nodes = {
                {n = G.UIT.R, config = {align = "cm", colour = G.C.BLACK, emboss = 0.05, r = 0.1}, nodes = {
                    {n = G.UIT.C, config={align = "cm", minw = width * 0.9, minh = 4, padding = 0.025}, nodes = color_nodes},
                }},
                {n = G.UIT.R, config = {align = "cm"}, nodes = {
                    {n = G.UIT.C, config = {align = "cm"}, nodes = {
                        {n = G.UIT.R, config = {align = "cm", minh = 0.1}, nodes = {}},
                        {n = G.UIT.R, config = {align = "cm"}, nodes = {
                            {n = G.UIT.C, config={align = "cl", minw = width * 0.7}, nodes ={
                                create_text_input(ArrowAPI.palette_ui_config.hex_input_config),
                            }},
                            {n = G.UIT.C, config={align = "cl", padding = 0.025, colour = G.C.UI.TEXT_LIGHT, emboss = 0.05, r = 0.4}, nodes = {
                                {n = G.UIT.R,
                                    config = {
                                        id = 'arrow_selected_colour',
                                        align = "cm",
                                        minw = width * 0.15,
                                        minh = width * 0.15,
                                        func = 'arrow_update_selected_colour',
                                        r = 0.4
                                    },
                                    nodes = {}
                                }
                            }},
                        }},
                        {n = G.UIT.R, config = {align = "cm", padding = 0.1}, nodes = {
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({id = 'r_slider', w = 2.5, h = 0.3, text_scale = 0.2, ref_table = ArrowAPI.palette_ui_config.rgb, ref_value = 1, min = 0, max = 255}),
                            }},
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({id = 'g_slider', w = 2.5, h = 0.3, text_scale = 0.2, ref_table = ArrowAPI.palette_ui_config.rgb, ref_value = 2, min = 0, max = 255}),
                            }},
                            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                                arrow_create_rgb_slider({id = 'b_slider', w = 2.5, h = 0.3, text_scale = 0.2, ref_table = ArrowAPI.palette_ui_config.rgb, ref_value = 3, min = 0, max = 255}),
                            }},
                        }},
                    }},
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                    {n=G.UIT.R, config={align = "cm"}, nodes={
                        {n=G.UIT.C, config={align = "cm", minw = 4, padding = 0.1, r = 0.1, hover = true, colour = G.C.ORANGE, button = 'arrow_apply_palette', shadow = true, focus_args = {button = 'b'}}, nodes={
                            {n=G.UIT.T, config={align = 'cm', text = localize('b_apply_palette'), scale = 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true, focus_args = {button = 'none'}}}
                        }},
                    }},
                }}
            }}
        }}
    }}
end