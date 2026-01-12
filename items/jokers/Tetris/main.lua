SMODS.Sound({key = 'tetris_line', path = 'tetris_line.ogg'})
SMODS.Sound({key = 'tetris_tetris', path = 'tetris_tetris.ogg'})
SMODS.Sound({key = 'tetris_move', path = 'tetris_move.ogg'})
SMODS.Sound({key = 'tetris_rotate', path = 'tetris_rotate.ogg'})
SMODS.Sound({key = 'tetris_land', path = 'tetris_land.ogg'})
SMODS.Sound({key = 'tetris_drop', path = 'tetris_drop.ogg'})
SMODS.Sound({key = 'tetris_speed', path = 'tetris_speed.ogg'})

local width = 59
local height = 65
local board_width = 10
local board_height = 20
local block_scale = 3

SMODS.load_file('items/jokers/Tetris/tetromino.lua')()
SMODS.load_file('items/jokers/Tetris/board.lua')()

local Tetris = {}
function Tetris:init()
    local obj = {
        seed = 'tetris',

        canvas_width = width,
        canvas_height = height,
        board_width = board_width,
        board_height = board_height,
        scale = 8,
        block_scale = block_scale,
        offset_x = 15,
        offset_y = 1,

        queue = {},
        lines_cleared = 0,
        rows_cleared = 0,
        full_rows = {},
        clear_delay = 0.38,
        main_timer = 0,
        action_timer = 0,
        action_delay = 0.075,

        key_threshold = 0.05,
        key_timers = {},

        -- game over
        game_over_anim = 0,
        game_over_inc = 1.25,
        game_over_hold = 0.5,
        game_over_dec = 0.75,

        colors = {
            background = HEX('2d433c'),
            mult = HEX('FE5F55'),
            dark_mult = HEX('cc4846'),
            clear = HEX('ffe4a6'),
            edges = HEX('575763'),
            speeds = {
                [1] = HEX('ebf6f8'),
                [2] = HEX('c7d6d9'),
                [3] = HEX('FE5F55'),
                [4] = HEX('cc4846'),
                [5] = HEX('55a383'),
                [6] = HEX('4d8276'),
                [7] = HEX('4f6367'),
                [8] = HEX('445457'),
                [9] = HEX('009cfd'),
                [10] = HEX('1685cb'),
                [11] = HEX('8a71e1'),
                [12] = HEX('6059a0'),
                [13] = HEX('e47c4c'),
                [14] = HEX('a66040'),
                [15] = HEX('ffe4a6'),
                [16] = HEX('f2c255'),
                [17] = HEX('c09533')
            }
        },

        current_speed = 1,
        speeds = {
            [1] = 1.0,
            [2] = 0.9385416667,
            [3] = 0.8770833333,
            [4] = 0.815625,
            [5] = 0.7541666667,
            [6] = 0.6927083333,
            [7] = 0.63125,
            [8] = 0.5697916667,
            [9] = 0.5083333333,
            [10] = 0.446875,
            [11] = 0.3854166667,
            [12] = 0.3239583333,
            [13] = 0.2625,
            [14] = 0.2010416667,
            [15] = 0.1395833333,
            [16] = 0.078125,
            [17] = 0.0166666667,
        },

        corners = {
            {x = 0, y = 0},
            {x = 0, y = height-1},
            {x = width-1, y = 0},
            {x = width-1, y = height-1},
            {x = 0, y = -2, width = width, height = 2}
        },

        shapes = {"I", "O", "T", "J", "L", "S", "Z"},

        board = Board:init(board_width, board_height, 15, 1, block_scale, block_scale),
        mult = Board:init(1, 75, 4, 10, 6, 2/3),
        speed = Board:init(1, 17, 51, 17, 3, 2.5)
    }

    local new_piece = pseudorandom_element(obj.shapes, obj.seed)
    local next_piece = pseudorandom_element(obj.shapes, obj.seed)
    obj.current_piece = Tetromino:init(new_piece, obj.board, 5, 1, obj.block_scale, obj.block_scale)
    obj.ghost_piece = Tetromino:init(new_piece, obj.board, 5, 1, obj.block_scale, obj.block_scale)
    obj.next_piece = Tetromino:init(next_piece, obj.board, 5, 1, obj.block_scale * 0.8, obj.block_scale * 0.8)

    obj.speed.grid[obj.speed.height][1] = obj.colors.speeds[1]

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Tetris:new_stage()
    self.current_speed = 1
    self.current_piece:set_shape(self.next_piece.type, 5, 1)
    self.ghost_piece:set_shape(self.next_piece.type, 5, 1)

    local new_piece = pseudorandom_element(self.shapes, self.seed)
    self.next_piece:set_shape(new_piece, 5, 1)

    self.board:reset_grid()
    self.mult:reset_grid()
    self.speed:reset_grid()
    self.speed.grid[self.speed.height][1] = self.colors.speeds[1]

    self.lines_cleared = 0
    self.main_timer = 0
    self.action_timer = 0
