SMODS.Sound({
	key = "cavestorytext",
	path = "cavestorytext.ogg"
})

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

function jokerInfo.add_to_deck(self, card, from_debuff)
	if from_debuff then return end

	local highest = ArrowAPI.game.get_hand_level_metric('highest')
	if highest <= 1 then return end

	ArrowAPI.game.batch_level_up(card, G.handlist, 0)
	G.E_MANAGER:add_event(Event({
		func = function()
			attention_text({
				scale = 0.9, text = localize('k_cavestorytext'), hold = 1.5, align = 'tm',
				major = G.play, offset = {x = 0, y = -1}
			})
			G.ROOM.jiggle = G.ROOM.jiggle + 2
			play_sound('csau_cavestorytext')
			return true
		end
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

	if context.end_of_round and context.main_eval and G.GAME.blind:get_type() == 'Boss' and ArrowAPI.game.get_hand_level_metric('highest') > 1 then
		ArrowAPI.game.batch_level_up(card, G.handlist, 0)
		G.E_MANAGER:add_event(Event({
			func = function()
				attention_text({
					scale = 0.9, text = localize('k_cavestorytext'), hold = 1.5, align = 'tm',
					major = G.play, offset = {x = 0, y = -1}
				})
				G.ROOM.jiggle = G.ROOM.jiggle + 2
				play_sound('csau_cavestorytext')
				return true
			end
		}))
	end
end

return jokerInfo

