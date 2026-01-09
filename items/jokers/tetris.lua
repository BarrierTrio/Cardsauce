local tetris = SMODS.load_file('items/jokers/Tetris/main.lua')()
SMODS.Atlas({key = 'tetris_pad', path = 'animated/tetris_pad.png', px = 71, py = 95})
SMODS.Atlas({key = 'tetris_buttons', path = 'animated/tetris_buttons.png', px = 71, py = 95})

local pad_poses = {
    ['down'] = 1,
    ['left'] = 2,
    ['right'] = 4,
    ['up'] = 6,
}

local button_poses = {
    ['z'] = 1,
    ['x'] = 2,
}

local jokerInfo = {
    name = "YOU GOT THE TETRIS",
    atlas = 'jokers',
	pos = {x = 8, y = 14},
    config = {
        extra = {
            mult = 0
        },
        pad_pos = 0,
        button_pos = 0
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = {'Kekulism', 'GuffNFluff'}
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.tetris and card.tetris.lines_cleared or 0 } }
end

function jokerInfo.set_sprites(self, card, front)
    if not self.discovered and not card.bypass_discovery_center then
        return
    end

    if card.tetris then
        card.children.center:set_sprite_pos({x = 9, y = 14})
    end

    local minor = {
		role_type = 'Minor',
		major = card,
		offset = { x = 0, y = 0 },
		xy_bond = 'Strong',
		wh_bond = 'Strong',
		r_bond = 'Strong',
		scale_bond = 'Strong',
		draw_major = card
	}

    card.children.tetris_pad = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['csau_tetris_pad'],
        { x = 0, y = 0}
    )
    card.children.tetris_pad:set_role(minor)
    card.children.tetris_pad.custom_draw = true
    card.children.tetris_buttons = Sprite(
        card.T.x,
        card.T.y,
        card.T.w,
        card.T.h,
        G.ASSET_ATLAS['csau_tetris_buttons'],
        { x = 0, y = 0}
    )
    card.children.tetris_buttons:set_role(minor)
    card.children.tetris_buttons.custom_draw = true
end

function jokerInfo.calculate(self, card, context)
    if context.joker_main and card.tetris and card.tetris.lines_cleared then
        return {
            mult = card.tetris.lines_cleared,
        }
    end

    if context.selling_self or (context.joker_type_destroyed and context.card == card) then
        card.tetris = nil
    end
end

function jokerInfo.add_to_deck(self, card, from_debuff)
    if from_debuff then return end

    card.children.center:set_sprite_pos({x = 9, y = 14})
    card.tetris = tetris:init()
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    if from_debuff then return end

    card.children.center:set_sprite_pos({x = 8, y = 14})
    card.tetris = nil
end

function jokerInfo.update(self, card, dt)
    local held_keys = {}
    for k, v in pairs(G.CONTROLLER.held_keys) do
        if v then held_keys[k] = true end
    end

    for k, v in pairs(G.CONTROLLER.held_buttons) do
        if v then
            local key = nil
            if k == 'dpleft' then key = 'left'
            elseif k == 'dpright'then key = 'right'
            elseif k == 'dpdown' then key = 'down'
            elseif k == 'dpup' then key = 'up'
            elseif k == "rightstick" then key = 'z'
            elseif k == 'leftstick' then key = 'x' end
            if key then
                held_keys[key] = true
            end
        end
    end

    if held_keys['up'] and held_keys['down'] then
        held_keys['up'] = nil
        held_keys['down'] = nil
    end

    if held_keys['left'] and held_keys['right'] then
        held_keys['left'] = nil
        held_keys['right'] = nil
    end

    local pad_pos = 0
    local button_pos = 0
    for k, _ in pairs(held_keys) do
        pad_pos = pad_pos + (pad_poses[k] or 0)
        button_pos = button_pos + (button_poses[k] or 0)
    end

    if pad_pos ~= card.tetris_pad_pos then
        card.children.tetris_pad:set_sprite_pos({x = pad_pos, y = 0})
        card.tetris_pad_pos = pad_pos
    end

    if button_pos ~= card.tetris_button_pos then
        card.children.tetris_buttons:set_sprite_pos({x = button_pos, y = 0})
        card.tetris_button_pos = button_pos
    end

    if G.STAGE == G.STAGES.RUN and card.tetris then
        card.tetris:update(dt)

        if #card.tetris.queue > 0 then
            local msg = card.tetris.queue[1]
            if msg.type == 'line' then
                card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize{type = 'variable', key = 'a_mult', vars = {card.tetris.lines_cleared}}})
            elseif msg.type == 'reset' then
                card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize('k_reset'), colour = G.C.RED})
            elseif msg.type == 'speed' then
                check_for_unlock({type = 'scale_card', card = card, ref_table = {speed = card.tetris.current_speed}, ref_value = 'speed'})
            end
            table.remove(card.tetris.queue, 1)
        end
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    card.tetris = tetris:init()
end

function jokerInfo.draw(self,card,layer)
    if not self.discovered and not card.bypass_discovery_center then
        return
    end

    --Without love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of
    --the rendering code. We need a clean slate for rendering to canvases.
    if card.tetris and not card.getting_sliced then
        prep_draw(card, 1)
        love.graphics.scale(1/G.TILESIZE/1.72)

        local cursor_pos = {}
        cursor_pos[1] = card.tilt_var and card.tilt_var.mx*G.CANV_SCALE or G.CONTROLLER.cursor_position.x*G.CANV_SCALE
        cursor_pos[2] = card.tilt_var and card.tilt_var.my*G.CANV_SCALE or G.CONTROLLER.cursor_position.y*G.CANV_SCALE
        local screen_scale = G.TILESCALE*G.TILESIZE*(card.children.center.mouse_damping or 1)*G.CANV_SCALE
        local hovering = (card.hover_tilt or 0)

        G.SHADERS['csau_vertex_only']:send('mouse_screen_pos', cursor_pos)
        G.SHADERS['csau_vertex_only']:send('screen_scale', screen_scale)
        G.SHADERS['csau_vertex_only']:send('hovering', hovering)

        love.graphics.setShader(G.SHADERS['csau_vertex_only'])
        card.tetris:draw(6, 4)
        love.graphics.setShader()
        love.graphics.pop()
    end

    if card.children.tetris_pad then
        card.children.tetris_pad:draw_shader('dissolve')
    end

    if card.children.tetris_buttons then
        card.children.tetris_buttons:draw_shader('dissolve')
    end
end

return jokerInfo