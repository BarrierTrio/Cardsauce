local jokerInfo = {
	name = 'Running Hell',
	atlas = 'jokers',
	pos = {x = 1, y = 6},
	config = {
		extra = 1
	},
	rarity = 3,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = 'cardsauce',
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.in_pool(self, args)
	return not args or args.source ~= 'jud'
end

function jokerInfo.add_to_deck(self, card, context)
	ArrowAPI.game.batch_level_up(card, SMODS.PokerHands, 0)
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = 1.8,
		blockable = false,
		func = (function()
			play_area_status_text(localize('k_cavestorytext'))
			play_sound('csau_cavestorytext')
			return true
		end)
	}))
end

function jokerInfo.calculate(self, card, context)
	if context.repetition and not card.debuff  and (context.cardarea == G.play
	or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1))) then
		return {
			message = localize('k_again_ex'),
			repetitions = card.ability.extra,
			card = card
		}
	end

	if context.end_of_round and context.main_eval and G.GAME.blind:get_type() == 'Boss' then
		for _, v in pairs(G.handlist) do
			if to_big(v.level) > to_big(1) then
				ArrowAPI.game.batch_level_up(card, G.handlist, 0)
				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 1.8,
					blockable = false,
					func = (function()
						play_area_status_text(localize('k_cavestorytext'))
						play_sound('csau_cavestorytext')
						return true
					end)
				}))
				return
			end
		end
	end
end

return jokerInfo

