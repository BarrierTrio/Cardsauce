ArrowAPI.config_tools = {
    use_credits = function(mod, extra_args)
        mod.ARROW_USE_CREDITS = true
        extra_args = extra_args or {}
        local credit_table = ArrowAPI['credits'][mod.id] or {
            matrix = ArrowAPI.DEFAULT_CREDIT_MATRIX,
        }

        local use_default_sections = true
        if credit_table.use_default_sections ~= nil then
            use_default_sections = not not credit_table.use_default_sections
        end
        for _, arg in ipairs(extra_args) do
            if arg.key then
                local existing_table = nil
                for _, v in ipairs(credit_table) do
                    if v.key == arg.key then
                        existing_table = v
                    end
                end

                local contrib_table = (existing_table or {}).contributors or {}
                for _, v in ipairs(arg.contributors or {}) do
                    local skip = false
                    for _, vv in ipairs(contrib_table) do
                        if vv.name == v.name then
                            skip = true
                            break
                        end
                    end

                    if not skip then
                        local contrib = {
                            name = v.name,
                            name_colour = v.name_colour or G.C.UI.TEXT_LIGHT,
                            name_scale = v.name_scale or 1,
                            no_tooltip = v.no_tooltip
                        }
                        contrib_table[#contrib_table+1] = contrib
                    end
                end

                if not existing_table then
                    credit_table[#credit_table+1] = {
                        key = arg.key,
                        title_colour = arg.title_colour or SMODS.current_mod.badge_colour,
                        pos_start = arg.pos_start,
                        pos_end = arg.pos_end,
                        contributors = contrib_table
                    }

                    for i, sec in ipairs(ArrowAPI.DEFAULT_CREDIT_SECTIONS) do
                        if arg.key == sec.key then
                            -- stop using default sections if we've defined
                            -- a default section with unique dimensions
                            if arg.pos_start or arg.pos_end then use_default_sections = false end

                            -- default sections cant change their keys for ease
                            credit_table[#credit_table].key = sec.key
                            break
                        elseif i == #ArrowAPI.DEFAULT_CREDIT_SECTIONS then
                            -- or if a section is not a default section entirely
                            use_default_sections = false
                        end
                    end
                end
            end
        end

        -- create default sections
        if not credit_table.use_default_sections and use_default_sections then
            -- check for already used sections with provided info
            local used_sections = {}
            for i, v in ipairs(credit_table) do
                used_sections[v.key] = true
            end

            -- fill in any default sections without provided information
            for i = 1, #ArrowAPI.DEFAULT_CREDIT_SECTIONS do
                local key = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].key
                if not used_sections[key] then
                    credit_table[#credit_table+1] = {
                        key = key,
                        title_colour = ArrowAPI.DEFAULT_CREDIT_SECTIONS[i].title_colour,
                        contributors = {}
                    }
                end
            end
            credit_table.use_default_sections = true
        end

        ArrowAPI['credits'][mod.id] = credit_table
    end,


    use_config = function(mod, extra_args)
        mod.ARROW_USE_CONFIG = mod.ARROW_USE_CONFIG or {config_map = {}}

        if extra_args then
            for i, v in ipairs(extra_args) do
                if not mod.ARROW_USE_CONFIG.config_map[v.key] then
                    if mod.config[v.key] == nil then
                        mod.config[v.key] = (v.default_value == nil and false) or v.default_value
                    end

                    mod.ARROW_USE_CONFIG[i] = {
                        key = v.key,
                        value = mod.config[v.key],
                        exclude_from_ui = v.exclude_from_ui,
                        before_auto = v.before_auto,
                        after_auto = not v.before_auto,
                        order = v.order
                    }

                    mod.ARROW_USE_CONFIG.config_map[v.key] = i
                end
            end
        end

        -- create an ordered config based on initial config state
        for k, v in pairs(mod.config) do
            if not mod.ARROW_USE_CONFIG.config_map[k] then
                table.insert(mod.ARROW_USE_CONFIG, {key = k, value = v})
            end
        end

        ArrowAPI.config_tools.sort_config(mod)
    end,

    sort_config = function(mod)
        if not mod.ARROW_USE_CONFIG then return end
        table.sort(mod.ARROW_USE_CONFIG, function(a, b)
            if a.before_auto and not b.before_auto then return true
            elseif b.before_auto and not a.before_auto then return false

            elseif not a.after_auto and b.after_auto then return true
            elseif not b.after_auto and a.after_auto then return false
            elseif not a.exclude_from_ui and b.exclude_from_ui then return true
            elseif not b.exclude_from_ui and a.exclude_from_ui then return false
            elseif a.order and b.order then return a.order < b.order
            else return false end
        end)

        for i, v in ipairs(mod.ARROW_USE_CONFIG) do
            mod.ARROW_USE_CONFIG.config_map[v.key] = i
        end
    end,

    update_config = function(mod, key, value, order, exclude_from_ui)
        mod.config[key] = value ~= nil and value or mod.config[key]
        if mod.ARROW_USE_CONFIG then
            if not mod.ARROW_USE_CONFIG.config_map[key] then
                table.insert(mod.ARROW_USE_CONFIG, {
                    key = key, value = mod.config[key], exclude_from_ui = exclude_from_ui, order = order
                })

                ArrowAPI.config_tools.sort_config(mod)
                return
            end

            local index = mod.ARROW_USE_CONFIG.config_map[key]
            mod.ARROW_USE_CONFIG[index].value = value ~= nil and value or mod.ARROW_USE_CONFIG[index].value
            mod.ARROW_USE_CONFIG[index].order = order ~= nil and order or mod.ARROW_USE_CONFIG[index].order
            if exclude_from_ui then
                mod.ARROW_USE_CONFIG[index].exclude_from_ui = exclude_from_ui ~= nil and exclude_from_ui or mod.ARROW_USE_CONFIG[index].exclude_from_ui
            end
        end
    end
}