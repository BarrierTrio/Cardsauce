local mod = SMODS.current_mod

SMODS.Shader {
    key = 'bootleg',
    path = 'bootleg.fs',
}

local jokerInfo = {
    name = 'Bootleg Joker',
    config = {},
    bootlegged_center = nil,
    rarity = 1,
    cost = 5,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    streamer = "joel",
}

local function reduced_set_ability(card, center)
    local new_ability = {
        name = center.name or localize{type = 'name_text', key = center.key, set = center.set} or center.key,
        effect = center.effect,
        set = center.set,
        mult = center.config.mult or 0,
        h_mult = center.config.h_mult or 0,
        h_x_mult = center.config.h_x_mult or 0,
        h_dollars = center.config.h_dollars or 0,
        p_dollars = center.config.p_dollars or 0,
        t_mult = center.config.t_mult or 0,
        t_chips = center.config.t_chips or 0,
        x_mult = center.config.Xmult or center.config.x_mult or 1,
        h_chips = center.config.h_chips or 0,
        x_chips = center.config.x_chips or 1,
        h_x_chips = center.config.h_x_chips or 1,
        h_size = center.config.h_size or 0,
        d_size = center.config.d_size or 0,
        extra = copy_table(center.config.extra) or nil,
        type = center.config.type or '',
        order = center.order or nil,
        bonus = (card.ability.bonus or 0) + (center.config.bonus or 0),
        perma_bonus = 0,
        perma_x_chips = 0,
        perma_mult = card.ability and card.ability.perma_mult or 0,
        perma_x_mult = card.ability and card.ability.perma_x_mult or 0,
        perma_h_chips = card.ability and card.ability.perma_h_chips or 0,
        perma_h_x_chips = card.ability and card.ability.perma_h_x_chips or 0,
        perma_h_mult = card.ability and card.ability.perma_h_mult or 0,
        perma_h_x_mult = card.ability and card.ability.perma_h_x_mult or 0,
        perma_p_dollars = card.ability and card.ability.perma_p_dollars or 0,
        perma_h_dollars = card.ability and card.ability.perma_h_dollars or 0,
        extra_value = card.ability.extra_value or 0,
        hands_played_at_create = G.GAME and G.GAME.hands_played or 0,
        invis_rounds = center.name == 'Invisible Joker' and 0 or nil,
        caino_xmult = center.name == 'Caino' and 1 or nil,
        yorick_discards = center.name == 'Yorick' and center.config.extra.discards,
        burnt_hand = center.name == 'Loyalty Card' and 0 or nil,
        loyalty_remaining = center.name == 'Loyalty Card' and center.config.extra.every or nil,
        csau_extra_value = 0
    }

    card.ability = {}
    for k, v in pairs(new_ability) do
        card.ability[k] = v
    end

    for k, v in pairs(center.config) do
        if not new_ability[k] then
            if type(v) == 'table' then
                card.ability[k] = copy_table(v)
            else
                card.ability[k] = v
            end
        end
    end

    -- have to do this individually
    if center.name == 'To Do List' then
        local _poker_hands = {}
        for k, v in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(k) then _poker_hands[#_poker_hands+1] = k end
        end

        card.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed('to_do'))
    end

    card.config.center.pos = center.pos
    card.config.center.atlas = center.atlas
    card:set_sprites(card.config.center)
    card:set_cost()
end

local function get_all_in_one_joker(card)
    local key, pos = pseudorandom_element(G.P_CENTER_POOLS.Joker, pseudoseed('csau_bootleg_center'))
    return pos.." . "..G.localization.descriptions.Joker[key].name
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if card.ability.bootlegged_key then
        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        local ret = card:add_to_deck(from_debuff)
        card.config.center = G.P_CENTERS['j_csau_bootleg']
        return ret
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if card.ability.bootlegged_key then
        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        local ret = card:remove_from_deck(from_debuff)
        card.config.center = G.P_CENTERS['j_csau_bootleg']
        return ret
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    if card_table.ability.bootlegged_key then
        reduced_set_ability(card, G.P_CENTERS[card_table.ability.bootlegged_key])
        card.ability.bootlegged_key = card_table.ability.bootlegged_key
    end
end

function jokerInfo.set_sprites(self, card, initial, delay_sprites)
    card.config.center.atlas = 'csau_bootleg'
    card.config.center.pos = { x = 0, y = 0 }
end

function jokerInfo.calc_dollar_bonus(self, card)
    if card.ability.bootlegged_key then
        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        local ret = card:calculate_dollar_bonus()
        card.config.center = G.P_CENTERS['j_csau_bootleg']
        return ret
    end
end

function jokerInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced and not card.debuff and not context.blueprint and not context.retrigger_joker then
        local center = G.P_CENTERS['j_turtle_bean'] --pseudorandom_element(G.P_CENTER_POOLS.Joker, pseudoseed('csau_bootleg_center'))
        reduced_set_ability(card, center)
        card.ability.bootlegged_key = center.key
        card.config.center.atlas = 'csau_bootleg'
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'name_text', key = center.key, set = center.set}, colour = G.C.IMPORTANT})

        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        card.added_to_deck = nil
        card:add_to_deck()
        card.config.center = G.P_CENTERS['j_csau_bootleg']
    end

    
    if context.end_of_round and context.main_eval and not context.blueprint and not context.retrigger_joker then  
        if card.ability.bootlegged_key then
            -- make sure values are reset
            card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
            card:remove_from_deck()
            card.config.center = G.P_CENTERS['j_csau_bootleg']
            card.ability.bootlegged_key = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    play_sound('generic1')
                    return true
                end 
            }))
        end
        reduced_set_ability(card, G.P_CENTERS['j_csau_bootleg'])   
        return
    end

    if card.ability.bootlegged_key then
        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        local ret, triggered = card:calculate_joker(context)
        card.config.center = G.P_CENTERS['j_csau_bootleg']

        return ret, triggered or true
    end
end

function jokerInfo.update(self, card, dt)
    if card.ability.bootlegged_key then
        card.config.center = G.P_CENTERS[card.ability.bootlegged_key]
        local ret = card:update(dt)
        card.config.center = G.P_CENTERS['j_csau_bootleg']
        return ret
    end
end

function jokerInfo.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    if not card then
        card = self:create_fake_card()
    end

    if card.ability and card.ability.bootlegged_key then
        local target = {
            type = 'descriptions',
            key = card.ability.bootlegged_key,
            set = 'Joker',
            nodes = desc_nodes,
            AUT = full_UI_table,
            vars =
                specific_vars or {}
        }
        local res = {}

        local obj = G.P_CENTERS[card.ability.bootlegged_key]
        if obj.loc_vars and type(obj.loc_vars) == 'function' then
            res = obj:loc_vars(info_queue, card) or {}
            target.vars = res.vars or target.vars
            target.key = res.key or target.key
            target.set = res.set or target.set
            target.scale = res.scale
            target.text_colour = res.text_colour
        end

        if desc_nodes == full_UI_table.main and not full_UI_table.name then
            full_UI_table.name = localize { type = 'name', set = target.set, key = res.name_key or target.key, nodes = full_UI_table.name, vars = {} }
        elseif desc_nodes ~= full_UI_table.main and not desc_nodes.name then
            desc_nodes.name = localize{type = 'name_text', key = res.name_key or target.key, set = target.set }
        end

        if specific_vars and specific_vars.debuffed and not res.replace_debuff then
            target = { type = 'other', key = 'debuffed_default', nodes = desc_nodes, AUT = full_UI_table }
        end

        if res.main_start then
            desc_nodes[#desc_nodes + 1] = res.main_start
        end

        localize(target)

        if res.main_end then
            desc_nodes[#desc_nodes + 1] = res.main_end
        end

        desc_nodes.background_colour = res.background_colour
        return
    end

    info_queue[#info_queue+1] = {key = "csau_artistcredit", set = "Other", vars = { G.csau_team.gote } }
    if csau_config['detailedDescs'] then
        localize{type = 'descriptions', key = self.key.."_detailed", set = self.set, nodes = desc_nodes, vars = self.loc_vars and self.loc_vars(self, info_queue, card).vars or {}}
    else
        set_discover_tallies()
        local tally = G.DISCOVER_TALLIES.jokers.of
        local main_start = {
            {n=G.UIT.T, config={text = tally..localize('a_in_one'), colour = G.C.DARK_EDITION, scale = 0.4}},
        }
        local main_end = {
            {n=G.UIT.O, config={object = DynaText(
                    {string = {
                        {string = '0 . rand()', colour = G.C.JOKER_GREY},
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card),
                        get_all_in_one_joker(card)
                    },
                        colours = {G.C.UI.TEXT_DARK},
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    }
            )}},
        }
        desc_nodes[#desc_nodes+1] = main_start
        desc_nodes[#desc_nodes+1] = main_end
    end
end

function jokerInfo.draw(self, card, layer)
    if card.ability.bootlegged_key then
        G.SHADERS['csau_bootleg']:send('primary_color',   {1.0, 0.0, 0.0}) -- default red
        G.SHADERS['csau_bootleg']:send('secondary_color', {1.0, 1.0, 0.0}) -- default yellow
        G.SHADERS['csau_bootleg']:send('tertiary_color',  {0.0, 0.0, 1.0}) -- default blue
        G.SHADERS['csau_bootleg']:send('gamma', 1.5) -- default 1.5 (changes constrast)
        card.children.center:draw_shader('csau_bootleg', nil, card.ARGS.send_to_shader)
    end
end

return jokerInfo
	