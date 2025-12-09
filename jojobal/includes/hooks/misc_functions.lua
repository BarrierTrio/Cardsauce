---------------------------
--------------------------- Basic Mod Functions
---------------------------

function G.FUNCS.jojobal_restart()
	local settingsMatch = true
	for k, v in pairs(JojobalMod.current_config) do
		if v ~= JojobalMod.config [k] then
			settingsMatch = false
		end
	end

	if settingsMatch then
		sendDebugMessage('Settings match')
		SMODS.full_restart = 0
	else
		sendDebugMessage('Settings mismatch, restart required')
		SMODS.full_restart = 1
	end
end

--- Resets the rank used by the Paper Moon King stand card
function jojobal_reset_paper_rank()
    G.GAME.current_round.jojobal_paper_rank = 'Jack'
	local valid_ranks = {}
    for _, rank in pairs(SMODS.Ranks) do
        if rank.face then valid_ranks[#valid_ranks+1] = rank.key end
    end
	G.GAME.current_round.jojobal_paper_rank = pseudorandom_element(valid_ranks, pseudoseed('papermoon'..G.GAME.round_resets.ante))
end





---------------------------
--------------------------- Fibonacci scoring
---------------------------

local function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

function jojobal_get_fibonacci(hand)
	local ret = {}
	if #hand < 5 then return ret end
	local vals = {}
	for i = 1, #hand do
		local value = hand[i].base.nominal
		if hand[i].base.value == 'Ace' then
			value = 1
		elseif SMODS.has_no_rank(hand[i]) then
			value = 0
		end

		vals[#vals+1] = value
	end
	table.sort(vals, function(a, b) return a < b end)

	if not vals[1] == 0 and not (is_perfect_square(5 * vals[1]^2 + 4) or is_perfect_square(5 * vals[1]^2 - 4)) then
		return ret
	end

	local sum = 0
	local prev_1 = vals[1]
	local prev_2 = 0
	for i=1, #vals do
		sum = prev_1 + prev_2

		if vals[i] ~= sum then
			return ret
		end

		prev_2 = prev_1
		prev_1 = vals[i] == 0 and 1 or vals[i]
	end

	local t = {}
	for i=1, #hand do
		t[#t+1] = hand[i]
	end

	table.insert(ret, t)
	return ret
end