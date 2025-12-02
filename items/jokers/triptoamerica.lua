local jokerInfo = {
    name = "Trip To America",
    atlas = 'jokers',
	pos = {x = 9, y = 12},
    config = {
        extra = {
            mult = 0,
            mult_mod = 2,
        }
    },
    rarity = 2,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.loc_vars(self, info_queue, card)
    return { vars = { card.ability.extra.mult_mod, card.ability.extra.mult } }
end

local function all_face(hand)
    for i, v in ipairs(hand) do
        if not v:is_face() then
            return false
        end
    end
    return true
end

local goal = 10

function jokerInfo.check_for_unlock(self, args)
    if args.type == "discover_d4c" then
        return true
    end
    if args.type == 'hand_contents' then
        if all_face(args.cards) then
            G.GAME.trip_to_america_hands = (G.GAME.trip_to_america_hands or 0) + 1
        else
            G.GAME.trip_to_america_hands = 0
        end
        return to_big(G.GAME.trip_to_america_hands) >= to_big(goal)
    end
    if args.type == 'round_win' then
        G.GAME.trip_to_america_hands = 0
    end
end

function jokerInfo.calculate(self, card, context)
    if context.before and context.cardarea == G.jokers and not context.blueprint then
        local allFaces = true
        for i = 1, #context.scoring_hand do
            if not context.scoring_hand[i]:is_face() then allFaces = false end
        end
        if allFaces then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
        else
            local last_mult = card.ability.extra.mult
            card.ability.extra.mult = 0
            if to_big(last_mult) > to_big(0) then
                return {
                    card = card,
                    message = localize('k_reset')
                }
            end
        end
    end
    if to_big(card.ability.extra.mult) > to_big(0) and context.joker_main and context.cardarea == G.jokers then
        return {
            mult = card.ability.extra.mult,
        }
    end
end

return jokerInfo