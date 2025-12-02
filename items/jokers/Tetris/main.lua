notbalatro = true

require("src.misc_functions")
local tetris = require("src.game")

tetris.canvasWidth = 59
tetris.canvasHeight = 65
tetris.scale = 8
tetris.blockSize = math.floor(math.min(tetris.canvasWidth / 10, tetris.canvasHeight / 20))
tetris.gridOffsetX = 15
tetris.gridOffsetY = 1
tetris.isActive = false
tetris.showFullView = false
tetris.linesCleared = 0
tetris.targetFrameTime = 1 / 60
tetrisSeed = tetrisSeed or love.math.random(1, 10000)
love.math.setRandomSeed(tetrisSeed)

function love.load()
    love.graphics.setBackgroundColor(tetris.colors.background)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(tetris.canvasWidth * tetris.scale, tetris.canvasHeight * tetris.scale, {resizable = false, vsync = true})
    tetris.canvas = love.graphics.newCanvas(tetris.canvasWidth, tetris.canvasHeight)
    tetris.load()
end

function love.draw()
    love.graphics.setCanvas(tetris.canvas)
    love.graphics.clear()
    tetris.draw(nil, 2)
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(tetris.canvas, 0, 0, 0, tetris.scale, tetris.scale)
end

function love.conf(t)
    t.window.width = tetris.canvasWidth * tetris.scale
    t.window.height = tetris.canvasHeight * tetris.scale
    t.console = true
end

function love.update(dt)
    local startTime = love.timer.getTime()

    tetris.update(dt)

    local frameTime = love.timer.getTime() - startTime

    if frameTime < tetris.targetFrameTime then
        love.timer.sleep(tetris.targetFrameTime - frameTime)
    end
end

function love.keypressed(key)
    if tetris.isActive then
        tetris.keypressed(key)
    end
end

function love.keyreleased(key)
    if tetris.isActive then
        tetris.keyreleased(key)
    end
end

local ref_controller_press_update = Controller.button_press_update
function Controller:button_press_update(button, dt)
    if tetris.isActive then
        tetris.controller_press_update(self, button, dt)
    end
    ref_controller_press_update(self, button, dt)
end

return tetris