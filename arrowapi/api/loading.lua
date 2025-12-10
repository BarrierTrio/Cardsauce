SMODS.Atlas({ key = 'arrow_undiscovered', path = "undiscovered.png", px = 71, py = 95, prefix_config = false })

ArrowAPI.loading = {
    --- Load a batch of items from a formatted table
    --- @param args table A table of item sets to load as a batch
    batch_load = function(args)
        args.config = args.config or {}
        local mod = SMODS.current_mod
        ArrowAPI.BATCH_LOAD = mod.id
        local priority_list = {}
        for k, v in pairs(args) do
            if k ~= 'config' then
                priority_list[#priority_list+1] = {
                    key = k,
                    alias = v.alias,
                    order = v.order,
                    items = v.items
                }
            end
        end
        table.sort(priority_list, function(a, b)
            if a.order and not b.order then return true
            elseif b.order and not a.order then return false
            elseif a.order and b.order then return a.order < b.order
            else return false end
        end)

        for order, v in ipairs(priority_list) do
            if next(v.items) and ArrowAPI.loading.filter_type(v.key, order) then
                for i, item in ipairs(v.items) do
                    ArrowAPI.loading.load_item(item, v.key, v.alias, args.config.parent_folder, i, mod, args.config.mod_prefix)
                end

                if mod.ARROW_USE_CONFIG and v.key ~= 'SoundPack' then
                    -- add to ordered config list
                    local key = 'enable_'..v.key..'s'
                    if mod.config[key] == nil then
                        ArrowAPI.config_tools.update_config(mod, key, true, nil)
                        ArrowAPI.loading.write_default_config(mod)
                    else
                        ArrowAPI.config_tools.update_config(mod, key, true, nil, false)
                    end
                end
            end
        end
        ArrowAPI.BATCH_LOAD = nil
    end,

    --- Load an item definition using SMODS
    --- @param file_key string file name to load within the "Items" directory, excluding file extension
    --- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
    --- @param alias string | nil SMODS type alias (I.E. Decks are SMODS['Back'])
    --- @param folder_key string | nil folder key if needed, otherwise item_type is used
    --- @return boolean # True if the item successfuly loaded
    load_item = function(file_key, item_type, alias, parent_folder, order_in_type, mod, mod_prefix)
        mod = mod or SMODS.current_mod
        folder_key = string.lower(item_type)..(item_type == 'VHS' and '' or 's')
        parent_folder = parent_folder or 'items/'
        local info = assert(SMODS.load_file(parent_folder .. folder_key .. "/" .. file_key .. ".lua"))()

        if not ArrowAPI.loading.filter_item(info) or (not ArrowAPI.BATCH_LOAD and not ArrowAPI.loading.filter_type(item_type, order_in_type)) then
            return false
        end

        local smods_item = alias or item_type
        if not alias then
            if item_type == 'Deck' then smods_item = 'Back'
            elseif item_type == 'Stand' or item_type == 'VHS' then smods_item = 'Consumable' end
        end

        info.key = file_key

        local skip_atlas = not not info.atlas
        if item_type == 'Challenge' then
            info.button_colour = info.button_colour or SMODS.current_mod.badge_colour
        elseif item_type == 'Achievement' then
            info.atlas = SMODS.current_mod.prefix..'_achievements'

            -- want to generalize this but a lot of other items do custom order behavior
            info.order = order_in_type and SMODS[smods_item].obj_buffer and (#SMODS[smods_item].obj_buffer + order_in_type)
            if info.rarity and info.rarity > 0 then
                info.pos = info.pos or { x = info.rarity - 1, y = 0 }
                info.hidden_pos = info.hidden_pos or {x = info.rarity - 1, y = 1}
            elseif not info.rarity then
                info.rarity = 0
            end
        elseif item_type ~= 'Edition' then
            info.atlas = info.atlas or file_key
            info.pos = info.pos or { x = 0, y = 0 }
            if item_type == 'Stake' then
                info.sticker_atlas = file_key..'_sticker'
                info.sticker_pos = { x = 0, y = 0 }
            elseif info.hasSoul then
                info.pos = { x = 1, y = 0 }
                info.soul_pos = { x = 2, y = 0 }
            end
        end

        if mod_prefix then
            if info.atlas and (not info.prefix_config or info.prefix_config.atlas == nil) then
                info.atlas = mod_prefix..'_'..info.atlas
            end

            if info.prefix_config ~= false then
                info.prefix_config = info.prefix_config or {}

                info.prefix_config.key = info.prefix_config.key or {}
                info.prefix_config.key.mod = false

                info.prefix_config.atlas = false
            end
            info.key = mod_prefix..'_'..info.key
        end

        -- this is handled by an SMODS.add_mod_badges hook
        if info.origin then
            info.no_mod_badges = true
        end

        if item_type == 'Stand' or item_type == 'VHS' then
            -- add universal set_consumable_usage() for stands
            local ref_add_to_deck = info.add_to_deck or function(self, card, from_debuff) end
            function info.add_to_deck(self, card, from_debuff)
                -- only set initially
                if not from_debuff then
                    set_consumeable_usage(card)
                end
                return ref_add_to_deck(self, card, from_debuff)
            end

            -- force no use for stands
            if item_type == 'Stand' then
                function info.can_use(self, card)
                    return false
                end

                if info.rarity == 'EvolvedRarity' then
                    local ref_card_type_badge = info.set_card_type_badge or function(self, card, badges) end
                    function info.set_card_type_badge(self, card, badges)
                        badges[1] = create_badge(localize('k_evolved_stand'), get_type_colour(self or card.config, card), nil, 1.2)
                        return ref_card_type_badge(self, card)
                    end
                end
            end
        end

        if item_type ~= 'Deck' and item_type ~= 'Challenge' and item_type ~= 'Edition' then
            local ref_loc_vars = info.loc_vars or function(self, info_queue, card) end
            function info.loc_vars(self, info_queue, card)
                if info_queue and ArrowAPI.current_config['enable_ItemCredits'] then
                    local vars = (type(info.artist) == 'function' and info:artist()) or (type(info.artist) == 'table' and info.artist) or {info.artist}
                    info_queue[#info_queue+1] = {key = "artistcredit_"..#vars, set = "Other", vars = vars }

                    -- add this automatically
                    if item_type == 'VHS' then
                        info_queue[#info_queue+1] = {key = "vhs_activation", set = "Other"}
                    end
                end

                local ret = ref_loc_vars(self, info_queue, card)

                -- always supply runtime vars
                if item_type == 'VHS' then
                    ret = ret or {}
                    ret.vars = ret.vars or {}
                    table.insert(ret.vars, card.ability.runtime-card.ability.uses)
                end

                if ret and ret.key == self.key and ArrowAPI.current_config['enable_DetailedDescs'] then
                    ret.key = ret.key..'_detailed'
                end
                return ret
            end
        end

        local new_item
        if SMODS[smods_item] then
            new_item = SMODS[smods_item](info)
        else
            if item_type == 'SoundPack' then
                new_item = TNSMI.SoundPack(info)
            elseif CardSleeves and item_type == 'Sleeve' then
                new_item = CardSleeves.Sleeve(info)
            elseif Partner_API and item_type == 'Partner' then
                new_item = Partner_API.Partner(info)
            end
        end

        assert(new_item, 'Item '..info.key..' of type '..item_type..' failed to load')

        for k_, v_ in pairs(new_item) do
            if type(v_) == 'function' then
                new_item[k_] = info[k_]
            end
        end

        if info.pools and next(info.pools) then
            for k, _ in pairs(info.pools) do
                if G.P_CENTER_POOLS[k] and k ~= new_item.set then
                    SMODS.insert_pool(G.P_CENTER_POOLS[k], new_item)
                end
            end
        end

        if mod.ARROW_USE_CREDITS then
            for _, v in ipairs(ArrowAPI.credits[mod.id]) do
                if new_item[v.key] then
                    local names = new_item[v.key]
                    if type(names) ~= 'table' then names = {names} end
                    for _, name in ipairs(names) do
                        local found_contrib = false
                        for i = #v.contributors, 1, -1 do
                            if v.contributors[i].name == name then
                                found_contrib = true
                                v.contributors[i][#v.contributors[i]+1] = {
                                    key = new_item.key,
                                    item_type = smods_item
                                }
                            end
                        end

                        if not found_contrib then
                            table.insert(v.contributors, {
                                name = name,
                                name_colour = G.C.UI.TEXT_LIGHT,
                                name_scale = 1,
                                {key = new_item.key, item_type = smods_item}
                            })
                        end
                    end
                end
            end
        end

        if not ArrowAPI.BATCH_LOAD and mod.ARROW_USE_CONFIG and item_type ~= 'SoundPack' then
            local key = 'enable_'..item_type..'s'
            if mod.config[key] == nil then
                ArrowAPI.config_tools.update_config(mod, key, true, nil)
                ArrowAPI.loading.write_default_config(mod)
            else
                ArrowAPI.config_tools.update_config(mod, key, true, nil, false)
            end
        end

        if skip_atlas or item_type == 'Challenge' or item_type == 'Achievement' or item_type == 'Edition' then
            return true
        end

        local atlas_key = mod_prefix and mod_prefix..'_'..file_key or file_key
        if item_type == 'Blind' then
            -- separation for animated sprites
            SMODS.Atlas({ key = atlas_key, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. file_key .. ".png", px = 34, py = 34, frames = 21, prefix_config = mod_prefix and false or nil })
        else
            local width = 71
            local height = 95
            if item_type == 'Tag' then width = 34; height = 34
            elseif item_type == 'Sleeve' then width = 73
            elseif item_type == 'Stake' then
                width = 29
                height = 29
                SMODS.Atlas({ key = atlas_key..'_sticker', path = "stickers/" ..file_key .. "_sticker.png", px = 71, py = 95, prefix_config = mod_prefix and false or nil })
            elseif item_type == 'SoundPack' then
                if info.atlas == 'arrow_sp_default' then return true end
                height = 71
            end
            local atlas_args = {
                key = atlas_key,
                path = folder_key .. "/" .. file_key .. ".png",
                px = new_item.width or width,
                py = new_item.height or height,
                prefix_config = mod_prefix and false or nil
            }

            if info.animation then
                atlas_args.frames = info.animation.frames
                atlas_args.fps = info.animation.fps
                atlas_args.atlas_table = 'ANIMATION_ATLAS'
            end

            SMODS.Atlas(atlas_args)
        end
        return true
    end,

    write_default_config = function(mod)
        local success = pcall(function()
            NFS.createDirectory('config')
            assert(mod.config and next(mod.config))
            local current_config = 'return '..serialize(mod.config)
            NFS.write(('config/%s.jkr'):format(mod.id), current_config)
            NFS.write(mod.path..(mod.config_file or 'config.lua'), current_config)
        end)
        return success
    end,

    --- Simple wrapper for SMODS.DeckSkin to automatically table card credits
    ---
    load_deckskin = function(args)
        if SMODS.current_mod.ARROW_USE_CREDITS then
            local credits = nil
            for i, v in ipairs(ArrowAPI.credits[SMODS.current_mod.id]) do
                if v.key == 'artist' then
                    credits = v
                    break
                end
            end

            if not credits then return SMODS.DeckSkin(args) end

            for _, v in ipairs(args.palettes or {}) do
                local artist_table = type(v.artist) == 'table' and v.artist or {v.artist}
                for _, artists in pairs(artist_table) do
                    local names = (artists) == 'table' and artists or {artists}
                    for _, name in ipairs(names) do
                        local found_contrib = false
                        for i = #credits, 1, -1 do
                            if credits[i].name == name then
                                found_contrib = true
                                credits[i][#credits[i]+1] = {
                                    key = v.key,
                                    item_type = 'DeckSkin'
                                }
                            end
                        end

                        if not found_contrib then
                            table.insert(credits, {name = name, name_colour = G.C.UI.TEXT_LIGHT, name_scale = 1})
                        end
                    end
                end
            end
        end

        return SMODS.DeckSkin(args)
    end,

    filter_item = function(item)
        if item.dependencies then
            for k, _ in pairs(item.dependencies.config or {}) do
                if SMODS.current_mod.config['enable_'..k] == false then
                    return false
                end
            end

            for k, _ in pairs(item.dependencies.mods or {}) do
                if not next(SMODS.find_mod(k)) then return false end
            end
        end

        return true
    end,

    filter_type = function(item_type, order)
         if (item_type == 'Sleeve' and not CardSleeves) or (item_type == 'Partner' and not Partner_API) then
            ArrowAPI.config_tools.update_config(SMODS.current_mod, 'enable_'..item_type..'s', nil, nil, true)
            return false
        else
            local enabled = SMODS.current_mod.config['enable_'..item_type..'s']
            if enabled == false then return false end

            return true
        end
    end,

    --- Returns whether an SMODS.ConsumableType has any added items, excluding items set as no_collection
    --- @param set string Set string for a ConsumableType
    consumeable_has_items = function(set)
        if set == 'Stand' then
            return not not (#G.P_CENTER_POOLS['StandPool'] > 0 or #G.P_CENTER_POOLS['EvolvedPool'] > 0)
        end

        return #G.P_CENTER_POOLS[set] > 0
    end,

    disable_empty = function()
        if not ArrowAPI.startup_item_check then
            local disable_map = {}
            local disabled_any = false
            ArrowAPI.startup_item_check = true
            for k, v in pairs(SMODS.ConsumableTypes) do
                if not ArrowAPI.loading.consumeable_has_items(k) then
                    ArrowAPI.logging.send('[ArrowAPI] disabling '..k)

                    SMODS.ConsumableType:take_ownership(k, {
                        no_collection = true,
                        no_doe = true,
                        unlock_condition = nil,
                    }, true)

                    disable_map[k] = true
                    disabled_any = true

                    local index = nil
                    for i, key in ipairs(SMODS.ConsumableType.visible_buffer) do
                        if key == k then index = i end
                    end

                    if index then table.remove(SMODS.ConsumableType.visible_buffer, index) end
                end
            end

            if not disabled_any then return end

            for _, center in pairs(G.P_CENTERS) do
                if disable_map[center.requires_type] then
                    center.no_collection = true
                    center.no_doe = true
                    center.unlock_condition = nil
                    center.unlocked = false
                    center.discovered = false
                end
            end

            for key, tag in pairs(G.P_TAGS) do
                if disable_map[tag.requires_type] then
                    G.P_TAGS[key] = nil
                    SMODS.remove_pool(G.P_CENTER_POOLS[tag.set], key)

                    local j
                    for i, v in ipairs(tag.obj_buffer) do
                        if v == key then j = i end
                    end
                    if j then table.remove(tag.obj_buffer, j) end
                    tag = nil
                end
            end
        end
    end,

    --- Recursively finds the full file tree at a specified path
    --- @param folder string The folder path to enumerate. Function fails if folder is not an OS directory
    --- @return string fileTree A string, separated by newlines, of all enumerated paths
    recursive_file_enumerate = function(folder)
        local fileTree = ""
        for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
            local path = folder .. "/" .. file
            local info = love.filesystem.getInfo(path)
            fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
            if info.type == "directory" then
                fileTree = fileTree .. ArrowAPI.loading.recursive_file_enumerate(path)
            end
        end
        return fileTree
    end,
}

ArrowAPI.loading.batch_load({
    config = {
        parent_folder = 'arrowapi/items/',
	    mod_prefix = 'arrow',
    },

    Consumable = {
        order = 1,
        items = {
            'spec_diary',
            'tarot_arrow',
        }
    },

    Voucher = {
        order = 2,
        items = {
            'scavenger',
            'raffle',
            'foo',
            'plant',
        }
    },


    Booster = {
        order = 3,
        items = {
            'analog1',
            'analog2',
            'analog3',
            'analog4',
            'spirit_reg',
        }
    },

    Tag = {
        order = 4,
        items = {
            'plinkett',
            'spirit',
        }
    },
})