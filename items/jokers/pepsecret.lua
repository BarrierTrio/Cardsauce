local jokerInfo = {
	name = 'Pepperoni Secret',
	config = {},
	rarity = 3,
	cost = 8,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	streamer = "vinny",
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "artistcredit", set = "Other", vars = { csau_team.gote } }
end

local function check_secret(name)
	for i, k in ipairs(G.csau_secret_hands) do
		if k == name then
			return true
		end
	end
end

local function hasPlayedSecret()
	for k, v in pairs(G.handlist) do
		if G.GAME.hands[v].visible then
			if check_secret(v) then
				return true
			end
		end
	end
end

function jokerInfo.in_pool(self, args)
	if hasPlayedSecret() then
		return true
	end
end

function jokerInfo.add_to_deck(self, card)
	check_for_unlock({ type = "discover_pep" })
end

function jokerInfo.check_for_unlock(self, args)
	if args.type == "unlock_pep" then
		return true
	end
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff then
		local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(context.scoring_hand)
		if check_secret(text) then
			return {
				card = card,
				level_up = true,
				message = localize('k_level_up_ex')
			}
		end
	end
end

local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	G.csau_secret_hands = {}
	for k, v in pairs(SMODS.PokerHands) do
		if not v.visible then
			G.csau_secret_hands[#G.csau_secret_hands + 1] = v.original_key
		end
	end
	return ret
end

return jokerInfo
	
