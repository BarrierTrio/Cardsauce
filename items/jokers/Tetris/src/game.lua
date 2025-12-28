local Tetromino = SMODS.load_file('items/jokers/Tetris/src/tetromino.lua')()
local Board = SMODS.load_file('items/jokers/Tetris/src/board.lua')()

Tetris = {}

Tetris.colors = {
    background = HEX('2d433c'),
    mult = HEX('FE5F55'),
    dark_mult = HEX('cc4846'),
    clear = HEX('ffe4a6'),
    edges = HEX('575763'),
    speedlevels = {
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
}

Tetris.speeds = {
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
}

Tetris.keysPressed = {}
Tetris.keyDelayTimers = {}
Tetris.keyDelayThreshold = 0.03
Tetris.gameOverAnimationState = nil
Tetris.gameOverAnimationTimer = 0
Tetris.gameOverAnimationNumber = 0
Tetris.gameOverAnimLength = 2.5

function Tetris.getRandomTetrominoShape()
    local tetrominoShapes = {"I", "O", "T", "J", "L", "S", "Z"}
    local randomIndex = math.random(1, #tetrominoShapes)
    local shape = tetrominoShapes[randomIndex]
    return shape
end

function Tetris.load()
    Tetris.board = Board:new('main', 10, 20)
    Tetris.mult = Board:new('mult', 3, 25, 4, 10, 2)
    Tetris.speed = Board:new('speed', 1, 17, 51, 9, 3)

    local nextShape = Tetris.getRandomTetrominoShape()

    Tetris.currentTetromino = Tetromino:new(nextShape, 5, 1)
    Tetris.currentTetromino.board = Tetris.board

    Tetris.ghostTetromino = nil
    Tetris.linesCleared = 0
    Tetris.lockDelay = 0
    Tetris.gameOver = false
    Tetris.dropTimer = 0
    Tetris.actionTimer = 0
    Tetris.clearTimer = 0
    Tetris.speedLevel = 1
    Tetris.clearDelay = 0.5

    if not Tetris.queue then
        Tetris.queue = {}
    end

    Tetris.keyDelayTimers = {left = 0, right = 0}
end

function Tetris.update(dt)
    if Tetris.gameOverAnimationState then
        Tetris.gameOverAnimationTimer = Tetris.gameOverAnimationTimer + dt

        local increaseDuration = Tetris.gameOverAnimLength * 0.4
        local holdDuration = Tetris.gameOverAnimLength * 0.2
        local decreaseDuration = Tetris.gameOverAnimLength * 0.4

        local incrementStep = 20 / (increaseDuration / 0.05)
        local decrementStep = 20 / (decreaseDuration / 0.05)

        if Tetris.gameOverAnimationState == 'increasing' then
            if Tetris.gameOverAnimationTimer >= 0.05 then
                Tetris.gameOverAnimationNumber = Tetris.gameOverAnimationNumber + incrementStep
                Tetris.gameOverAnimationTimer = Tetris.gameOverAnimationTimer - 0.05 -- Reset timer for next increment

                if Tetris.gameOverAnimationNumber >= 20 then
                    Tetris.gameOverAnimationNumber = 20
                    Tetris.gameOverAnimationState = 'holding' -- Move to holding phase
                    Tetris.gameOverAnimationTimer = 0
                end
            end
        elseif Tetris.gameOverAnimationState == 'holding' then
            if Tetris.gameOverAnimationTimer >= holdDuration then
                Tetris.gameOverAnimationState = 'decreasing' -- Move to decreasing phase
                Tetris.gameOverAnimationTimer = 0
                Tetris.speedLevel = 1
                Tetris.linesCleared = 0
            end
        elseif Tetris.gameOverAnimationState == 'decreasing' then
            if Tetris.gameOverAnimationTimer >= 0.05 then
                Tetris.gameOverAnimationNumber = Tetris.gameOverAnimationNumber - decrementStep
                Tetris.gameOverAnimationTimer = Tetris.gameOverAnimationTimer - 0.05 -- Reset timer for next decrement

                if Tetris.gameOverAnimationNumber <= 0 then
                    Tetris.gameOverAnimationNumber = 0
                    Tetris.gameOverAnimationState = nil -- Animation complete
                    -- Continue to handle game over logic
                    Tetris.load()
                end
            end
        end

        return
    end

    -- Handle game over logic if not already animating
    if Tetris.gameOver then
        Tetris.queue[#Tetris.queue+1] = {type = 'reset'}
        Tetris.gameOverAnimationState = 'increasing' -- Start animation
        Tetris.gameOverAnimationTimer = 0
        Tetris.gameOverAnimationNumber = 0
        return
    end

    if Tetris.clearRows then
        Tetris.clearTimer = (Tetris.clearTimer or 0) + dt
        if Tetris.clearTimer >= Tetris.clearDelay then
            Tetris.clearTimer = 0
            Tetris.clearRows = false
            Tetris.rowsCleared = 0
            Tetris.fullRows = {}
            Tetris.board:clearRows()
        end
    else
        Tetris.dropTimer = (Tetris.dropTimer or 0) + dt

        if (Tetris.linesCleared >= (Tetris.speedLevel * 5 + 5)) and not (Tetris.speedLevel >= 17) then
            Tetris.speedLevel = Tetris.speedLevel + 1
        end

        if Tetris.dropTimer >= Tetris.speeds[Tetris.speedLevel] then
            if not Tetris.moveTetromino(0, 1) then
                Tetris:hardDrop()
                Tetris.dropTimer = 0
            else
                Tetris.lockDelay = 0
            end

            Tetris.dropTimer = 0
        end

        local actionSpeed = 0.05
        Tetris.actionTimer = (Tetris.actionTimer or 0) + dt

        local softDropDelay = 0.2


        if Tetris.actionTimer >= actionSpeed then
            for key, _ in pairs(Tetris.keysPressed) do
                if Tetris.keyDelayTimers[key] then
                    Tetris.keyDelayTimers[key] = Tetris.keyDelayTimers[key] + dt
                end
            end

            if Tetris.keysPressed["left"] and Tetris.keyDelayTimers["left"] >= Tetris.keyDelayThreshold then
                Tetris.moveTetromino(-1, 0)
            end
            if Tetris.keysPressed["right"] and Tetris.keyDelayTimers["right"] >= Tetris.keyDelayThreshold then
                Tetris.moveTetromino(1, 0)
            end
            if Tetris.keysPressed["down"] then
                if not Tetris.moveTetromino(0, 1) then
                    if Tetris.softDropTimer < softDropDelay then
                        Tetris.softDropTimer = (Tetris.softDropTimer or 0) + dt
                    else
                        Tetris:hardDrop()
                        Tetris.dropTimer = 0
                        Tetris.softDropTimer = 0
                    end

                end
            end

            Tetris.actionTimer = 0
            Tetris.softDropTimer = 0
        end

        Tetris.updateGhostTetromino()
    end
end

function Tetris.updateGhostTetromino()
    local ghost = Tetromino:new(Tetris.currentTetromino.type, Tetris.currentTetromino.x, Tetris.currentTetromino.y)
    ghost.rotation = Tetris.currentTetromino.rotation
    ghost.shape = Tetromino.shapes[ghost.type][ghost.rotation + 1]

    while not Tetris.board:checkCollision(ghost) do
        ghost.y = ghost.y + 1
    end

    ghost.y = ghost.y - 1

    Tetris.ghostTetromino = ghost
end

function Tetris.moveTetromino(dx, dy)
    local ret = true
    Tetris.currentTetromino.x = Tetris.currentTetromino.x + dx
    Tetris.currentTetromino.y = Tetris.currentTetromino.y + dy
    if Tetris.board:checkCollision(Tetris.currentTetromino) then
        ret = false
        Tetris.currentTetromino.x = Tetris.currentTetromino.x - dx
        Tetris.currentTetromino.y = Tetris.currentTetromino.y - dy
    end
    return ret
end

function Tetris.hardDrop()
    if Tetris.gameOver then
        return
    end
    if Tetris.ghostTetromino then
        Tetris.currentTetromino.y = Tetris.ghostTetromino.y

        Tetris.board:lockTetromino(Tetris.currentTetromino)

        Tetris.rowsCleared, Tetris.fullRows = Tetris.board:getClearedRows()
        if Tetris.rowsCleared > 0 then
            Tetris.queue[#Tetris.queue+1] = {type = 'line'}
            Tetris.clearRows = true
        end
        Tetris.linesCleared = Tetris.linesCleared + Tetris.rowsCleared

        local newShape = Tetris.getRandomTetrominoShape()

        Tetris.currentTetromino = Tetromino:new(newShape, 5, 1)
        Tetris.currentTetromino.board = Tetris.board

        Tetris.updateGhostTetromino()

        if Tetris.board.checkCollision(Tetris.currentTetromino) then
            Tetris.gameOver = true
        end
    end
end

local function draw_corners(x_offset, y_offset)
    local corners = {
        {x = 0, y = 0},
        {x = 0, y = Tetris.canvasHeight-1},
        {x = Tetris.canvasWidth-1, y = 0},
        {x = Tetris.canvasWidth-1, y = Tetris.canvasHeight-1},
        {x = 0, y = -2, width = 59, height = 2}

    }
    for i, v in ipairs(corners) do
        local screenX = corners[i].x + x_offset
        local screenY = corners[i].y + y_offset
        local width = corners[i].width or 1
        local height = corners[i].height or 1
        love.graphics.setColor(Tetris.colors.edges)
        love.graphics.rectangle("fill", screenX, screenY, Tetris.blockSize*(1/3)*width, Tetris.blockSize*(1/3)*height)
    end
end

function Tetris.draw(x_offset, y_offset)
    x_offset = x_offset or 0
    y_offset = y_offset or 0
    Tetris.board:draw(x_offset, y_offset)
    Tetris.mult:draw(x_offset, y_offset)
    Tetris.speed:draw(x_offset, y_offset)

    if not Tetris.gameOverAnimationState or Tetris.gameOverAnimationState ~= 'decreasing' then
        if not Tetris.clearRows then
            if Tetris.ghostTetromino then
                local ghostColor = Tetromino.colors[Tetris.ghostTetromino.type]
                love.graphics.setColor(ghostColor[1], ghostColor[2], ghostColor[3], 0.3)
                Tetris.ghostTetromino:draw(x_offset, y_offset)
            end

            local currentColor = Tetromino.colors[Tetris.currentTetromino.type]
            love.graphics.setColor(currentColor[1], currentColor[2], currentColor[3])
            Tetris.currentTetromino:draw(x_offset, y_offset)
        else
            for i, v in ipairs(Tetris.fullRows) do
                local row = v
                local screenX = Tetris.gridOffsetX + x_offset
                local screenY = (row - 1) * Tetris.blockSize + Tetris.gridOffsetY + y_offset
                local filledColor
                if Tetris.clearTimer <= Tetris.clearDelay*0.75 then filledColor = Tetris.colors.clear else filledColor = Tetris.colors.background end
                love.graphics.setColor(filledColor)
                love.graphics.rectangle("fill", screenX, screenY, Tetris.blockSize * 10, Tetris.blockSize)
            end
        end
    end

    local multSquares = math.min(Tetris.linesCleared, Tetris.mult.height * Tetris.mult.width)

    local otherRed = false
    for i = 0, multSquares - 1 do
        local row = Tetris.mult.height - math.floor(i / Tetris.mult.width)
        local col = (i % Tetris.mult.width) + 1

        local screenX = (col - 1) * Tetris.mult.scale + Tetris.mult.x + x_offset
        local screenY = (row - 1) * Tetris.mult.scale + Tetris.mult.y + y_offset
        local filledColor
        if otherRed then filledColor = Tetris.colors.dark_mult else filledColor = Tetris.colors.mult end
        otherRed = not otherRed
        love.graphics.setColor(filledColor)
        love.graphics.rectangle("fill", screenX, screenY, Tetris.mult.scale, Tetris.mult.scale)
    end

    local speedSquares = Tetris.speedLevel
    local color = 1
    for i = 0, speedSquares - 1 do
        local col = (1 % Tetris.speed.width) + 1
        local row = Tetris.speed.height - math.floor(i / Tetris.speed.width)
        local screenX = (col - 1) * Tetris.speed.scale + Tetris.speed.x + x_offset
        local screenY = (row - 1) * Tetris.speed.scale + Tetris.speed.y + y_offset
        local filledColor
        filledColor = Tetris.colors.speedlevels[color]
        color = color + 1
        otherRed = not otherRed
        love.graphics.setColor(filledColor)
        love.graphics.rectangle("fill", screenX, screenY, Tetris.speed.scale, Tetris.speed.scale)
    end

    if Tetris.gameOverAnimationState then
        local screenX = Tetris.gridOffsetX + x_offset
        local screenY = 20 * Tetris.blockSize + Tetris.gridOffsetY + y_offset
        local filledColor = Tetris.colors.clear
        love.graphics.setColor(filledColor)
        love.graphics.rectangle("fill", screenX, screenY, Tetris.blockSize * 10, Tetris.blockSize * -Tetris.gameOverAnimationNumber)
    end

    draw_corners(x_offset, y_offset)

    love.graphics.setColor(1, 1, 1)
end

function Tetris.keypressed(key)
    if Tetris.gameOver then
        return
    end

    Tetris.keysPressed[key] = true
    Tetris.keyDelayTimers[key] = 0
    Tetris.keysPressed[key] = true
    if key == "left" then
        Tetris.moveTetromino(-1, 0)
    end
    if key == "right" then

        Tetris.moveTetromino(1, 0)
    end
    if key == "down" then
        Tetris.moveTetromino(0, 1)
    end
    if key == "up" then
        Tetris:hardDrop()
    end
    if key == "z" then
        Tetris.currentTetromino:rotate(false)
    end
    if key == "x" then
        Tetris.currentTetromino:rotate(true)
    end
end

function Tetris:controller_press_update(button, dt)
    if button == "dpup" then
        Tetris.hardDrop()
    end
    if button == "dpdown" then
        if not Tetris.moveTetromino(0, 1) then
            Tetris.hardDrop()
            Tetris.dropTimer = 0
        end
    end
    if button == "dpleft" then
        Tetris.moveTetromino(-1, 0)
    end
    if button == "dpright" then
        Tetris.moveTetromino(1, 0)
    end
    if button == "rightstick" then
        Tetris.currentTetromino:rotate(true)
    elseif button == 'leftstick' then
        Tetris.currentTetromino:rotate(false)
    end
end

function Tetris.keyreleased(key)
    Tetris.keysPressed[key] = false
    Tetris.keyDelayTimers[key] = 0
end

return Tetris