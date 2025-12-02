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
	if context.setting_blind and not card.getting_sliced and not card.debuff and not (context.blueprint_card or card).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
		G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
		G.E_MANAGER:add_event(Event({
			func = (function()
				G.E_MANAGER:add_event(Event({
					func = function()
						local _card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_judgement', 'car')
						_card:add_to_deck()
						G.consumeables:emplace(_card)
						G.GAME.consumeable_buffer = 0
						return true
					end}))
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_judge'), colour = G.C.PURPLE})
				return true
			end)}
		))
	end
end

function jokerInfo.add_to_deck(self, card)
	if G.GAME.round_resets.ante == 1 then
		check_for_unlock({ type = "early_reyn" })
	end
end

return jokerInfo