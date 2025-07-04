local draw_from_deck_to_handref = G.FUNCS.draw_from_deck_to_hand
function G.FUNCS.draw_from_deck_to_hand(self, e)
	draw_from_deck_to_handref(self, e)
	if G.GAME.csau_dj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.csau_dj_drawextra = false
	end
	if G.GAME.csau_sj_drawextra then
		draw_card(G.deck, G.hand, 100, 'up', true)
		G.GAME.csau_sj_drawextra = false
	end
end

local ric_ref = reset_idol_card
function reset_idol_card()
	if G.GAME and G.GAME.wigsaw_suit then
		G.GAME.current_round.idol_card.rank = 'Ace'
		G.GAME.current_round.idol_card.suit = 'Spades'
		local valid_idol_cards = {}
		for k, v in ipairs(G.playing_cards) do
			if v.ability.effect ~= 'Stone Card' then
				if not SMODS.has_no_suit(v) and not SMODS.has_no_rank(v) and v:is_suit(G.GAME.wigsaw_suit) then
					valid_idol_cards[#valid_idol_cards+1] = v
				end
			end
		end
		if valid_idol_cards[1] then
			local idol_card = pseudorandom_element(valid_idol_cards, pseudoseed('idol'..G.GAME.round_resets.ante))
			G.GAME.current_round.idol_card.rank = idol_card.base.value
			G.GAME.current_round.idol_card.suit = idol_card.base.suit
			G.GAME.current_round.idol_card.id = idol_card.base.id
		end
	else
		ric_ref()
	end
end