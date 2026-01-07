Board = {}

function Board:init(width, height, x, y, block_scale_x, block_scale_y)
    local obj = {
        grid = {},
        width = width,
        height = height,
        x = x,
        y = y,
        scale_x = block_scale_x,
        scale_y = block_scale_y,
        edge_color = HEX('bfc7d5'),
        shadow_color = HEX('4f6367')
    }

    for _y = 1, height do
        obj.grid[_y] = {}
        for _x = 1, width do
            obj.grid[_y][_x] = 0
        end
    end

    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Board:reset_grid()
    for y = 1, self.height do
        for x = 1, self.width do
            self.grid[y][x] = 0
        end
    end
end

function Board:collision(piece)
    for row = 1, #piece.current_shape do
        for col = 1, #piece.current_shape[row] do
            if piece.current_shape[row][col] == 1 then
                local boardX = piece.x + col - 1
                local boardY = piece.y + row - 1

                if boardX < 1 or boardX > self.width then
                    return true
                end

                if boardY > self.height or (boardY > 0 and self.grid[boardY][boardX] ~= 0) then
                    return true
                end
            end
        end
    end

    return false
end

function Board:lock_piece(piece)
    for row = 1, #piece.current_shape do
        for col = 1, #piece.current_shape[row] do
            if piece.current_shape[row][col] == 1 then
                local boardX = piece.x + col - 1
                local boardY = piece.y + row - 1

                if boardX >= 1 and boardX <= self.width and boardY >= 1 and boardY <= self.height then
                    self.grid[boardY][boardX] = piece.color
                end
            end
        end
    end
end

function Board:get_cleared_rows()
    local cleared = 0
    local rows = {}

    for y = self.height, 1, -1 do
        local full_row = true
        for x = 1, self.width do
            if self.grid[y][x] == 0 then
                full_row = false
                break
            end
        end
        if full_row then
            rows[#rows+1] = y
            cleared = cleared + 1
        end
    end

    return cleared, rows
end

function Board:clear_rows()
    local total_cleared = 0
    local num_cleared

    repeat
        num_cleared = 0
        for y = self.height, 1, -1 do
            local full_row = true
            for x = 1, self.width do
                if self.grid[y][x] == 0 then
                    full_row = false
                    break
                end
            end

            if full_row then
                for row = y, 2, -1 do
                    self.grid[row] = self.grid[row - 1]
                end
                self.grid[1] = {}
                for x = 1, self.width do
                    self.grid[1][x] = 0
                end
                num_cleared = num_cleared + 1
                total_cleared = total_cleared + 1
                break
            end
        end
    until num_cleared == 0

    return total_cleared
end

function Board:draw(x_offset, y_offset, draw_pieces)
    if draw_pieces then
        for y = 1, self.height do
            for x = 1, self.width do
                local screenX = (x - 1) * self.scale_x + self.x + x_offset
                local screenY = (y - 1) * self.scale_y + self.y + y_offset

                if self.grid[y][x] ~= 0 then
                    local color = self.grid[y][x]
                    love.graphics.setColor(color[1], color[2], color[3])
                    love.graphics.rectangle("fill", screenX, screenY, self.scale_x, self.scale_y)
                end
            end
        end
    end

    love.graphics.setLineWidth(1)
    love.graphics.setColor(self.shadow_color)
    love.graphics.rectangle("line", self.x + x_offset + 0.5, self.y + y_offset + 0.5, (self.width * self.scale_x) + 1, (self.height * self.scale_y) + 1)

    love.graphics.setColor(self.edge_color)
    love.graphics.rectangle("line", self.x + x_offset - 0.5, self.y + y_offset - 0.5, (self.width * self.scale_x) + 1, (self.height * self.scale_y) + 1)
end

return Board