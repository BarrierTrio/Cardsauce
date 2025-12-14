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
	if card.debuff then return end

	if context.other_card and context.other_card.seal and context.main_scoring then
		local ret = {}

		-- gold seal hardcoded
		if context.cardarea == G.play and context.other_card.seal == 'Gold' then
			ret.playing_card = {p_dollars = 3}
		-- blue seal hardcoded
		elseif context.end_of_round and context.cardarea == G.hand and context.playing_card_end_of_round and context.other_card.seal == 'Blue' then
			card:get_end_of_round_effect(context)
		else
			-- red and purple both handled by this + arbitrary seal effects
			local seals = card:calculate_seal(context)
			if seals then
				ret.seals = seals
			end
		end

		local flags = SMODS.trigger_effects({ret}, context.other_card)
		SMODS.update_context_flags(context, flags)
	end
end

return jokerInfo
