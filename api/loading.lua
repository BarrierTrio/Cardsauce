SMODS.Atlas({ key = 'undiscovered', path = "undiscovered.png", px = 71, py = 95 })

-- Loading helper functions
ArrowAPI.loading = {
    --- Load a batch of items from a formatted table
    --- @param args table A table of item sets to load as a batch
    batch_load = function(args)
        local priority_list = {}
        for k, v in pairs(args) do
            priority_list[#priority_list+1] = {
                key = k,
                alias = v.alias,
                load_priority = v.load_priority or 0,
                items = v.items
            }
        end
        table.sort(priority_list, function(a, b) return a.load_priority > b.load_priority end)

        for _, v in ipairs(priority_list) do
            if next(v.items) and ArrowAPI.loading.filter_loading(v.key) then
                for i, item in ipairs(v.items) do
                    ArrowAPI.loading.load_item(item, v.key, v.alias, nil, i)
                end
            end
        end
    end,

    --- Load an item definition using SMODS
    --- @param file_key string file name to load within the "Items" directory, excluding file extension
    --- @param item_type string SMODS item type (such as Joker, Consumable, Deck, etc)
    --- @param type_alias string | nil SMODS type alias (I.E. Decks are SMODS['Back'])
    --- @param folder_key string | nil folder key if needed, otherwise item_type is used
    --- @return boolean # True if the item successfuly loaded
    load_item = function(file_key, item_type, alias, folder_key, order_in_type)
        folder_key = folder_key or string.lower(item_type)..(item_type == 'VHS' and '' or 's')
        local parent_folder = 'items/'
        local info = assert(SMODS.load_file(parent_folder .. folder_key .. "/" .. file_key .. ".lua"))()

        --- generally support excluding wip items
        if info.in_progress and not ArrowAPI.current_config['enable_Wips'] then
            return false
        end

        info.key = file_key
        if item_type == 'Challenge' then
            info.button_colour = info.button_colour or SMODS.current_mod.badge_colour
        elseif item_type == 'Achievement' then
            info.atlas = SMODS.current_mod.prefix..'_achievements'
            info.order = order_in_type
            if info.rarity and info.rarity > 0 then
                info.pos = info.pos or { x = info.rarity - 1, y = 0 }
                info.hidden_pos = info.hidden_pos or {x = info.rarity - 1, y = 1}
            elseif not info.rarity then
                info.rarity = 0
            end
        elseif item_type ~= 'Edition' then
            info.atlas = file_key
            info.pos = { x = 0, y = 0 }
            if item_type == 'Stake' then
                info.sticker_atlas = file_key..'_sticker'
                info.sticker_pos = { x = 0, y = 0 }
            elseif info.hasSoul then
                info.pos = { x = 1, y = 0 }
                info.soul_pos = { x = 2, y = 0 }
            end
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

        if item_type ~= 'Deck' and item_type ~= 'Challenge' and item_type ~= 'Edition' and info.artist and ArrowAPI.current_config.enable_item_credits then
            if not ArrowAPI.credits[SMODS.current_mod.id] then
                ArrowAPI.logging.send('[ARROW] Artist credit not defined for object: '..info.key, 'warn')
            else
                local vars = {}
                if type(info.artist) == 'table' then
                    for i, v in ipairs(info.artist) do
                        vars[i] = ArrowAPI.credits[SMODS.current_mod.id][v]
                    end
                else
                    vars[1] = ArrowAPI.credits[SMODS.current_mod.id][info.artist]
                end

                local ref_loc_vars = info.loc_vars or function(self, info_queue, card) end
                function info.loc_vars(self, info_queue, card)
                    if info_queue then
                        info_queue[#info_queue+1] = {key = "artistcredit_"..#vars, set = "Other", vars = vars }
                    end
                    return ref_loc_vars(self, info_queue, card)
                end
            end
        end

        local smods_item = alias or item_type
        if not alias then
            if item_type == 'Deck' then smods_item = 'Back'
            elseif item_type == 'Stand' or item_type == 'VHS' then smods_item = 'Consumable' end
        end

        local new_item
        if SMODS[smods_item] then
            new_item = SMODS[smods_item](info)
            for k_, v_ in pairs(new_item) do
                if type(v_) == 'function' then
                    new_item[k_] = info[k_]
                end
            end
        else
            if CardSleeves and item_type == 'Sleeve' then
                new_item = CardSleeves.Sleeve(info)
                for k_, v_ in pairs(new_item) do
                    if type(v_) == 'function' then
                        new_item[k_] = info[k_]
                    end
                end
            end
        end

        if item_type == 'Challenge' or item_type == 'Achievement' or item_type == 'Edition' then
            return true
        end

        if item_type == 'Blind' then
            -- separation for animated sprites
            SMODS.Atlas({ key = file_key, atlas_table = "ANIMATION_ATLAS", path = "blinds/" .. file_key .. ".png", px = 34, py = 34, frames = 21 })
        else
            local width = 71
            local height = 95
            if item_type == 'Tag' then width = 34; height = 34
            elseif item_type == 'Sleeve' then width = 73
            elseif item_type == 'Stake' then
                width = 29
                height = 29
                SMODS.Atlas({ key = file_key..'_sticker', path = "stickers/" .. file_key .. "_sticker.png", px = 71, py = 95 })
            end
            SMODS.Atlas({ key = file_key, path = folder_key .. "/" .. file_key .. ".png", px = new_item.width or width, py = new_item.height or height })
        end
        return true
    end,

    filter_loading = function(item_type)
        if item_type == 'Sleeve' then
            return not not CardSleeves
        else
            return SMODS.current_mod.config['enable_'..item_type..'s'] ~= false
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
                    center:delete()
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
    end
}

ArrowAPI.loading.batch_load({
    Booster = {
        load_priority = 0,
        items = {
            'analog1',
            'analog2',
            'analog3',
            'analog4',
            'spirit_reg',
        }
    },

    Consumable = {
        load_priority = 0,
        items = {
            'spec_diary',
            'tarot_arrow',
        }
    },

    Tag = {
        load_priority = 0,
        items = {
            'plinkett',
            'spirit',
        }
    },

    Voucher = {
        load_priority = 0,
        items = {
            'scavenger',
            'raffle',
            'foo',
            'plant',
        }
    },
})