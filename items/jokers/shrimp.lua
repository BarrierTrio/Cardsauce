local jokerInfo = {
	name = 'Shrimp Joker',
	atlas = 'jokers',
	pos = {x = 9, y = 7},
	soul_pos = {
		x = 0,
		y = 8,
		draw = function(self, scale_mod, rotate_mod)
			self.hover_tilt = self.hover_tilt*1.5
			self.children.floating_sprite:draw_shader('hologram', nil, self.ARGS.send_to_shader, nil, self.children.center, 2*scale_mod, 2*rotate_mod)
			self.hover_tilt = self.hover_tilt/1.5
		end
	},
	config = {},
	rarity = 2,
	cost = 6,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	return args.type == "meat_beaten"
end

function jokerInfo.calculate(self, card, context)
	if card.debuff or not context.other_card or not context.other_card.seal then return end

	local ret = {}
    if context.cardarea == G.play and context.main_scoring then
        local obj = G.P_SEALS[self.seal]
		ret.playing_card = {}
    	if obj.get_p_dollars and type(obj.get_p_dollars) == 'function' then
        	ret.playing_card.p_dollars = obj:get_p_dollars(context.other_card)
		end
    end
    if context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round then
        local end_of_round = card:get_end_of_round_effect(context)
        if end_of_round then
            ret.end_of_round = end_of_round
        end
    end

    if card.seal then
        local seals = card:calculate_seal(context)
        if seals then
            ret.seals = seals
        end
    end

    return ret
end

return jokerInfo
