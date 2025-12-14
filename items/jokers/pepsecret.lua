local jokerInfo = {
	name = 'Pepperoni Secret',
	atlas = 'jokers',
	pos = {x = 4, y = 8},
	config = {
		extra = {
			ach_hands = {},
			num_hands = 0
		}
	},
	rarity = 3,
	cost = 8,
	unlocked = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	has_shiny = true,
	origin = {
        category = 'cardsauce',
        sub_origins = {
            'vinny',
        },
        custom_color = 'vinny'
    },
	dependencies = {
        config = {
            ['VinnyContent'] = true
        }
    },
	artist = 'BarrierTrio/Gote'
}

local function has_played_secret()
	for _, v in ipairs(G.handlist) do
		if ((type(SMODS.PokerHands[v].visible) == "function" and not SMODS.PokerHands[v]:visible() or not SMODS.PokerHands[v].visible))
			and G.GAME.hands[v].visible then
			return true
		end
	end
end

function jokerInfo.in_pool(self, args)
	if has_played_secret() then
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
	if card.debuff then return end

	if context.before and (type(SMODS.PokerHands[v].visible) ~= "function" and not SMODS.PokerHands[v].visible or (not not SMODS.PokerHands[v]:visible())) then
		if not card.ability.extra.ach_hands[context.scoring_name] then
			card.ability.extra.ach_hands[context.scoring_name] = true
			card.ability.extra.num_hands = card.ability.extra.num_hands + 1
			if card.ability.extra.num_hands >= 3 then
				check_for_unlock({ type = "three_pepsecret" })
			end
		end

		return {
			card = context.blueprint_card or card,
			level_up = true,
			message = localize('k_level_up_ex')
		}
	end
end

return jokerInfo

