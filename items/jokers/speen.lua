
local shared_speen = love.graphics.newQuad(355, 95, 71, 95, 710, 1520)

local jokerInfo = {
	name = 'SPEEEEEEN',
	atlas = 'jokers',
	pos = {x = 4, y = 1},
	config = {speen_timer = 0},
	rarity = 1,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	pools = {
		["Meme"] = true
	},
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	programmer = 'DPS2004',
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	local num, _ =  SMODS.get_probability_vars(card, 1, 1, 'wheel_of_fortune')
	info_queue[#info_queue+1] = {key = "wheel2", set = "Other", vars = {num}}
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then
		return
	end

	if context.reroll_shop and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.add_card({key = 'c_wheel_of_fortune', key_append = 'csau_speen'})
				G.GAME.consumeable_buffer = 0
				return true
			end
		}))

		return {
			message = localize('k_speen'),
			colour = G.C.PURPLE,
			card = context.blueprint_card or card
		}
	end
end

function jokerInfo.update(self, card, dt)
	card.ability.speen_timer = (card.ability.speen_timer + (G.real_dt / 4)) % (math.pi * 4)
end

function jokerInfo.draw(self,card,layer)
	if card.area.config.collection and not self.discovered then
		return
	end

	prep_draw(card.children.center, 0.75, math.sin(card.ability.speen_timer) * 60)
	love.graphics.scale(1/(card.children.center.scale.x/card.children.center.VT.w), 1/(card.children.center.scale.y/card.children.center.VT.h))
    love.graphics.setColor(G.C.WHITE)

	love.graphics.draw(
	G.ASSET_ATLAS['csau_jokers'].image,
	shared_speen,
	0, 0,
	0,
	card.children.center.VT.w/(card.children.center.T.w) + math.sin(card.ability.speen_timer*4) * 0.3,
	card.children.center.VT.h/(card.children.center.T.h))
	love.graphics.pop()
	add_to_drawhash(card.children.center)
    card.children.center:draw_boundingrect()
end

return jokerInfo
