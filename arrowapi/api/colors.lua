local ffi = require("ffi")
SMODS.Gradient({key = 'arrow_spectrans', colours = {HEX('F98899'), HEX('5BA6DD')}, cycle = 3.5, prefix_config = false })

local function collect_image_data(set, atlases)
    collectgarbage("stop")
    local data_table = {}
    local pixel_map = {}
    for _, v in ipairs(ArrowAPI.colors.palettes[set].default_palette) do
        local color_key = v[1]..'-'..v[2]..'-'..v[3]
        local map_table = {}
        for k, _ in pairs(atlases) do
            map_table[k] = {}
        end
        pixel_map[color_key] = map_table
    end

    for k, v in pairs(atlases) do
        pixel_map[k] = {}
        local atlas = SMODS.Atlases[k]
        local file_data = NFS.newFileData(atlas.full_path)
        local image_data = love.image.newImageData(file_data)
        data_table[k] = image_data

        local ref_pointer = ffi.cast("uint8_t*", image_data:getFFIPointer())
        ffi.gc(ref_pointer, ffi.free)
        local color_width = image_data:getWidth() * 4
        local width_per_unit = atlas.px * 4
        local colors_per_unit = width_per_unit * atlas.py

        for _, item in ipairs(v) do
            local item_table = {}
            for _, color in ipairs(ArrowAPI.colors.palettes[set].default_palette) do
                local color_key = color[1]..'-'..color[2]..'-'..color[3]
                item_table[color_key] = {}
            end


            local pos = G['P_'..item.table][item.key].pos

            local prior_pixel_rows = atlas.py * pos.y
            local start_idx = prior_pixel_rows * color_width + pos.x * width_per_unit

            for i = 0, (colors_per_unit - 1), 4 do
                local true_idx = start_idx + ((i % (width_per_unit)) + (math.floor(i/(width_per_unit)) * color_width))
                if ref_pointer[true_idx + 3] > 0 then
                    local color_key = tostring(ref_pointer[true_idx]..'-'..ref_pointer[true_idx + 1]..'-'..ref_pointer[true_idx + 2])
                    if item_table[color_key] then
                        item_table[color_key][#item_table[color_key]+1] = true_idx
                    end
                end
            end

            for kk, vv in pairs(item_table) do
                if not next(vv) then
                    item_table[kk] = nil
                end
            end

            pixel_map[k][item.key] = item_table
        end

        ref_pointer = nil
    end
    collectgarbage("restart")

    return data_table, pixel_map
end

local set_order = {
    Joker = 1,
    Tarot = 2,
    Planet = 3,
    Spectral = 4,
    Voucher = 5,
    Booster = 6,
    Back = 7,
    Seal = 8,
}

local ignore_states = {
    [G.STATES.TAROT_PACK] = true,
    [G.STATES.SPECTRAL_PACK] = true,
    [G.STATES.STANDARD_PACK] = true,
    [G.STATES.BUFFOON_PACK] = true,
    [G.STATES.PLANET_PACK] = true,
    [G.STATES.SMODS_BOOSTER_OPENED] = true
}

ArrowAPI.colors = {
    palettes = {
        Background = {},
        Spectral = {},
        Planet = {},
        Tarot = {},
        Unique = {}
    },

    --- Caches the default image_data for all given palette sets
    --- @param set_list table | nil List of set keys for card types, i.e. "Tarot", "Planet"
    setup_palettes = function(set_list)
        -- background palette handled differently
        local bkg_palette = ArrowAPI.colors.palettes.Background
        local saved_bkg_palettes = ArrowAPI.config.saved_palettes['Background']
        bkg_palette.default_palette = copy_table(saved_bkg_palettes[1])

        local current_bkg = copy_table(saved_bkg_palettes[saved_bkg_palettes.saved_index])

        bkg_palette.last_palette = copy_table(current_bkg)
        bkg_palette.current_palette = current_bkg

        set_list = set_list or {"Tarot", "Planet", "Spectral"}
        for i = 1, #set_list do
            local set = set_list[i]
            local palette = ArrowAPI.colors.palettes[set]
            local items = {}

            local atlases = {}
            for k, v in pairs(G.P_CENTERS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    sendDebugMessage('collecting atlas '..v.atlas..' for item '..k)
                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'CENTERS'}
                    items[#items+1] = {key = k, table = 'CENTERS', set = v.set}
                end
            end

            for k, v in pairs(G.P_TAGS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'TAGS'}
                end
            end

            for k, v in pairs(G.P_SEALS) do
                if not v.no_collection and (v.set == set or v.palette_set == set) then
                    if not atlases[v.atlas] then
                        atlases[v.atlas] = {}
                    end

                    atlases[v.atlas][#atlases[v.atlas]+1] = {key = k, table = 'SEALS'}
                    items[#items+1] = {key = k, table = 'SEALS', set = 'Seal'}
                end
            end

            table.sort(items, function(a, b)
                return (set_order[a.set] or 0) < (set_order[b.set] or 0) or (a.order or 0) < (b.order or 0)
            end)

            palette.items = items
            ArrowAPI.config.saved_palettes[set][1].badge_colour = copy_table(G.C.SECONDARY_SET[set])
            palette.default_palette = copy_table(ArrowAPI.config.saved_palettes[set][1])

            local current_palette = copy_table(ArrowAPI.config.saved_palettes[set][ArrowAPI.config.saved_palettes[set].saved_index])
            if not current_palette.badge_colour then current_palette.badge_colour = copy_table(G.C.SECONDARY_SET[set]) end

            local data_table, pixel_map = collect_image_data(set, atlases)
            palette.image_data = {data = data_table, pixel_map = pixel_map}

            palette.last_palette = copy_table(current_palette)
            palette.current_palette = current_palette
        end
    end,

    set_background_color = function(args)
        local color_c = args.special_colour or args.new_colour
        local color_l = args.new_colour
        local color_d = args.tertiary_colour or args.new_colour
        local bright_c = 0.9
        local bright_l = 1.3
        local bright_d = 0.7
        if args.special_colour and args.tertiary_colour then
            bright_c = 1
            bright_l = 1
            bright_d = 1
        end

        G.C.BACKGROUND.C[1] = color_c[1]*bright_c - G.C.BACKGROUND.C[1]
        G.C.BACKGROUND.C[2] = color_c[2]*bright_c - G.C.BACKGROUND.C[2]
        G.C.BACKGROUND.C[3] = color_c[3]*bright_c - G.C.BACKGROUND.C[3]

        G.C.BACKGROUND.L[1] = color_l[1]*bright_l - G.C.BACKGROUND.L[1]
        G.C.BACKGROUND.L[2] = color_l[2]*bright_l - G.C.BACKGROUND.L[2]
        G.C.BACKGROUND.L[3] = color_l[3]*bright_l - G.C.BACKGROUND.L[3]

        G.C.BACKGROUND.D[1] = color_d[1]*bright_d - G.C.BACKGROUND.D[1]
        G.C.BACKGROUND.D[2] = color_d[2]*bright_d - G.C.BACKGROUND.D[2]
        G.C.BACKGROUND.D[3] = color_d[3]*bright_d - G.C.BACKGROUND.D[3]

        G.C.BACKGROUND.contrast = args.contrast - G.C.BACKGROUND.contrast
    end,

    use_custom_palette = function(set, saved_index)
        local palette = ArrowAPI.colors.palettes[set]
        if set == 'Background' then
            if  saved_index then
                -- loading from saved palette
                ArrowAPI.config.saved_palettes[set].saved_index = saved_index
                SMODS.save_mod_config(ArrowAPI)

                local saved = ArrowAPI.config.saved_palettes[set][saved_index]
                local new_palette = {name = saved.name}
                for i = 1, #palette.default_palette do
                    local default = palette.default_palette[i]
                    new_palette[i] = {key = default.key, default = true, default[1], default[2], default[3]}
                end

                for i = 1, #saved do
                    local cust_color = saved[i]
                    for j = 1, #new_palette do
                        local default_color = new_palette[j]
                        if cust_color.key == default_color.key then
                            local is_default = (cust_color[1] == default_color[1] and cust_color[2] == default_color[2] and cust_color[3] == default_color[3]) or nil
                            new_palette[j] = {key = default_color.key, default = is_default, cust_color[1], cust_color[2], cust_color[3]}
                        end
                    end
                end

                palette.current_palette = new_palette
                palette.last_palette = copy_table(new_palette)
            end

            -- update background
            for i = 1, #palette.current_palette do
                local color = palette.current_palette[i]
                for j = 1, #G.C.BLIND[color.key] do
                    G.C.BLIND[color.key][j] = color[j] and color[j]/255 or 1
                end
            end

            -- updating
            if G.GAME then
                if G.GAME.won then
                    ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.won, contrast = 1})
                else
                    local current_blind = G.GAME.blind and G.GAME.blind.config.blind
                    if G.STAGE == G.STAGES.MAIN_MENU or (current_blind and current_blind.boss and current_blind.boss.showdown) then
                        ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.SHOWDOWN_COL_2, special_colour = G.C.BLIND.SHOWDOWN_COL_1, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3})
                    elseif not ignore_states[G.STATE] then
                        ArrowAPI.colors.set_background_color({new_colour = G.C.BLIND.Small, contrast = 1})
                    end
                end
            end

            return
        end


        local custom_palette = {}
        if not saved_index then
            -- updating current palette
            local badge = palette.current_palette.badge_colour
            G.C.SECONDARY_SET[set][1] = badge[1]
            G.C.SECONDARY_SET[set][2] = badge[2]
            G.C.SECONDARY_SET[set][3] = badge[3]
            G.C.SECONDARY_SET[set][4] = badge[4]

            for i=1, #palette.current_palette do
                local last = palette.last_palette[i]
                local current = palette.current_palette[i]
                local default = palette.default_palette[i]

                if (current[1] ~= last[1] or current[2] ~= last[2] or current[3] ~= last[3]) then
                    local is_default = (current[1] == default[1] and current[2] == default[2] and current[3] == default[3])
                    palette.current_palette[i].default = is_default
                    custom_palette[#custom_palette+1] = {key = default.key, default = is_default, current[1], current[2], current[3]}
                    palette.last_palette[i] = {key = default.key, default = is_default, current[1], current[2], current[3]}
                end
            end
        else
            -- loading from saved palette
            ArrowAPI.config.saved_palettes[set].saved_index = saved_index
            SMODS.save_mod_config(ArrowAPI)

            custom_palette = ArrowAPI.config.saved_palettes[set][saved_index]
            local new_palette = {name = custom_palette.name, badge_colour = copy_table(custom_palette.badge_colour)}
            for i = 1, #palette.default_palette do
                local default = palette.default_palette[i]
                new_palette[i] = {key = default.key, default = true, default[1], default[2], default[3]}
            end

            for i = 1, #custom_palette do
                local cust_color = custom_palette[i]
                for j = 1, #new_palette do
                    local default_color = new_palette[j]
                    if cust_color.key == default_color.key then
                        local is_default = (cust_color[1] == default_color[1] and cust_color[2] == default_color[2] and cust_color[3] == default_color[3]) or nil
                        new_palette[j] = {key = default_color.key, default = is_default, cust_color[1], cust_color[2], cust_color[3]}
                    end
                end
            end

            if SMODS.Gradients[new_palette.badge_colour] then
                G.C.SECONDARY_SET[set] = SMODS.Gradients[new_palette.badge_colour]
            else
                G.C.SECONDARY_SET[set][1] = new_palette.badge_colour[1]
                G.C.SECONDARY_SET[set][2] = new_palette.badge_colour[2]
                G.C.SECONDARY_SET[set][3] = new_palette.badge_colour[3]
                G.C.SECONDARY_SET[set][4] = new_palette.badge_colour[4]
            end
            palette.current_palette = new_palette
            palette.last_palette = copy_table(new_palette)
        end

        collectgarbage("stop")
        for k, v in pairs(palette.image_data.data) do
            local edit_pointer = ffi.cast("uint8_t*", v:getFFIPointer())
            ffi.gc(edit_pointer, ffi.free)
            local pixel_map = palette.image_data.pixel_map[k]
            for i = 1, #custom_palette do
                for item, colors in pairs(pixel_map) do
                    -- todo add item filtering
                    local color_list = colors[custom_palette[i].key]
                    if color_list then
                        local replace_color = custom_palette[i]
                        for j = 1, #color_list do
                            local idx = color_list[j]
                            edit_pointer[idx] = replace_color[1]
                            edit_pointer[idx + 1] = replace_color[2]
                            edit_pointer[idx + 2] = replace_color[3]
                        end

                    end
                end
            end

            edit_pointer = nil

            SMODS.Atlases[k].image = love.graphics.newImage(v,
                { mipmaps = true, dpiscale = G.SETTINGS.GRAPHICS.texture_scaling })
        end

        collectgarbage("restart")
    end,
}

local ref_type_colour = get_type_colour
function get_type_colour(_c, card)
    local ret = ref_type_colour(_c, card)

    if _c.unlocked and not card.debuff and ArrowAPI.colors.palettes[_c.set] then
        ret = ArrowAPI.colors.palettes[_c.set].badge_colour or ret
    end

    return ret
end