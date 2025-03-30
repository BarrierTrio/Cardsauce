local jokerInfo = {
	name = 'Grey Joker',
	config = {extra = 3},
	rarity = 2,
	cost = 6,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	hasSoul = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.cejai } }
	return { vars = {card.ability.extra} }
end

function jokerInfo.calculate(self, card, context)
	if context.setting_blind and not card.getting_sliced and not card.debuff then
		if not (context.blueprint_card or card).getting_sliced then
			G.E_MANAGER:add_event(Event({func = function()
				ease_discard(card.ability.extra)
				card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "+"..localize('k_hud_discards').." Discards"})
		return true end }))
		end
	end
end

local can_discardref = G.FUNCS.can_discard
G.FUNCS.can_discard = function(e)
	if next(SMODS.find_card('j_csau_greyjoker')) then
		if to_big(G.GAME.current_round.discards_left) <= to_big(0) or to_big(#G.hand.highlighted) <= to_big(4) then
			e.config.colour = G.C.UI.BACKGROUND_INACTIVE
			e.config.button = nil
		else
			e.config.colour = G.C.RED
			e.config.button = 'discard_cards_from_highlighted'
		end
	else
		can_discardref(e)
	end
end

return jokerInfo
	