SMODS.Atlas({key = 'stand_blank', path = 'blank.png', px = 93, py = 179})
SMODS.Atlas({key = 'stand_blank_evolved', path = 'blank_evolved.png', px = 93, py = 179})
SMODS.Atlas({key = 'stand_stickers', path = "stand_stickers.png", px = 71, py = 95})

SMODS.Sticker{key = "Stand_White", atlas = 'arrow_stand_stickers', pos = { x = 0, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Red", atlas = 'arrow_stand_stickers', pos = { x = 1, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Green", atlas = 'arrow_stand_stickers', pos = { x = 2, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Black", atlas = 'arrow_stand_stickers', pos = { x = 3, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Blue", atlas = 'arrow_stand_stickers', pos = { x = 4, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Purple", atlas = 'arrow_stand_stickers', pos = { x = 5, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Orange", atlas = 'arrow_stand_stickers', pos = { x = 6, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}
SMODS.Sticker{key = "Stand_Gold", atlas = 'arrow_stand_stickers', pos = { x = 7, y = 0 }, rate = 0, should_apply = false, no_collection = true, no_doe = true}

G.sticker_map['arrow_Stand_White'] = 'White'
G.sticker_map['arrow_Stand_Red'] = 'Red'
G.sticker_map['arrow_Stand_Green'] = 'Green'
G.sticker_map['arrow_Stand_Black'] = 'Black'
G.sticker_map['arrow_Stand_Blue'] = 'Blue'
G.sticker_map['arrow_Stand_Purple'] = 'Purple'
G.sticker_map['arrow_Stand_Orange'] = 'Orange'
G.sticker_map['arrow_Stand_Gold'] = 'Gold'

-- stand pool
SMODS.ObjectType {
    default = 'c_arrow_stardust_star',
    key = 'StandPool',
    prefix_config = false,
}

-- evolved stand pool
SMODS.ObjectType {
    default = 'c_arrow_stardust_star',
    key = 'EvolvedPool',
    prefix_config = false,
}

SMODS.Rarity {
    key = 'StandRarity',
    default_weight = 1,
    no_mod_badges = true,
    prefix_config = false,
    badge_colour = 'FFFFFF'
}

SMODS.Rarity {
    key = 'EvolvedRarity',
    default_weight = 0,
    no_mod_badges = true,
    prefix_config = false,
    badge_colour = 'FFFFFF',
    get_weight = function(self, weight, object_type)
        return G.GAME.used_vouchers.v_arrow_plant and 0.12 or 0
    end
}

-- Stand Consumable

SMODS.UndiscoveredSprite {
    key = "Stand",
    atlas = "arrow_undiscovered",
    pos = { x = 1, y = 0 },
    overlay_pos = { x = 2, y = 0 }
}
SMODS.ConsumableType {
    key = 'Stand',
    prefix_config = false,
    primary_colour = G.C.STAND,
    secondary_colour = G.C.STAND,
    collection_rows = { 8, 8 },
    shop_rate = 0,
    default = "c_arrow_stardust_star",
    rarities = {
        {key = 'StandRarity'},
        {key = 'EvolvedRarity'},
    },
    inject_card = function(self, center)
        if center.set ~= self.key then SMODS.insert_pool(G.P_CENTER_POOLS[self.key], center) end
        local pool_key = center.config.evolved and 'EvolvedPool' or 'StandPool'
        SMODS.insert_pool(G.P_CENTER_POOLS[pool_key], center)
        if center.rarity and self.rarity_pools[center.rarity] then
            SMODS.insert_pool(self.rarity_pools[center.rarity], center)
        end
    end,
    delete_card = function(self, center)
        if center.set ~= self.key then SMODS.remove_pool(G.P_CENTER_POOLS[self.key], center.key) end
        local pool_key = center.config.evolved and 'EvolvedPool' or 'StandPool'
        SMODS.remove_pool(G.P_CENTER_POOLS[pool_key], center)
        if center.rarity and self.rarity_pools[center.rarity] then
            SMODS.remove_pool(self.rarity_pools[center.rarity], center.key)
        end
    end,
}

--- Helper functions for Stands
ArrowAPI.stands = {
    --- Gets the leftmost stand in the consumable slots
    --- @return Card | nil # The first Stand in the consumables slot, or nil if you have no Stands
    get_leftmost_stand = function()
        if not G.consumeables then return nil end

        for _, card in ipairs(G.consumeables.cards) do
            if card.ability.set == "Stand" then
                return card
            end
        end
    end,

    --- Gets the number of stands in your consumable slots
    --- @return integer
    get_num_stands = function()
        if not G.consumeables then return 0 end

        local count = 0
        for i, v in ipairs(G.consumeables.cards) do
            if v.ability.set == "Stand" then
                count = count+1
            end
        end

        return to_big(count)
    end,

    --- Evolves a Stand. A Stand must have an 'evolve_key' field to evolve
    --- @param stand Card Balatro card table representing a Stand consumable
    --- @param loc_message string | nil Custom loc string for evolve message, defaults to 'k_stand_evolved'
    evolve_stand = function(stand, loc_message)
        if not stand.ability.evolve_key or not G.P_CENTERS[stand.ability.evolve_key] or G.GAME.banned_keys[stand.ability.evolve_key] then
            return
        end

        if stand.children.stand_aura then
            stand.children.stand_aura.atlas = G.ASSET_ATLAS[stand.ability.evolved and 'arrow_blank_evolved' or 'arrow_blank']
        end

        ArrowAPI.stands.flare_aura(stand, 0.50)
        G.E_MANAGER:add_event(Event({
            func = function()

                ArrowAPI.game.transform_card(stand, stand.ability.evolve_key, true)
                check_for_unlock({ type = "evolve_stand" })

                attention_text({
                    text = localize(loc_message or 'k_stand_evolved'),
                    scale = 0.7,
                    hold = 0.55,
                    backdrop_colour = G.C.STAND,
                    align = 'bm',
                    major = stand,
                    offset = {x = 0, y = 0.05*stand.T.h}
                })

                if not stand.edition then
                    play_sound('polychrome1')
                end

                return true
            end
        }))
    end,

    --- Creates a new stand in G.consumables
    --- @param evolved boolean Whether or not to use the Evolved Stand pool
    new_stand = function(evolved)
        local pool_key = evolved and 'EvolvedPool' or 'StandPool'
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        local stand = create_card(pool_key, G.consumeables, nil, nil, nil, nil, nil, 'arrow')
        stand:add_to_deck()
        G.consumeables:emplace(stand, #G.consumeables.cards <= 2 and 'front' or nil)
        stand:juice_up(0.3, 0.5)
        G.GAME.consumeable_buffer = 0
    end,

    --- Queues a stand aura to flare for delay_time if a Stand has an aura attached
    --- @param stand Card Balatro card table representing a stand
    --- @param delay_time number length of flare in seconds
    flare_aura = function(stand, delay_time)
        if not stand.children.stand_aura then
            return
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            blocking = false,
            func = function()
                stand.ability.aura_flare_queued = true
                stand.ability.aura_flare_target = delay_time and (delay_time / 2) or nil
                return true
            end
        }))
    end,

    --- Sets relevant sprites for stand auras and overlays (if applicable)
    --- @param stand Card Balatro card table representing a Stand
    set_stand_sprites = function(stand)
        -- add stand aura
        if stand.ability.aura_colors and #stand.ability.aura_colors == 2 then
            stand.no_shadow = true
            G.ASSET_ATLAS['arrow_stand_noise'].image:setWrap('repeat', 'repeat', 'clamp')

            local blank_atlas = G.ASSET_ATLAS[stand.ability.evolved and 'arrow_stand_blank_evolved' or 'arrow_stand_blank']
            local aura_scale_x = blank_atlas.px / stand.children.center.atlas.px
            local aura_scale_y = blank_atlas.py / stand.children.center.atlas.py
            local aura_width = stand.T.w * aura_scale_x
            local aura_height = stand.T.h * aura_scale_y
            local aura_x_offset = (aura_width - stand.T.w) / 2
            local aura_y_offset = (aura_height - stand.T.h) / 1.1

            stand.ability.aura_spread = 0.47
            stand.ability.aura_rate = 0.7
            stand.children.stand_aura = Sprite(
                    stand.T.x - aura_x_offset,
                    stand.T.y - aura_y_offset,
                    aura_width,
                    aura_height,
                    blank_atlas,
                    stand.children.center.config.pos
            )
            stand.children.stand_aura:set_role({
                role_type = 'Minor',
                major = stand,
                offset = { x = -aura_x_offset, y = -aura_y_offset },
                xy_bond = 'Strong',
                wh_bond = 'Weak',
                r_bond = 'Strong',
                scale_bond = 'Strong',
                draw_major = stand
            })
            stand.children.stand_aura:align_to_major()
            stand.children.stand_aura.custom_draw = true
        end
    end,

    -- Retrives the win sticker sprite for a Stand
    --- @param center table center table representing the stand
    --- @param index boolean | nil Bool to return the key instead of the sticker sprite
    --- @return Sprite | number # Returns the sticker sprite, or the key to index it in G.sticker_map if 'index' is true
    get_win_sticker = function(center, index)
        G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}
        local stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage[center.key] or {}
        if stand_usage.wins then
            local applied = {}
            local _count = 0
            local _stake = nil
            for k, v in pairs(stand_usage.wins_by_key or {}) do
                SMODS.build_stake_chain(G.P_STAKES[k], applied)
            end

            for i, v in ipairs(G.P_CENTER_POOLS.Stake) do
                if applied[v.order] then
                    _count = _count+1
                    if (v.stake_level or 0) > (_stake and G.P_STAKES[_stake].stake_level or 0) then
                        _stake = v.key
                    end
                end
            end

            if index then return _count end
            if _count > 0 then return G.sticker_map[_stake] end
        end

        if index then return 0 end
    end,

    --- Sets the stake win state for a Stand in the player's profile and then saves
    set_stand_win = function()
        G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}
        for _, v in pairs(G.consumeables.cards) do
            if v.config.center_key and v.ability.set == 'Stand' then
                G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] or {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
                if G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] then
                    G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins or {}
                    G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] or 0) + 1
                    G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
                end
            end
        end
        G:save_settings()
    end,
}

local ref_spp = set_profile_progress
function set_profile_progress()
    local ret = ref_spp()
    G.PROGRESS.stand_stickers = {tally = 0, of = 0}
    for _, v in pairs(G.P_CENTERS) do
        if v.set == 'Stand' then
            G.PROGRESS.stand_stickers.of = G.PROGRESS.stand_stickers.of + #G.P_CENTER_POOLS.Stake
            G.PROGRESS.stand_stickers.tally = G.PROGRESS.stand_stickers.tally + ArrowAPI.stands.get_win_sticker(v, true)
        end
    end
    G.PROFILES[G.SETTINGS.profile].progress.stand_stickers = copy_table(G.PROGRESS.stand_stickers)
    return ret
end