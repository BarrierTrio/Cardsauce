

local function get_blackjack(hand)
    local total = 0
    local ace_count = 0
    for _, v in ipairs(hand) do
        if not SMODS.has_no_rank(v) then
            local rank = SMODS.Ranks[v.base.value]
            if rank.key == "Ace" then
                ace_count = ace_count + 1
            end
            total = total + rank.nominal
        end
    end
    while total > 21 and ace_count > 0 do
        total = total - 10
        ace_count = ace_count - 1
    end
    return total == 21
end

SMODS.PokerHandPart {
    key = 'csau_blackjack',
    prefix_config = false,
    func = function(hand)
        return get_blackjack(hand) and hand or {}
    end,
}

SMODS.PokerHand {
    key = "csau_Blackjack",
    prefix_config = false,
    chips = 21,
    mult = 6,
    l_chips = 11,
    l_mult = 3,
    visible = false,
    example = {
        { 'H_A', true },
        { 'S_7', true },
        { 'C_3', true },
    },
    evaluate = function(parts, hand)
        if not next(parts.csau_blackjack) then
            return {}
        end

        return { G.GAME.hands['csau_Blackjack'].visible and parts.csau_blackjack or nil }
    end,
}

SMODS.PokerHand {
    key = "csau_FlushBlackjack",
    prefix_config = false,
    chips = 84,
    mult = 8,
    l_chips = 42,
    l_mult = 4,
    visible = function()
        return G.GAME.hands['csau_Blackjack'].visible and G.GAME.hands.csau_Blackjack.played > 0
    end,
    example = {
        { 'C_A', true },
        { 'C_8', true },
        { 'C_5', true },
        { 'C_4', true },
        { 'C_3', true },
    },
    evaluate = function(parts, hand)
        if not next(parts.csau_blackjack) or not next(parts._flush) then
            return {}
        end

        return { G.GAME.hands['csau_Blackjack'].visible
        and SMODS.merge_lists(parts.csau_blackjack, parts._flush) or nil }
    end,
}


local jokerInfo = {
    name = "Blackjack",
    atlas = 'jokers',
	pos = {x = 1, y = 13},
    config = {},
    rarity = 2,
    cost = 6,
    unlocked = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    origin = {
        category = 'cardsauce',
        sub_origins = {
            'joel',
        },
        custom_color = 'joel'
    },
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == 'hand' and args.scoring_hand then
        local grand_total = 0
        for i, v in ipairs(args.scoring_hand) do
            local chip_val = v.base.nominal
            local bonus_chip = v.ability.perma_bonus or 0
            local total_chip = chip_val + bonus_chip
            grand_total = grand_total + total_chip
        end
        if grand_total == 21 then
            return true
        end
    end
end

function jokerInfo.add_to_deck(self, card)
    ArrowAPI.game.toggle_poker_hand('csau_Blackjack', true, card)
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    ArrowAPI.game.toggle_poker_hand('csau_Blackjack', false, card)
end

return jokerInfo