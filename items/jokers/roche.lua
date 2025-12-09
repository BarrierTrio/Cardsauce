SMODS.Sound({
	key = "roche",
	path = "roche.wav"
})

SMODS.Sound({
	key = "rochedies",
	path = "roche_dies.wav"
})

local jokerInfo = {
	name = 'Motorcyclist Joker',
	atlas = 'jokers',
	pos = {x = 8, y = 1},
	config = {
		extra = {
			gil = 13
		}
	},
	rarity = 1,
	cost = 5,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote',
	va = G.SETTINGS.roche and 'Austin L. Matthews (AmtraxVA)' or nil
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.gil} }
end

function jokerInfo.remove_from_deck(self, card)
	if not G.screenwipe then
		play_sound('csau_rochedies', nil, 0.7)
		check_for_unlock({ type = "roche_destroyed" })
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.end_of_round and context.main_eval and to_big(G.GAME.dollars) <= to_big(card.ability.gil) and G.GAME.last_hand_played
	and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

		--- say_quip() function is found in `includes > hooks > card.lua`
		card:say_quip(2, nil, true, 'csau_roche')
		G.E_MANAGER:add_event(Event({
			trigger = 'before',
			blockable = false,
			blocking = false,
			func = function()
				card:add_quip('roche_voiceline', 'bm', nil, {text_alignment = "cm"})
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 7,
					blocking = false,
					func = function()
						card:remove_quip()
						return true
					end
				}))
				return true
			end
		}))

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				for _, v in pairs(G.P_CENTER_POOLS.Planet) do
					if v.config.hand_type == G.GAME.last_hand_played then
						SMODS.add_card({key = v.key})
						break
					end
				end

				G.GAME.consumeable_buffer = 0
				return true
			end
		}))

		check_for_unlock({ type = "activate_roche" })

		if not G.SETTINGS.roche then
			G.SETTINGS.roche = true
			G:save_settings()
			self.va = 'Austin L. Matthews (AmtraxVA)'
		end
	end
end

return jokerInfo