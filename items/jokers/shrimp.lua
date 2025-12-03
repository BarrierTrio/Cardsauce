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
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	if args.type == "meat_beaten" then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.repetition and not self.debuff then
		if context.end_of_round and context.cardarea == G.hand then
			if (next(context.card_effects[1]) or #context.card_effects > 1) then
				if context.other_card.seal == 'Blue' then
					return {
						message = localize('k_again_ex'),
						repetitions = 1,
						card = card
					}
				end
			end
		end
		if context.cardarea == G.play then
			if context.other_card.seal == 'Red' then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
			if context.other_card.seal == 'Gold' then
				ease_dollars(3)
				return {
					message = localize('k_again_ex'),
					repetitions = 0,
					card = card
				}
			end
		end
		if context.cardarea == G.hand then
			if context.other_card.seal == 'Red' then
				return {
					message = localize('k_again_ex'),
					repetitions = 1,
					card = card
				}
			end
		end
	end
	if context.discard and not card.debuff then
		if context.other_card.seal == 'Purple' and to_big(#G.consumeables.cards + G.GAME.consumeable_buffer) < to_big(G.consumeables.config.card_limit) then
			G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.0,
				func = (function()
					card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
					local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, '8ba')
					_card:add_to_deck()
					G.consumeables:emplace(_card)
					G.GAME.consumeable_buffer = 0
					return true
				end)}
			))
			return {
				message = localize('k_again_ex'),
				repetitions = 1,
				card = card
			}
		end
	end
end

return jokerInfo
