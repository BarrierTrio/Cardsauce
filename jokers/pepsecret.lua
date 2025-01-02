local jokerInfo = {
	name = 'Pepperoni Secret',
	config = {},
	rarity = 3,
	cost = 8,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true
}

function jokerInfo.loc_vars(self, info_queue, card)
	info_queue[#info_queue+1] = {key = "guestartist0", set = "Other"}
end

local function check_secret(name)
	for i, k in ipairs(G.csau_secret_hands) do
		if k == name then
			return true
		end
	end
end

local function hasPlayedSecret()
	for k, v in ipairs(G.handlist) do
		if G.GAME.hands[v].visible and check_secret(k) then
			return true
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
		if check_secret(context.scoring_name) then
			return {
				card = self,
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
			G.csau_secret_hands[#G.csau_secret_hands + 1] = k
		end
	end
	return ret
end

return jokerInfo
	