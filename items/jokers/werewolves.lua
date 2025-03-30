local jokerInfo = {
	name = 'That\'s Werewolves',
	config = {
		extra = {
			x_mult = 3,
			hand = "Flush"
		}
	},
	rarity = 3,
	cost = 7,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
	return { vars = {card.ability.extra.x_mult, localize(card.ability.extra.hand, 'poker_hands')} }
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_werewolves" })
end

function jokerInfo.set_ability(self, card, initial, delay_sprites)
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then _poker_hands[#_poker_hands+1] = k end
	end
	card.ability.extra.hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_werewolves' or 'werewolves'))
end

local triggered = false
local debuff_hand_ref = Blind.debuff_hand

function Blind:debuff_hand(cards, hand, handname, check)
	if next(SMODS.find_card('j_csau_werewolves')) then
		local werewolves = SMODS.find_card('j_csau_werewolves')
		if handname == werewolves[1].ability.extra.hand then
			triggered = true
			return true
		end
		triggered = false
	else
		triggered = false
	end
	return debuff_hand_ref(self, cards, hand, handname, check)
end

local get_loc_debuff_textref = Blind.get_loc_debuff_text
function Blind:get_loc_debuff_text()
	if triggered then
		return localize("k_werewolves")
	end
	return get_loc_debuff_textref(self)
end

function jokerInfo.calculate(self, card, context)
	if context.joker_main and context.cardarea == G.jokers then
		return {
			message = localize{type='variable',key='a_xmult',vars={to_big(card.ability.extra.x_mult)}},
			Xmult_mod = card.ability.extra.x_mult, 
		}
	end
	if context.end_of_round and G.GAME.blind.boss and not context.other_card then
		local _poker_hands = {}
		for k, v in pairs(G.GAME.hands) do
			if v.visible then _poker_hands[#_poker_hands+1] = k end
		end
		card.ability.extra.hand = pseudorandom_element(_poker_hands, pseudoseed((card.area and card.area.config.type == 'title') and 'false_werewolves' or 'werewolves'))
	end
end



return jokerInfo
	