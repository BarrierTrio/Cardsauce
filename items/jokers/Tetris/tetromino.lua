Tetromino = {}

local shapes = {
    I = {
        {{0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}, {0, 0, 0, 0}}, -- 0 degrees
        {{0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}, {0, 1, 0, 0}}, -- 90 degrees
        {{0, 0, 0, 0}, {0, 0, 0, 0}, {1, 1, 1, 1}, {0, 0, 0, 0}}, -- 180 degrees
        {{0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}, {0, 0, 1, 0}}, -- 270 degrees
    },
    T = {
        {{0, 1, 0}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 1}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {0, 1, 0}}, -- 180 degrees
        {{0, 1, 0}, {1, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    J = {
        {{1, 0, 0}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 1}, {0, 1, 0}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {0, 0, 1}}, -- 180 degrees
        {{0, 1, 0}, {0, 1, 0}, {1, 1, 0}}, -- 270 degrees
    },
    L = {
        {{0, 0, 1}, {1, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 0}, {0, 1, 1}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 1}, {1, 0, 0}}, -- 180 degrees
        {{1, 1, 0}, {0, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    S = {
        {{0, 1, 1}, {1, 1, 0}, {0, 0, 0}}, -- 0 degrees
        {{0, 1, 0}, {0, 1, 1}, {0, 0, 1}}, -- 90 degrees
        {{0, 0, 0}, {0, 1, 1}, {1, 1, 0}}, -- 180 degrees
        {{1, 0, 0}, {1, 1, 0}, {0, 1, 0}}, -- 270 degrees
    },
    Z = {
        {{1, 1, 0}, {0, 1, 1}, {0, 0, 0}}, -- 0 degrees
        {{0, 0, 1}, {0, 1, 1}, {0, 1, 0}}, -- 90 degrees
        {{0, 0, 0}, {1, 1, 0}, {0, 1, 1}}, -- 180 degrees
        {{0, 1, 0}, {1, 1, 0}, {1, 0, 0}}, -- 270 degrees
    },
    O = {
        {{1, 1}, {1, 1}},
    },
}

local wall_kicks = {
    I = {
        [0] = {{0, 0}, {-2, 0}, {1, 0}, {-2, -1}, {1, 2}}, -- From 0 to 90
        [1] = {{0, 0}, {-1, 0}, {2, 0}, {-1, 2}, {2, -1}}, -- From 90 to 180
        [2] = {{0, 0}, {2, 0}, {-1, 0}, {2, 1}, {-1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {1, 0}, {-2, 0}, {1, -2}, {-2, 1}}, -- From 270 to 0
    },
    J = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    L = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    S = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    T = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
    Z = {
        [0] = {{0, 0}, {-1, 0}, {-1, 1}, {0, -2}, {-1, -2}}, -- From 0 to 90
        [1] = {{0, 0}, {1, 0}, {1, -1}, {0, 2}, {1, 2}}, -- From 90 to 180
        [2] = {{0, 0}, {1, 0}, {1, 1}, {0, -2}, {1, -2}}, -- From 180 to 270
        [3] = {{0, 0}, {-1, 0}, {-1, -1}, {0, 2}, {-1, 2}}, -- From 270 to 0
    },
}

local colors = {
    I = HEX('ebf6f8'), -- White Stake
    O = HEX('f2c255'), -- Yellow Stake
    T = HEX('8a71e1'), -- Purple Stake
    J = HEX('009cfd'), -- Blue Stake
    L = HEX('e47c4c'), -- Orange Stake
    S = HEX('55a383'), -- Green Stake
    Z = HEX('fd5f55'), -- Red Stake
}

function Tetromino:init(type, board, x, y, scale_x, scale_y, rotation)
    local obj = {
        board = board,
        type = type,
        shapes = shapes[type],
        current_shape = shapes[type][(rotation or 0) + 1],
        x = x,
        y = y,
        scale_x = scale_x,
        scale_y = scale_y,
        color = colors[type],
        rotation = rotation or 0
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tetromino:set_shape(type, x, y, rotation)
    self.type = type
    self.shapes = shapes[type]
    self.current_shape = shapes[type][1]
    self.rotation = 0
    self.color = colors[type]
    self.x = x
    self.y = y
end

function Tetromino:rotate(clockwise)
    if self.type == "O" then return end
    local new_rot = (self.rotation + (clockwise and 1 or -1)) % 4
    local old_x, old_y = self.x, self.y
    local old_shape = self.current_shape

    local kicks = wall_kicks[self.type][self.rotation]

    for _, kick in ipairs(kicks) do
        self.x = old_x + kick[1]
        self.y = old_y + kick[2]
        self.current_shape = self.shapes[new_rot + 1]

        if not self.board:collision(self) then
            self.rotation = new_rot
            play_sound('csau_tetris_rotate', nil, 0.1)
            return
        end
    end

    self.x = old_x
    self.y = old_y
    self.current_shape = old_shape
end

function Tetromino:draw(x_offset, y_offset)
    for row = 1, #self.current_shape do
        for col = 1, #self.current_shape[row] do
            if self.current_shape[row][col] == 1 then
                local screenX = (self.x + col - 2) * self.scale_x + x_offset
                local screenY = (self.y + row - 2) * self.scale_y + y_offset
                love.graphics.rectangle("fill", screenX, screenY, self.scale_x, self.scale_y)
            end
        end
    end
end

return Tetromino