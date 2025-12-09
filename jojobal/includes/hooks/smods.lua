SMODS.current_mod.reset_game_globals = function(run_start)
    jojobal_reset_paper_rank()
end

local ref_four_fingers = SMODS.four_fingers
function SMODS.four_fingers(hand_type)
	local ret = ref_four_fingers(hand_type)
	if hand_type == 'flush' and ret > 4 and next(SMODS.find_card('c_jojobal_lands_bigmouth')) then
		ret = 4
	end
	return ret
end

local ref_hand_visible = SMODS.is_poker_hand_visible
function SMODS.is_poker_hand_visible(handname)
    if handname == 'jojobal_Fibonacci' or handname == 'jojobal_FlushFibonacci' then
		return next(SMODS.find_card('c_jojobal_steel_tusk_4'))
		and (handname == 'jojobal_Fibonacci' or G.GAME.hands[handname].played > 0)
	end

	return ref_hand_visible(handname)
end