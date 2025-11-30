function SMODS.current_mod.reset_game_globals(run_start)
    if run_start then
		G.GAME.morshu_cards = 0
		G.GAME.csau_saved_deathcards = {}

		if G.GAME.modifiers.csau_marathon then
			-- set all consumable types besides VHS to 0 shop rate
			for _, v in pairs(SMODS.ConsumableTypes) do
				if v.key ~= 'VHS' then
					local key = v.key:lower() .. '_rate'
					G.GAME[key] = 0
				end
			end
		end
    end

    jojobal_reset_paper_rank()

	G.GAME.current_round.choicevoice = { suit = 'Clubs' }
	local _poker_hands = {}
	for k, v in pairs(G.GAME.hands) do
		if v.visible then _poker_hands[#_poker_hands+1] = k end
	end
	G.GAME.current_round.choicevoice.hand = pseudorandom_element(_poker_hands, pseudoseed('voice'))
	local valid_choicevoice_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			if (G.GAME and G.GAME.wigsaw_suit and v:is_suit(G.GAME.wigsaw_suit)) or (G.GAME and not G.GAME.wigsaw_suit) then
				if G.GAME.current_round.choicevoice.hand == 'csau_Fibonacci' or G.GAME.current_round.choicevoice.hand == 'FlushFibonacci' then
					if is_perfect_square(v.base.nominal) then
						valid_choicevoice_cards[#valid_choicevoice_cards+1] = v
					end
				else
					valid_choicevoice_cards[#valid_choicevoice_cards+1] = v
				end
			end
		end
	end
	if valid_choicevoice_cards[1] then
		local randCard = pseudorandom_element(valid_choicevoice_cards, pseudoseed('marrriooOOO'..G.GAME.round_resets.ante))
		G.GAME.current_round.choicevoice.suit = randCard.base.suit
		G.GAME.current_round.choicevoice.rank = randCard.base.value
		G.GAME.current_round.choicevoice.id = randCard.base.id
	end
	G.GAME.current_round.joeycastle = { suit = 'Clubs' }
	local valid_joeycastle_cards = {}
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_joeycastle_cards[#valid_joeycastle_cards+1] = v
		end
	end
	if valid_joeycastle_cards[1] then
		local randCard_2 = pseudorandom_element(valid_joeycastle_cards, pseudoseed('fent'..G.GAME.round_resets.ante))
		G.GAME.current_round.joeycastle.suit = randCard_2.base.suit
	end
	local randCard_3 = pseudorandom_element(G.playing_cards, pseudoseed('DUANE'..G.GAME.round_resets.ante))
	G.GAME.csau_delay_duane = true
	SMODS.calculate_context({csau_duane_change = true, suit = randCard_3.base.suit})
	G.GAME.current_round.duane_suit = randCard_3.base.suit
end

local ref_wrap_straight = SMODS.wrap_around_straight
function SMODS.wrap_around_straight()
	local ret = ref_wrap_straight()
	return ret or next(SMODS.find_card('j_csau_gnorts'))
end


-- total override of this function for bootleg purposes
-- TODO: see if this can be simplified
function SMODS.find_card(key, count_debuffed)
    local results = {}
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        if area.cards then
            for _, v in pairs(area.cards) do
                if v and type(v) == 'table' and (v.config.center.key == key or (v.config.center.key == 'j_csau_bootleg' and v.ability.bootlegged_key == key))
				and (count_debuffed or not v.debuff) then
                    table.insert(results, v)
                end
            end
        end
    end
    return results
end
