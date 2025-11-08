local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

function table.clear(t)
    for k in pairs(t) do
        t[k] = nil
    end
end
------------------------------Set up emulator
local oldRequire = require
require = function(path)
    if path == 'table.clear' then return end
    return assert(SMODS.load_file('items/jokers/Tetris/src/'..path..'.lua'))()
end

mod.tetris = require('game')
mod.tetris.canvasWidth = 59
mod.tetris.canvasHeight = 63
mod.tetris.scale = 1
mod.tetris.gridOffsetX = 15
mod.tetris.gridOffsetY = 1
mod.tetris.blockSize = math.floor(math.min(mod.tetris.canvasWidth / 10, mod.tetris.canvasHeight / 20))
mod.tetris.targetFrameTime = 1 / 60

mod.tetris.isActive = false
mod.tetris.showFullView = false

mod.tetris.linesCleared = 0

local loveKeyPressedRef = love.keypressed
local loveKeyReleasedRef = love.keyreleased
local loveUpdateRef = love.update
local loveDrawRef = love.draw
local controllerPressUpdateRef = Controller.button_press_update

function Controller:button_press_update(button, dt)
    if mod.tetris.isActive then
        mod.tetris.controller_press_update(self, button, dt)
    end
    controllerPressUpdateRef(self, button, dt)
end

function love.keypressed(key)
    if mod.tetris.isActive then
        mod.tetris.keypressed(key)
    end
    loveKeyPressedRef(key)
end

function love.keyreleased(key)
    if mod.tetris.isActive then
        mod.tetris.keyreleased(key)
    end
    loveKeyReleasedRef(key)
end

function love.update(dt)
    loveUpdateRef(dt)

    if mod.tetris.isActive then
        mod.tetris.update(dt)
    end
end

local jokerInfo = {
    name = "YOU GOT THE TETRIS",
    config = {
        extra = {
            mult = 0
        }
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    streamer = "joel",
    artist = {'Kekulism', 'GuffNFluff'}
}

mod.tetrisCardBase = love.graphics.newImage(mod_path..'assets/1x/jokers/tetris.png')

local setupCanvas = function(self)
    self.children.center.video = love.graphics.newCanvas(71,95) --why does this work lmaooooooo
    self.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(mod.tetrisCardBase)
    end)
end

jokerInfo.loc_vars = function (self, info_queue, card)
    return { vars = { card.ability.extra.mult } }
end

jokerInfo.calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        if to_big(card.ability.extra.mult) > to_big(0) then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
                card = card,
            }
        end
    end
end

jokerInfo.add_to_deck = function(self, card)
    mod.tetris.load()
    mod.tetris.isActive = true
end

jokerInfo.remove_from_deck = function(self, card)
    mod.tetris.isActive = false
end

function jokerInfo.update(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
        if mod.tetris.isActive then
            card.ability.extra.mult = mod.tetris.linesCleared
            if mod.tetris.speedLevel >= 16 then
                check_for_unlock({ type = "high_tetris" })
            end
            if mod.tetris.queue and #mod.tetris.queue > 0 then
                local msg = mod.tetris.queue[1]
                if msg.type == 'line' then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}})
                elseif msg.type == 'reset' then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize('k_reset'), colour = G.C.RED})
                end
                table.remove(mod.tetris.queue, 1)
            end
        else
            card.ability.extra.mult = 0
        end
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    mod.tetris.load()
    mod.tetris.isActive = true
end

function jokerInfo.draw(self,card,layer)
    --Without love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of
    --the rendering code. We need a clean slate for rendering to canvases.
    if card.area ~= G.jokers then
        return
    end

    love.graphics.push('all')
    love.graphics.reset()
    if not card.children.center.video then
        setupCanvas(card)
    end
    card.children.center.video:renderTo(function()
        if mod.tetris.isActive then
            mod.tetris.draw(6, 6)
        end
    end)
    love.graphics.pop()
end

require = oldRequire

return jokerInfo