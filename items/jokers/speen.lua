local mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path:match("Mods/[^/]+")..'/'

mod.speenTimer = 0

mod.speenBase = love.graphics.newImage(mod_path..'assets/1x/jokers/speenBase.png')
mod.speenFace = love.graphics.newImage(mod_path..'assets/1x/jokers/speenFace.png')

local drawFace = function()
	local r = math.sin(mod.speenTimer/2) * 60
	local sx = math.sin(mod.speenTimer*4)
	love.graphics.draw(mod.speenFace,71/2,95/2,r,sx,1,71/2,95/2)
end

local setupCanvas = function(self)
	self.children.center.video = love.graphics.newCanvas(71,95)
	self.children.center.video:renderTo(function()
		love.graphics.clear(1,1,1,0)
		love.graphics.setColor(1,1,1,1)
		--Draw the base, then the face
		love.graphics.draw(mod.speenBase)
		drawFace()
	end)
end

local jokerInfo = {
	name = 'SPEEEEEEN',
	config = {},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "wheel2", set = "Other", vars = {G.GAME.probabilities.normal}}
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	info_queue[#info_queue+1] = {key = "codercredit", set = "Other", vars = { csau_team.dps } }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_speen" })
end

function jokerInfo.calculate(self, card, context)
	if context.reroll_shop and not card.getting_sliced and not card.debuff and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = (function()
				G.E_MANAGER:add_event(Event({
					func = function() 
						local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'car')
						card:add_to_deck()
						G.consumeables:emplace(card)
						G.GAME.consumeable_buffer = 0
						return true
					end}))   
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_speen'), colour = G.C.PURPLE})
				return true
			end)}))
	end
end

function jokerInfo.update(self, dt)
end

local loveUpdateReference = love.update

function love.update(dt)
	if mod.speenTimer and G.SETTINGS.GAMESPEED then
		mod.speenTimer = (mod.speenTimer + (dt * (G.SETTINGS.GAMESPEED / 4))) % (math.pi * 4)
	end
	loveUpdateReference(dt)
end

function jokerInfo.draw(self,card,layer)
	--Withouth love.graphics.push, .pop, and .reset, it will attempt to use values from the rest of 
	--the rendering code. We need a clean slate for rendering to canvases.
	if card.area.config.collection and not self.discovered then
		return
	end
	
	love.graphics.push('all')
		love.graphics.reset()
		if not card.children.center.video then
			--Sometimes, such as when a game is saved and loaded, the canvas gets de-initialized.
			--We need to check for this, and re-initialize it.
			setupCanvas(card)
		end
		
		card.children.center.video:renderTo(function()
			--Same as before, but this time we pass in the timer.
			love.graphics.draw(mod.speenBase)
			drawFace(mod.speenTimer)
		end)
	love.graphics.pop()
end

return jokerInfo
	