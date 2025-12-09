ArrowAPI.misc = {
    --- Sets the fronts of all current playing cards
    --- @param juice boolean bool to juice playing cards
    set_fronts = function(juice)
        for _, v in pairs(G.I.CARD) do
            if v.config and v.config.card and v.children.front and v.config.center.key ~= 'm_stone' then
                v:set_sprites(nil, v.config.card)
                if juice then v:juice_up() end
            end
        end
    end,

    --- Assign results from challenge functions to their respective fields
    --- @param ch table challenge object table
    run_challenge_functions = function(ch)
        if not ch.restrictions then return end

        if ch.restrictions.banned_cards then
            if type(ch.restrictions.banned_cards) == 'function' then
                ch.restrictions.banned_cards = ch.restrictions.banned_cards()
            end

            if ch.restrictions.banned_cards.allowed then
                local bans = {}
                local allow_map = {}
                local allow_list = {}
                for _, sets in pairs(ch.restrictions.banned_cards.allowed) do
                    for _, info in ipairs(sets) do
                        allow_list[#allow_list+1] = { id = info.id, ids = info.ids }
                        allow_map[info.id] = true
                        for _, id in ipairs(info.ids or {}) do allow_map[id] = true end
                    end
                end

                for k, center in pairs(G.P_CENTERS) do
                    if not allow_map[k] and ch.restrictions.banned_cards.allowed[center.set] then
                        bans[#bans+1] = k
                    end
                end

                ch.restrictions.banned_cards = {{id = 'j_joker', ids = bans}}
                ch.restrictions.allowed_cards = allow_list
            else
                 local temp_cards = {}
                for _, v in ipairs(ch.restrictions.banned_cards) do
                    if G.P_CENTERS[v.id] then
                        local temp_ids = nil
                        if v.ids then
                            temp_ids = {}
                            for _, vv in pairs(v.ids) do
                                if G.P_CENTERS[vv] then
                                    temp_ids[#temp_ids+1] = vv
                                end
                            end
                        end
                        temp_cards[#temp_cards+1] = {id = v.id, ids = temp_ids}
                    end
                end
                ch.restrictions.banned_cards = temp_cards
            end
        end

        if ch.restrictions.banned_tags then
            if type(ch.restrictions.banned_tags) == 'function' then
                ch.restrictions.banned_tags = ch.restrictions.banned_tags()
            end

            local temp_tags = {}
            for _, v in ipairs(ch.restrictions.banned_tags) do
                if G.P_TAGS[v.id] then
                    local temp_ids = nil
                    if v.ids then
                        temp_ids = {}
                        for _, vv in pairs(v.ids) do
                            if G.P_TAGS[vv] then
                                temp_ids[#temp_ids+1] = vv
                            end
                        end
                    end
                    temp_tags[#temp_tags+1] = {id = v.id, ids = temp_ids}
                end
            end

            ch.restrictions.banned_tags = temp_tags
        end

        if ch.restrictions.banned_other then
            if type(ch.restrictions.banned_other) == 'function' then
                ch.restrictions.banned_other = ch.restrictions.banned_other()
            end

            if ch.restrictions.banned_other.allowed then
                local bans = {}
                local allow_map = {}
                local allow_list = {}
                for _, blind in pairs(ch.restrictions.banned_other.allowed) do
                    allow_list[#allow_list+1] = { id = blind.id, type = 'blind' }
                    allow_map[blind.id] = true
                end

                for k, _ in pairs(G.P_BLINDS) do
                    if not allow_map[k] then
                        bans[#bans+1] = { id = k, type = 'blind' }
                    end
                end

                ch.restrictions.banned_other = bans
                ch.restrictions.allowed_other = allow_list
            else
                local temp_other = {}
                for _, v in ipairs(ch.restrictions.banned_other) do
                    if G.P_BLINDS[v.id] then
                        temp_other[#temp_other+1] = {id = v.id, type = 'blind'}
                    end
                end
                ch.restrictions.banned_other = temp_other
            end
        end
    end,

    add_colors = function(args)
        if not G.ARGS.LOC_COLOURS then loc_colour() end
        for k, v in pairs(args) do
            G.C[k] = v
            G.ARGS.LOC_COLOURS[string.lower(k)] = G.C[k]
        end
    end,

    predict_gradient = function(grad, delay)
        if #grad.colours < 2 then return end
        local timer = (G.TIMERS.REAL + (delay or 0))%grad.cycle
        local start_index = math.ceil(timer*#grad.colours/grad.cycle)
        local end_index = start_index == #grad.colours and 1 or start_index+1
        local start_colour, end_colour = grad.colours[start_index], grad.colours[end_index]
        local partial_timer = (timer%(grad.cycle/#grad.colours))*#grad.colours/grad.cycle

        local ret = {0, 0, 0, 1}
        for i = 1, 4 do
            if grad.interpolation == 'linear' then
                ret[i] = start_colour[i] + partial_timer*(end_colour[i]-start_colour[i])
            elseif grad.interpolation == 'trig' then
                ret[i] = start_colour[i] + 0.5*(1-math.cos(partial_timer*math.pi))*(end_colour[i]-start_colour[i])
            end
        end

        return ret
    end,

    title_calculate = function(context)
        SMODS.push_to_context_stack(context, "utils.lua : SMODS.calculate_context")
        local mods = {}
        for _, mod in ipairs(SMODS.get_mods_scoring_targets()) do
            mods[#mods + 1] = { object = mod}
        end

        local flags = {}
        context.title_calculate = true
        for _, mod in ipairs(mods) do
            if not SMODS.check_looping_context(mod.object) then
                SMODS.current_evaluated_object = mod.object
                SMODS.push_to_context_stack(context, "utils.lua : SMODS.eval_individual")
                local eval = {}
                local eff = mod.object:calculate(context)
                if eff == true then eff = { remove = true } end
                if type(eff) ~= 'table' then eff = nil end
                SMODS.pop_from_context_stack(context, "utils.lua : SMODS.eval_individual")
                local f = SMODS.trigger_effects({eval})
                for k,v in pairs(f) do flags[k] = v end
                SMODS.update_context_flags(context, flags)
            end
        end

        SMODS.current_evaluated_object = nil
        context.title_calculate = nil

        SMODS.pop_from_context_stack(context, "utils.lua : SMODS.calculate_context")

        local ret = {}
        for _, f in ipairs(flags) do
            for k,v in pairs(f) do ret[k] = v end
        end
        return ret
    end,
}