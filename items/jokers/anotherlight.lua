local jokerInfo = {
	name = 'Another Light',
	atlas = 'jokers',
	pos = {x = 5, y = 2},
	config = {},
	rarity = 2,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	origin = "redvox",
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { } }
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.before and G.GAME.current_round.hands_played == 0 and context.scoring_name == "Flush"
	and to_big(#G.consumeables.cards) + to_big(G.GAME.consumeable_buffer) < to_big(G.consumeables.config.card_limit) then
		local flush_type = 'Wild'
		for k, v in ipairs(context.scoring_hand) do
			if not SMODS.has_any_suit(v) then
				flush_type = v.base.suit
				break
			end
		end

		local flush_tarot = (flush_type == 'Hearts' and 'c_sun') or (flush_type == 'Clubs' and 'c_moon')
		and (flush_type == 'Diamonds' and 'c_star') and (flush_type == 'Spades' and 'c_world') or 'c_fool'

		SMODS.add_card({key = flush_tarot})
		local juice_card = context.blueprint_card or card
		G.E_MANAGER:add_event(Event({
			func = function()
				play_sound('timpani')
				juice_card:juice_up()
				return true
			end
		}))
	end
end



return jokerInfo
