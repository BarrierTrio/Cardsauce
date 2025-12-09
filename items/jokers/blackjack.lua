local function isBlackjack(hand)
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

SMODS.PokerHand {
    key = "csau_Blackjack",
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
        return { next(SMODS.find_card("j_csau_blackjack")) and isBlackjack(hand) and hand or nil }
    end,
}

SMODS.PokerHand {
    key = "csau_FlushBlackjack",
    chips = 84,
    mult = 8,
    l_chips = 42,
    l_mult = 4,
    visible = false,
    example = {
        { 'C_A', true },
        { 'C_8', true },
        { 'C_5', true },
        { 'C_4', true },
        { 'C_3', true },
    },
    evaluate = function(parts, hand)
        return { next(SMODS.find_card("j_csau_blackjack")) and next(parts._flush) and isBlackjack(hand) and hand or nil }
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
    origin = 'joel',
    dependencies = {
        config = {
            ['JoelContent'] = true,
        }
    },
    artist = 'BarrierTrio/Gote'
}

function jokerInfo.check_for_unlock(self, args)
    if args.type == 'hand' and args.scoring_hand then
        local grand_total = to_big(0)
        for i, v in ipairs(args.scoring_hand) do
            local chip_val = v.base.nominal
            local bonus_chip = v.ability.perma_bonus or 0
            local total_chip = to_big(chip_val) + to_big(bonus_chip)
            grand_total = grand_total + total_chip
        end
        if grand_total == to_big(21) then
            return true
        end
    end
end

function jokerInfo.add_to_deck(self, card)
    G.GAME.hands['csau_Blackjack'].visible = true
    if G.GAME.hands.csau_FlushBlackjack.played > 0 then
        G.GAME.hands['csau_FlushBlackjack'].visible = true
    end
end

function jokerInfo.remove_from_deck(self, card, from_debuff)
    G.GAME.hands['csau_Blackjack'].visible = false
    G.GAME.hands['csau_FlushBlackjack'].visible = false
end



return jokerInfo