end

function Tetris:update(dt)
    if self.game_over then
        self.main_timer = self.main_timer + dt

        local inc_step = board_height / (self.game_over_inc * board_height)
        local dec_step = board_height / (self.game_over_dec * board_height)

        if self.game_over == 'increasing' then
            if self.main_timer >= 0.05 then
                self.game_over_anim = self.game_over_anim + inc_step
                self.main_timer = self.main_timer - 0.05 -- Reset timer for next increment
                play_sound('csau_tetris_land', 0.8, 0.1)

                if self.game_over_anim >= 20 then
                    self.game_over_anim = 20
                    self.game_over = 'holding' -- Move to holding phase
                    self.main_timer = 0
                end
            end
        elseif self.game_over == 'holding' then
            if self.main_timer >= self.game_over_hold then
                self.game_over = 'decreasing' -- Move to decreasing phase
                self.main_timer = 0
                self.current_speed = 1
                self.lines_cleared = 0
            end
        elseif self.game_over == 'decreasing' then
            if self.main_timer >= 0.05 then
                self.game_over_anim = self.game_over_anim - dec_step
                self.main_timer = self.main_timer - 0.05 -- Reset timer for next decrement
                play_sound('csau_tetris_land', 1.2, 0.1)

                if self.game_over_anim <= 0 then
                    self.game_over_anim = 0
                    self.game_over = nil
                    self:new_stage()
                end
            end
        end

        return
    end

    if not G.screenwipe then
        for k, v in pairs(G.CONTROLLER.pressed_keys) do
            if v then self:keypressed(k) end
        end
        for k, v in pairs(G.CONTROLLER.pressed_buttons) do
            if v then self:keypressed(k) end
        end

        for k, v in pairs(G.CONTROLLER.released_keys) do
            if v then self:keyreleased(k) end
        end
        for k, v in pairs(G.CONTROLLER.released_buttons) do
            if v then self:keyreleased(k) end
        end
    end


    self.main_timer = self.main_timer + dt

    if self.rows_cleared > 0 then
        if self.main_timer >= self.clear_delay then
            self.main_timer = 0
            self.rows_cleared = 0
            self.full_rows = {}
            self.board:clear_rows()
        end
    else
        if (self.lines_cleared >= (self.current_speed * 5 + 5)) and self.current_speed < #self.speeds then
            self.current_speed = self.current_speed + 1
            self.queue[#self.queue+1] = {type = 'speed'}
            self.speed.grid[self.speed.height - self.current_speed + 1][1] = self.colors.speeds[self.current_speed]
            play_sound('csau_tetris_speed', nil, 0.1)
        end

        if self.main_timer >= self.speeds[self.current_speed] then
            if not self:move_tetromino(0, 1) then
                self:hard_drop()
            end

            self.main_timer = 0
        end

        self.action_timer = self.action_timer + dt
        if self.action_timer >= self.action_delay then
            for key, _ in pairs(self.key_timers) do
                self.key_timers[key] = self.key_timers[key] + dt
            end

            if (self.key_timers["left"] or 0) >= self.key_threshold then
                self:move_tetromino(-1, 0)
            end

            if (self.key_timers["right"] or 0) >= self.key_threshold then
                self:move_tetromino(1, 0)
            end

            if (self.key_timers["down"] or 0) >= self.key_threshold then
                if not self:move_tetromino(0, 1) then
                    self:hard_drop()
                end
            end

            self.action_timer = 0
        end

        self:update_ghost()
    end
end

function Tetris:update_ghost()
    self.ghost_piece.x = self.current_piece.x
    self.ghost_piece.y = self.current_piece.y
    self.ghost_piece.rotation = self.current_piece.rotation
    self.ghost_piece.current_shape = self.ghost_piece.shapes[self.current_piece.rotation + 1]

    while not self.board:collision(self.ghost_piece) do
        self.ghost_piece.y = self.ghost_piece.y + 1
    end

    self.ghost_piece.y = self.ghost_piece.y - 1
end

function Tetris:move_tetromino(dx, dy)
    self.current_piece.x = self.current_piece.x + dx
    self.current_piece.y = self.current_piece.y + dy

    if self.board:collision(self.current_piece) then
        self.current_piece.x = self.current_piece.x - dx
        self.current_piece.y = self.current_piece.y - dy
        return false
    end

    return true
end

function Tetris:hard_drop(alt_sound)
    if self.game_over then
        return
    end

    self.main_timer = 0

    self.current_piece.y = self.ghost_piece.y
    self.board:lock_piece(self.current_piece)

    play_sound(alt_sound and 'csau_tetris_drop' or 'csau_tetris_land', nil, 0.1)
    self.rows_cleared, self.full_rows = self.board:get_cleared_rows()
    if self.rows_cleared > 0 then
        self.queue[#self.queue+1] = {type = 'line'}
    end

    local old_lines = self.lines_cleared
    self.lines_cleared = self.lines_cleared + self.rows_cleared

    -- set mult pieces
    if self.lines_cleared > old_lines and self.lines_cleared <= self.mult.height then
        play_sound(self.lines_cleared - old_lines >= 4 and 'csau_tetris_tetris' or 'csau_tetris_line', nil, 0.1)
        for i = old_lines+1, self.lines_cleared do
            if i % 2 == 0 then
                self.mult.grid[self.mult.height-i+1][1] = self.colors.mult
            end
        end
    end

    self.current_piece:set_shape(self.next_piece.type, 5, 1)
    self.ghost_piece:set_shape(self.next_piece.type, 5, 1)

    local new_piece = pseudorandom_element(self.shapes, self.seed)
    self.next_piece:set_shape(new_piece, 5, 1)

    if self.board:collision(self.current_piece) then
        self.queue[#self.queue+1] = {type = 'reset'}
        self.game_over = 'increasing' -- Start animation
        self.game_over_anim = 0
        return
    end
end

function get_plus(x, y, x_scale, y_scale)
    return {
        x + x_scale, y + y_scale,
        x, y + y_scale,
        x, y + y_scale * 2,
        x + x_scale, y + y_scale * 2,
        x + x_scale, y + y_scale * 3,
        x + x_scale * 2, y + y_scale * 3,
        x + x_scale * 2, y + y_scale * 2,
        x + x_scale * 3, y + y_scale * 2,
        x + x_scale * 3, y + y_scale,
        x + x_scale * 2, y + y_scale,
        x + x_scale * 2, y,
        x + x_scale, y,
    }
end

function get_chevron(x, y, x_scale, y_scale)
    return {
        x + x_scale, y + y_scale,
        x, y + 2*y_scale,
        x + 1.5*x_scale, y + 2*y_scale,
        x + 2.5*x_scale, y + y_scale,
        x + 1.5*x_scale, y,
        x, y
    }
end

function Tetris:draw(x_offset, y_offset)
    local draw_pieces = not self.game_over or self.game_over ~= 'decreasing'

    self.board:draw(x_offset, y_offset, draw_pieces)
    self.mult:draw(x_offset, y_offset, true)
    self.speed:draw(x_offset, y_offset, true)

    love.graphics.setColor(self.board.shadow_color)
    love.graphics.polygon("fill", get_plus(x_offset + 4, y_offset + 3, 2, 2))
    love.graphics.polygon("fill", get_chevron(x_offset + 50, y_offset + 11, 2, 2))

    love.graphics.setColor(self.board.edge_color)
    love.graphics.polygon("fill", get_plus(x_offset + 4, y_offset + 2, 2, 2))
    love.graphics.polygon("fill", get_chevron(x_offset + 50, y_offset + 10, 2, 2))

    if draw_pieces then

        love.graphics.setColor(self.next_piece.color)
        local next_offset = (self.next_piece.type == 'O' and 2) or (self.next_piece.type == 'I' and 0) or 1
        self.next_piece:draw(x_offset + 38 + next_offset, y_offset + 3)

        if self.rows_cleared == 0 then
            local ghost_col = self.ghost_piece.color
            love.graphics.setColor(ghost_col[1], ghost_col[2], ghost_col[3], 0.3)
            self.ghost_piece:draw(self.offset_x + x_offset, self.offset_y + y_offset)

            love.graphics.setColor(self.current_piece.color)
            self.current_piece:draw(self.offset_x + x_offset, self.offset_y + y_offset)
        else
            for i, v in ipairs(self.full_rows) do
                local row = v
                local screenX = self.offset_x + x_offset
                local screenY = (row - 1) * self.block_scale + self.offset_y + y_offset
                love.graphics.setColor(self.main_timer <= self.clear_delay*0.75 and self.colors.clear or self.colors.background)
                love.graphics.rectangle("fill", screenX, screenY, self.block_scale * 10, self.block_scale)
            end
        end
    end

    if self.game_over then
        local screenX = self.offset_x + x_offset
        local screenY = 20 * self.block_scale + self.offset_y + y_offset
        love.graphics.setColor(self.colors.clear)
        love.graphics.rectangle("fill", screenX, screenY, self.block_scale * 10, self.block_scale * -self.game_over_anim)
    end

    for i, v in ipairs(self.corners) do
        local screenX = v.x + x_offset
        local screenY = v.y + y_offset
        love.graphics.setColor(self.colors.edges)
        love.graphics.rectangle("fill", screenX, screenY, v.width or 1, v.height or 1)
    end

    love.graphics.setColor(1, 1, 1)
end

function Tetris:keypressed(key)
    if self.game_over then
        return
    end

    if key == 'dpleft' then key = 'left'
    elseif key == 'dpright'then key = 'right'
    elseif key == 'dpdown' then key = 'down'
    elseif key == 'dpup' then key = 'up'
    elseif key == "rightstick" then key = 'z'
    elseif key == 'leftstick' then key = 'x' end

    self.key_timers[key] = 0
    local x_delta = 0
    local y_delta = 0

    if key == "left" then x_delta = x_delta - 1 end
    if key == "right" then x_delta = x_delta + 1 end
    if key == "down" then y_delta = y_delta + 1 end

    if key == "up" then
        self:hard_drop(true)
    elseif x_delta ~= 0 or y_delta ~= 0 then
        if self:move_tetromino(x_delta, y_delta) then
            play_sound('csau_tetris_move', nil, 0.1)
        end
    end

    if key == "z" then
        self.current_piece:rotate(false)
    elseif key == "x" then
        self.current_piece:rotate(true)
    end
end

function Tetris:keyreleased(key)
    self.key_timers[key] = nil
end

return Tetris