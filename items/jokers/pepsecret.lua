local jokerInfo = {
	name = 'Pepperoni Secret',
	config = {
		ach_hands = {}
	},
	rarity = 3,
	cost = 8,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = 'vinny',
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

local function hasPlayedSecret()
	for k, v in pairs(G.handlist) do
		if G.GAME.hands[v].visible and not SMODS.PokerHands[v].visible then
			return true
		end
	end
end

function jokerInfo.in_pool(self, args)
	if hasPlayedSecret() then
		return true
	end
end

function jokerInfo.check_for_unlock(self, args)
	if args.type ~= 'hand_contents' then return end

	local text = G.FUNCS.get_poker_hand_info(args.cards)
	for k, v in pairs(SMODS.PokerHands) do
		if k == text and v.visible == false then
			return true
		end
	end
end

function jokerInfo.calculate(self, card, context)
	if context.cardarea == G.jokers and context.before and not card.debuff then
		if not SMODS.PokerHands[context.scoring_name].visible then
			if not card.ability.ach_hands[context.scoring_name] then card.ability.ach_hands[context.scoring_name] = true end
			local secret = 0 -- tried to get the length of ach_hands but it didnt work for no reason -keku
			for k, v in pairs(card.ability.ach_hands) do secret = secret + 1 end
			if secret >= 3 then check_for_unlock({ type = "three_pepsecret" }) end
			return {
				card = card,
				level_up = true,
				message = localize('k_level_up_ex')
			}
		end
	end
end

return jokerInfo

