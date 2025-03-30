local consumInfo = {
    name = 'Creating Rem Lezar',
    key = 'remlezar',
    set = "VHS",
    cost = 3,
    alerted = true,
    config = {
        activation = true,
        unpauseable = true,
        activated = false,
        slide_move = 0,
        slide_out_delay = 0,
        destroy = false,
    },
}

local slide_out = 8.25
local slide_mod = 0.25
local slide_out_delay = 1

function consumInfo.loc_vars(self, info_queue, card)
    info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.fenix } }
    return { vars = { } }
end

function consumInfo.calculate(self, card, context)
    if context.setting_blind and not card.getting_sliced then
        G.E_MANAGER:add_event(Event({
            func = (function()
                add_tag(Tag('tag_ethereal'))
                play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                return true
            end)
        }))
        if context.blind.boss then
            G.E_MANAGER:add_event(Event({func = function()
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.blind:disable()
                    play_sound('timpani')
                    delay(0.4)
                    return true end }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
                return true
            end }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = (function()
                G.FUNCS.destroy_tape(card)
                return true
            end)
        }))
    end
end

function consumInfo.can_use(self, card)
    if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then return true end
end

local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

mod['c_csau_'..consumInfo.key..'_tape'] = love.graphics.newImage(mod_path..'assets/1x/vhs/'..(consumInfo.tapeKey or 'blackspine')..'.png')
mod['c_csau_'..consumInfo.key..'_sleeve'] = love.graphics.newImage(mod_path..'assets/1x/vhs/'..consumInfo.key..'.png')

local setupTapeCanvas = function(self, card, tape, sleeve)
    card.children.center.video = love.graphics.newCanvas(self.width or 71, self.height or 95)
    card.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(mod[card.config.center.key..'_tape'], ((self.width or 71)/2)+card.ability.slide_move, (self.height or 95)/2,0,1,1,71/2,95/2)
        love.graphics.draw(mod[card.config.center.key..'_sleeve'],((self.width or 71)/2)-card.ability.slide_move,(self.height or 95)/2,0,1,1,71/2,95/2)
    end)
end

function consumInfo.draw(self,card,layer)
    if card.area and card.area.config.collection and not self.discovered then
        return
    end

    love.graphics.push('all')
    love.graphics.reset()
    if not card.children.center.video then
        setupTapeCanvas(self, card, mod[card.config.center.key..'_tape'], mod[card.config.center.key..'_sleeve'])
    end

    if card.ability.activated and card.ability.slide_move < slide_out then
        if card.ability.slide_out_delay < slide_out_delay then
            card.ability.slide_out_delay = card.ability.slide_out_delay + slide_mod
        else
            card.ability.slide_move = card.ability.slide_move + slide_mod
        end
    elseif not card.ability.activated and card.ability.slide_move > 0 then
        card.ability.slide_out_delay = 0
        card.ability.slide_move = card.ability.slide_move - slide_mod
    end

    card.children.center.video:renderTo(function()
        love.graphics.clear(1,1,1,0)
        love.graphics.draw(mod[card.config.center.key..'_tape'], ((self.width or 71)/2)+card.ability.slide_move, (self.height or 95)/2,0,1,1,71/2,95/2)
        love.graphics.draw(mod[card.config.center.key..'_sleeve'],((self.width or 71)/2)-card.ability.slide_move,(self.height or 95)/2,0,1,1,71/2,95/2)
    end)
    love.graphics.pop()
end

return consumInfo