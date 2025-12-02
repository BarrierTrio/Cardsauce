local jokerInfo = {
    name = "IT'S ME AUSTIN",
    config = {
        extra = {
            mult = 20,
        },
    },
    rarity = 1,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    pools = {
        ["Meme"] = true
    },
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },

    artist = 'ABBurlap'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

function jokerInfo.check_for_unlock(self, args)
    if args.type == "defeat_wall" then
        return true
    end
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and context.cardarea == G.jokers then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

-- TODO: replace austin blind mystery with SMODS/arrow blind behavior
SMODS.Atlas({ key = 'mystery', atlas_table = "ANIMATION_ATLAS", path = "blinds/mystery.png", px = 34, py = 34, frames = 21, })

local c_ui_bc_ref = create_UIBox_blind_choice
function create_UIBox_blind_choice(type, run_info)
    local ref = c_ui_bc_ref(type, run_info)
    if type == "Boss" and next(SMODS.find_card('j_csau_itsmeaustin')) then
        local disabled = false

        local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
        local blind_choice = {
            config = G.P_BLINDS[G.GAME.round_resets.blind_choices[type]],
        }
        blind_choice.animation = AnimatedSprite(0,0, 1.4, 1.4, G.ANIMATION_ATLAS['csau_mystery'] or G.ANIMATION_ATLAS['blind_chips'], G.P_BLINDS.bl_small.pos)
        blind_choice.animation:define_draw_steps({
            {shader = 'dissolve', shadow_height = 0.05},
            {shader = 'dissolve'}
        })

        local dt1 = DynaText({string = {{string = localize('ph_up_ante_1'), colour = G.C.FILTER}}, colours = {G.C.BLACK}, scale = 0.55, silent = true, pop_delay = 4.5, shadow = true, bump = true, maxw = 3})
        local dt2 = DynaText({string = {{string = localize('ph_up_ante_2'), colour = G.C.WHITE}},colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})
        local dt3 = DynaText({string = {{string = localize('ph_up_ante_3'), colour = G.C.WHITE}},colours = {G.C.CHANCE}, scale = 0.35, silent = true, pop_delay = 4.5, shadow = true, maxw = 3})
        local extras =
        {n=G.UIT.R, config={align = "cm"}, nodes={
            {n=G.UIT.R, config={align = "cm", padding = 0.07, r = 0.1, colour = {0,0,0,0.12}, minw = 2.9}, nodes={
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={object = dt1}},
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={object = dt2}},
                }},
                {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={object = dt3}},
                }},
            }},
        }}

        local target = {type = 'raw_descriptions', key = 'csau_mystery', set = 'Blind', vars = {}}
        local loc_target = localize(target)
        local loc_name = localize('k_unknown')
        local text_table = loc_target
        local blind_amt = localize('k_unknown')
        local blind_desc_nodes = {}
        for k, v in ipairs(text_table) do
            blind_desc_nodes[#blind_desc_nodes+1] = {n=G.UIT.R, config={align = "cm", maxw = 2.8}, nodes={
                {n=G.UIT.T, config={text = v or '-', scale = 0.32, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
            }}
        end

        local blind_col = HEX('762929')
        local blind_state = G.GAME.round_resets.blind_states[type]
        local run_info_colour = run_info and (blind_state == 'Defeated' and G.C.GREY or blind_state == 'Skipped' and G.C.BLUE or blind_state == 'Upcoming' and G.C.ORANGE or blind_state == 'Current' and G.C.RED or G.C.GOLD)

        local _reward = true
        if G.GAME.modifiers.no_blind_reward and G.GAME.modifiers.no_blind_reward[type] then _reward = nil end

        local t =
        {n=G.UIT.R, config={id = type, align = "tm", func = 'blind_choice_handler', minh = not run_info and 10 or nil, ref_table = {deck = nil, run_info = run_info}, r = 0.1, padding = 0.05}, nodes={
            {n=G.UIT.R, config={align = "cm", colour = mix_colours(G.C.BLACK, G.C.L_BLACK, 0.5), r = 0.1, outline = 1, outline_colour = G.C.L_BLACK}, nodes={
                {n=G.UIT.R, config={align = "cm", padding = 0.2}, nodes={
                    not run_info and {n=G.UIT.R, config={id = 'select_blind_button', align = "cm", ref_table = blind_choice.config, colour = disabled and G.C.UI.BACKGROUND_INACTIVE or G.C.ORANGE, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, shadow = true, hover = true, one_press = true, button = 'select_blind'}, nodes={
                        {n=G.UIT.T, config={ref_table = G.GAME.round_resets.loc_blind_states, ref_value = type, scale = 0.45, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.UI.TEXT_LIGHT, shadow = not disabled}}
                    }} or
                            {n=G.UIT.R, config={id = 'select_blind_button', align = "cm", ref_table = blind_choice.config, colour = run_info_colour, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, emboss = 0.08}, nodes={
                                {n=G.UIT.T, config={text = localize(blind_state, 'blind_states'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                            }}
                }},
                {n=G.UIT.R, config={id = 'blind_name',align = "cm", padding = 0.07}, nodes={
                    {n=G.UIT.R, config={align = "cm", r = 0.1, outline = 1, outline_colour = blind_col, colour = darken(blind_col, 0.3), minw = 2.9, emboss = 0.1, padding = 0.07, line_emboss = 1}, nodes={
                        {n=G.UIT.O, config={object = DynaText({string = loc_name, colours = {disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE}, shadow = not disabled, float = not disabled, y_offset = -4, scale = 0.45, maxw =2.8})}},
                    }},
                }},
                {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                    {n=G.UIT.R, config={id = 'blind_desc', align = "cm", padding = 0.05}, nodes={
                        {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.R, config={align = "cm", minh = 1.5}, nodes={
                                {n=G.UIT.O, config={object = blind_choice.animation}},
                            }},
                            text_table[1] and {n=G.UIT.R, config={align = "cm", minh = 0.7, padding = 0.05, minw = 2.9}, nodes = blind_desc_nodes} or nil,
                        }},
                        {n=G.UIT.R, config={align = "cm",r = 0.1, padding = 0.05, minw = 3.1, colour = G.C.BLACK, emboss = 0.05}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 3}, nodes={
                                {n=G.UIT.T, config={text = localize('ph_blind_score_at_least'), scale = 0.3, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}}
                            }},
                            {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                                {n=G.UIT.O, config={w=0.5,h=0.5, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
                                {n=G.UIT.B, config={h=0.1,w=0.1}},
                                {n=G.UIT.T, config={text = number_format(blind_amt), scale = score_number_scale(0.9, blind_amt), colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.RED, shadow =  not disabled}}
                            }},
                            _reward and {n=G.UIT.R, config={align = "cm"}, nodes={
                                {n=G.UIT.T, config={text = localize('ph_blind_reward'), scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}},
                                {n=G.UIT.T, config={text = string.rep(localize("$"), blind_choice.config.dollars)..'+', scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY, shadow = not disabled}}
                            }} or nil,
                        }},
                    }},
                }},
            }},
            {n=G.UIT.R, config={id = 'blind_extras', align = "cm"}, nodes={
                extras,
            }}
        }}
        return t
    else
        return ref
    end
