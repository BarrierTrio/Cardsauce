local jokerInfo = {
	name = 'Charity Stream',
	atlas = 'jokers',
	pos = {x = 2, y = 8},
	config = {extra = {
		mult = 0,
		mult_mod = 0
	}},
	rarity = 2,
	cost = 7,
	unlocked = false,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	unlock_condition = {type = 'win_deck', deck = 'b_green'},
	origin = 'cardsauce',
	artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
	if (args.type == "win_deck" and get_deck_win_stake(self.unlock_condition.deck)) or args.type == "actuallyunlocksorry" then
		return true
	end
end

function jokerInfo.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.mult } }
end

function jokerInfo.add_to_deck(self, card)
	if not G.GAME.selected_back.effect.config.no_interest then
		G.GAME.modifiers.no_interest = true
	end
end

function jokerInfo.remove_from_deck(self, card)
	if not G.GAME.selected_back.effect.config.no_interest then
		G.GAME.modifiers.no_interest = false
	end
end

function jokerInfo.calculate(self, card, context)
	if card.debuff then return end

	if context.joker_main and to_big(card.ability.extra.mult) ~= to_big(0) then
		return {
			mult = card.ability.extra.mult,
		}

	end
	if context.blueprint then return end

	if context.end_of_round and context.main_eval then
		local scale_table = {mult_mod = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars)/5, G.GAME.interest_cap/5)}
		SMODS.scale_card(card, {
			ref_table = card.ability.extra,
			ref_value = "mult",
			scalar_table = scale_table,
			scalar_value = "mult_mod",
		})
	end
end



return jokerInfo
