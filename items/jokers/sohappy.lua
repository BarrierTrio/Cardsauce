local jokerInfo = {
	name = "I'm So Happy",
	atlas = 'jokers',
	pos = {x = 6, y = 2},
	config = {
		extra = {
			side = 'happy',
			plus = 2,
			minus = 1,
		},
	},
	rarity = 2,
	cost = 6,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
	origin = 'redvox',
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = {card.ability.extra.plus, card.ability.extra.minus}, key = 'j_csau_so'..card.ability.extra.side}
end

local function hand_discard_mod(hand_mod, discard_mod)
	G.GAME.round_resets.hands = G.GAME.round_resets.hands + hand_mod
	ease_hands_played(hand_mod)
	G.GAME.round_resets.discards = G.GAME.round_resets.discards + discard_mod
	ease_discard(discard_mod)
end

function jokerInfo.add_to_deck(self, card, from_debuff)
	if card.ability.extra.side == 'happy' then
		hand_discard_mod(card.ability.extra.plus, -card.ability.extra.minus)
	elseif card.ability.side == 'sad' then
		hand_discard_mod(-card.ability.extra.minus, card.ability.extra.plus)
	end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
	if card.ability.extra.side == 'happy' then
		hand_discard_mod(-card.ability.extra.plus, card.ability.extra.minus)
	elseif card.ability.side == 'sad' then
		hand_discard_mod(card.ability.extra.minus, -card.ability.extra.plus)
	end
end

function jokerInfo.load(self, card, cardTable, other_card)
	card.children.front:set_sprite_pos({x = cardTable.ability.extra.side == 'sad' and 7 or 6, y = 2})
end

function jokerInfo.calculate(self, card, context)
	if context.end_of_round and not context.blueprint and context.main_eval then
		card.ability.extra.side = card.ability.extra.side == 'sad' and 'happy' or 'sad'
		local hand_mod, discard_mod, colour = 1, -1, G.C.MULT
		if card.ability.extra.side == 'sad' then
			check_for_unlock({ type = "flip_sosad" })
			hand_mod, discard_mod, colour = -1, 1, G.C.CHIPS
		end

		hand_discard_mod(hand_mod * (card.ability.extra.plus + card.ability.extra.minus), discard_mod * (card.ability.extra.plus + card.ability.extra.minus))

		card.children.front:set_sprite_pos({x = card.ability.extra.side == 'sad' and 7 or 6, y = 2})

		card.VT.r = math.pi
		card.T.r = math.pi

		return {
			message = localize('k_flip'),
			colour = colour
		}

	end
end

return jokerInfo