end

local gbmc_ref = get_blind_main_colour
function get_blind_main_colour(blind)
    local ref = gbmc_ref(blind)
    if blind == 'Boss' and G.STATE == G.STATES.BLIND_SELECT and next(SMODS.find_card('j_csau_itsmeaustin')) then
        return HEX('762929')
    else
        return ref
    end
end

local reveal_boss = function(e)
    stop_use()
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            play_sound('other1')
            G.blind_select_opts.boss:set_role({xy_bond = 'Weak'})
            G.blind_select_opts.boss.alignment.offset.y = 20
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = (function()
            local par = G.blind_select_opts.boss.parent

            G.blind_select_opts.boss:remove()
            G.blind_select_opts.boss = UIBox{
                T = {par.T.x, 0, 0, 0, },
                definition =
                {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                    UIBox_dyn_container({create_UIBox_blind_choice('Boss')},false,get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
                }},
                config = {align="bmi",
                          offset = {x=0,y=G.ROOM.T.y + 9},
                          major = par,
                          xy_bond = 'Weak'
                }
            }
            par.config.object = G.blind_select_opts.boss
            par.config.object:recalculate()
            G.blind_select_opts.boss.parent = par
            G.blind_select_opts.boss.alignment.offset.y = 0

            G.E_MANAGER:add_event(Event({blocking = false, trigger = 'after', delay = 0.5,func = function()
                G.CONTROLLER.locks.boss_reroll = nil
                return true
            end
            }))

            save_run()
            for i = 1, #G.GAME.tags do
                if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
            end
            return true
        end)
    }))
end

function jokerInfo.add_to_deck(self, card)
    if G.STATE == G.STATES.BLIND_SELECT then
        reveal_boss()
    end
end

function jokerInfo.remove_from_deck(self, card)
    if G.STATE == G.STATES.BLIND_SELECT then
        reveal_boss()
    end
end

return jokerInfo