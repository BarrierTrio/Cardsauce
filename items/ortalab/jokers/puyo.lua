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
    return assert(SMODS.load_file('items/ortalab/jokers/puyo/src/'..path..'.lua'))()
end

mod.puyo = require('game')

mod.puyo.directory = mod_path..'items/ortalab/jokers/puyo/'

mod.puyo.isActive = false

mod.puyo.score = 0

local loveKeyPressedRef = love.keypressed
local loveKeyReleasedRef = love.keyreleased
local loveUpdateRef = love.update
local loveDrawRef = love.draw
local controllerPressUpdateRef = Controller.button_press_update

function Controller:button_press_update(button, dt)
    if mod.puyo.isActive then
        mod.puyo.controller_press_update(self, button, dt)
    end
    controllerPressUpdateRef(self, button, dt)
end

function love.keypressed(key)
    if mod.puyo.isActive then
        mod.puyo.keypressed(key)
    end
    loveKeyPressedRef(key)
end

function love.keyreleased(key)
    if mod.puyo.isActive then
        mod.puyo.keyreleased(key)
    end
    loveKeyReleasedRef(key)
end

function love.update(dt)
    loveUpdateRef(dt)

    if mod.puyo.isActive then
        mod.puyo.update(dt)
    end
end

local jokerInfo = {
    name = "Puyo Puyo Balatro",
    config = {
        extra = {
            chips = 0
        }
    },
    rarity = 3,
    cost = 8,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    csau_filters = {
        require = {
            mods = {
                Ortalab = 'loose'
            }
        }
    },
    artist = {'Kekulism', 'GuffNFluff'}
}

mod.puyoCardBase = love.graphics.newImage(mod_path..'assets/1x/ortalab/jokers/puyo.png')

local setupCanvas = function(self)
    self.children.center.video = love.graphics.newCanvas(71,95) --why does this work lmaooooooo
    self.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(mod.puyoCardBase)
    end)
end

jokerInfo.loc_vars = function (self, info_queue, card)
    return { vars = { card.ability.extra.chips } }
end

jokerInfo.calculate = function(self, card, context)
    if context.cardarea == G.jokers and context.joker_main then
        if to_big(card.ability.extra.chips) > to_big(0) then
            return {
                chips = card.ability.extra.chips
            }
        end
    end
end

jokerInfo.add_to_deck = function(self, card)
    mod.puyo.load()
    mod.puyo.isActive = true
    mod.puyo.score = 0
end

jokerInfo.remove_from_deck = function(self, card)
    mod.puyo.isActive = false
end

function jokerInfo.update(self, card, dt)
    if G.STAGE == G.STAGES.RUN then
        if mod.puyo.isActive then
            card.ability.extra.chips = mod.puyo.score
            if mod.puyo.queue and #mod.puyo.queue > 0 then
                local msg = mod.puyo.queue[1]
                if msg.type == 'score' then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize{type = 'variable', key = 'a_chips', vars = {card.ability.extra.chips}}, colour = G.C.CHIPS})
                elseif msg.type == 'reset' then
                    card_eval_status_text(card, 'extra', nil, nil, nil, {blockable = false, message = localize('k_reset'), colour = G.C.RED})
                end
                table.remove(mod.puyo.queue, 1)
            end
        else
            card.ability.extra.chips = 0
        end
    end
end

function jokerInfo.load(self, card, card_table, other_card)
    mod.puyo.load()
    mod.puyo.isActive = true
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
        if mod.puyo.isActive then
            mod.puyo.draw(6, 6)
        end
    end)
    love.graphics.pop()
end

require = oldRequire

return jokerInfo