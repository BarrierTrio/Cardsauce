local jokerInfo = {
	name = 'Bunch Of Jokers',
	atlas = 'jokers',
	pos = {x = 9, y = 2},
	soul_pos = {x = 0, y = 3},
	config = {},
	rarity = 1,
	cost = 6,
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

function jokerInfo.loc_vars(self, info_queue)
	info_queue[#info_queue+1] = G.P_CENTERS.c_judgement
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.add_card({key = 'c_judgement', key_append = 'csau_reyn'})
				G.GAME.consumeable_buffer = 0
				return true
			end
		}))

		return {
			message = localize('k_plus_judge'),
			colour = G.C.PURPLE,
			card = context.blueprint_card or card
		}
	end
end

function jokerInfo.add_to_deck(self, card)
	if G.GAME.round_resets.ante == 1 then
		check_for_unlock({ type = "early_reyn" })
	end
end

return jokerInfo